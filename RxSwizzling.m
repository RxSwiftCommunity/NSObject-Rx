//
//  RxSwizzling.m
//  Pods
//
//  Created by Segii Shulga on 4/13/16.
//
//

#import "RxSwizzling.h"

/* 
Most of implementation has been taken from RAC.
For more details https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/ReactiveCocoa/Objective-C/NSObject%2BRACSelectorSignal.m
*/

static NSString * const RxObservableForSelectorAliasPrefix = @"rx_alias_";
static NSString * const RxSubclassSuffix = @"_RxSelectorSubject";
static void *RxSubclassAssociationKey = &RxSubclassAssociationKey;

static NSMutableSet *swizzledClasses() {
    static NSMutableSet *set;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        set = [[NSMutableSet alloc] init];
    });
    
    return set;
}

static BOOL RXForwardInvocation(id self, NSInvocation *invocation, RxInvocationCallback callback) {
    SEL aliasSelector = RxAliasForSelector(invocation.selector);
    SEL originalSelector = invocation.selector;
    
    Class class = object_getClass(invocation.target);
    BOOL respondsToAlias = [class instancesRespondToSelector:invocation.selector];
    if (respondsToAlias) {
        invocation.selector = aliasSelector;
        [invocation invoke];
    }
    callback(self, originalSelector);
    return YES;
}

Method RxGetImmediateInstanceMethod (Class aClass, SEL aSelector) {
    unsigned methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    Method foundMethod = NULL;
    
    for (unsigned methodIndex = 0;methodIndex < methodCount;++methodIndex) {
        if (method_getName(methods[methodIndex]) == aSelector) {
            foundMethod = methods[methodIndex];
            break;
        }
    }
    
    free(methods);
    return foundMethod;
}


static void RxSwizzleForwardInvocation(Class class, RxInvocationCallback callback) {
    SEL forwardInvocationSEL = @selector(forwardInvocation:);
    Method forwardInvocationMethod = class_getInstanceMethod(class, forwardInvocationSEL);
    
        // Preserve any existing implementation of -forwardInvocation:.
    void (*originalForwardInvocation)(id, SEL, NSInvocation *) = NULL;
    if (forwardInvocationMethod != NULL) {
        originalForwardInvocation = (__typeof__(originalForwardInvocation))method_getImplementation(forwardInvocationMethod);
    }
    
    id newForwardInvocation = ^(id self, NSInvocation *invocation) {
        BOOL matched = RXForwardInvocation(self, invocation, callback);
        if (matched) return;
        
        if (originalForwardInvocation == NULL) {
            [self doesNotRecognizeSelector:invocation.selector];
        } else {
            originalForwardInvocation(self, forwardInvocationSEL, invocation);
        }
    };
    
    class_replaceMethod(class, forwardInvocationSEL, imp_implementationWithBlock(newForwardInvocation), "v@:@");
}

static void RxSwizzleRespondsToSelector(Class class) {
    SEL respondsToSelectorSEL = @selector(respondsToSelector:);
    
        // Preserve existing implementation of -respondsToSelector:.
    Method respondsToSelectorMethod = class_getInstanceMethod(class, respondsToSelectorSEL);
    BOOL (*originalRespondsToSelector)(id, SEL, SEL) = (__typeof__(originalRespondsToSelector))method_getImplementation(respondsToSelectorMethod);
    
    id newRespondsToSelector = ^ BOOL (id self, SEL selector) {
        Method method = RxGetImmediateInstanceMethod(class, selector);
        
        if (method != NULL && method_getImplementation(method) == _objc_msgForward) {
            SEL aliasSelector = RxAliasForSelector(selector);
            if (objc_getAssociatedObject(self, aliasSelector) != nil) return YES;
        }
        
        return originalRespondsToSelector(self, respondsToSelectorSEL, selector);
    };
    
    class_replaceMethod(class, respondsToSelectorSEL, imp_implementationWithBlock(newRespondsToSelector), method_getTypeEncoding(respondsToSelectorMethod));
}

static void RxSwizzleGetClass(Class class, Class statedClass) {
    SEL selector = @selector(class);
    Method method = class_getInstanceMethod(class, selector);
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return statedClass;
    });
    class_replaceMethod(class, selector, newIMP, method_getTypeEncoding(method));
}

static void RxSwizzleMethodSignatureForSelector(Class class) {
    IMP newIMP = imp_implementationWithBlock(^(id self, SEL selector) {
            // Don't send the -class message to the receiver because we've changed
            // that to return the original class.
        Class actualClass = object_getClass(self);
        Method method = class_getInstanceMethod(actualClass, selector);
        if (method == NULL) {
                // Messages that the original class dynamically implements fall
                // here.
                //
                // Call the original class' -methodSignatureForSelector:.
            struct objc_super target = {
                .super_class = class_getSuperclass(class),
                .receiver = self,
            };
            NSMethodSignature * (*messageSend)(struct objc_super *, SEL, SEL) = (__typeof__(messageSend))objc_msgSendSuper;
            return messageSend(&target, @selector(methodSignatureForSelector:), selector);
        }
        
        char const *encoding = method_getTypeEncoding(method);
        return [NSMethodSignature signatureWithObjCTypes:encoding];
    });
    
    SEL selector = @selector(methodSignatureForSelector:);
    Method methodSignatureForSelectorMethod = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, newIMP, method_getTypeEncoding(methodSignatureForSelectorMethod));
}

// It's hard to tell which struct return types use _objc_msgForward, and
// which use _objc_msgForward_stret instead, so just exclude all struct, array,
// union, complex and vector return types.
static void RxCheckTypeEncoding(const char *typeEncoding) {
#if !NS_BLOCK_ASSERTIONS
// Some types, including vector types, are not encoded. In these cases the
// signature starts with the size of the argument frame.
    NSCAssert(*typeEncoding < '1' || *typeEncoding > '9', @"unknown method return type not supported in type encoding: %s", typeEncoding);
    NSCAssert(strstr(typeEncoding, "(") != typeEncoding, @"union method return type not supported");
    NSCAssert(strstr(typeEncoding, "{") != typeEncoding, @"struct method return type not supported");
    NSCAssert(strstr(typeEncoding, "[") != typeEncoding, @"array method return type not supported");
    NSCAssert(strstr(typeEncoding, @encode(_Complex float)) != typeEncoding, @"complex float method return type not supported");
    NSCAssert(strstr(typeEncoding, @encode(_Complex double)) != typeEncoding, @"complex double method return type not supported");
    NSCAssert(strstr(typeEncoding, @encode(_Complex long double)) != typeEncoding, @"complex long double method return type not supported");
#endif // !NS_BLOCK_ASSERTIONS
}

SEL RxAliasForSelector(SEL originalSelector) {
    NSString *selectorName = NSStringFromSelector(originalSelector);
    return NSSelectorFromString([RxObservableForSelectorAliasPrefix stringByAppendingString:selectorName]);
}

Class RxSwizzleClass(NSObject *self, RxInvocationCallback callback) {
    Class statedClass = self.class;
    Class baseClass = object_getClass(self);
    
    Class knownDynamicSubclass = objc_getAssociatedObject(self, RxSubclassAssociationKey);
    if (knownDynamicSubclass != Nil) return knownDynamicSubclass;
    
    NSString *className = NSStringFromClass(baseClass);
    
    if (statedClass != baseClass) {
        // If the class is already lying about what it is, it's probably a KVO
        // dynamic subclass or something else that we shouldn't subclass
        // ourselves.
        //
        // Just swizzle -forwardInvocation: in-place. Since the object's class
        // was almost certainly dynamically changed, we shouldn't see another of
        // these classes in the hierarchy.
        //
        // Additionally, swizzle -respondsToSelector: because the default
        // implementation may be ignorant of methods added to this class.
        @synchronized (swizzledClasses()) {
            if (![swizzledClasses() containsObject:className]) {
                RxSwizzleForwardInvocation(baseClass, callback);
                RxSwizzleRespondsToSelector(baseClass);
                RxSwizzleGetClass(baseClass, statedClass);
                RxSwizzleGetClass(object_getClass(baseClass), statedClass);
                RxSwizzleMethodSignatureForSelector(baseClass);
                [swizzledClasses() addObject:className];
            }
        }
        
        return baseClass;
    }
    
    const char *subclassName = [className stringByAppendingString:RxSubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);
    
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);
        if (subclass == nil) return nil;
        
        RxSwizzleForwardInvocation(subclass, callback);
        RxSwizzleRespondsToSelector(subclass);
        
        RxSwizzleGetClass(subclass, statedClass);
        RxSwizzleGetClass(object_getClass(subclass), statedClass);
        
        RxSwizzleMethodSignatureForSelector(subclass);
        
        objc_registerClassPair(subclass);
    }
    
    object_setClass(self, subclass);
    objc_setAssociatedObject(self, RxSubclassAssociationKey, subclass, OBJC_ASSOCIATION_ASSIGN);
    return subclass;
}

void RxReplaceMethod(Class class, SEL selector, SEL aliasSelector, Method method) {
    if (method_getImplementation(method) != _objc_msgForward) {
        RxCheckTypeEncoding(method_getTypeEncoding(method));
        class_addMethod(class, aliasSelector, method_getImplementation(method), method_getTypeEncoding(method));
        class_replaceMethod(class, selector, _objc_msgForward, method_getTypeEncoding(method));
    }
}
