//
//  RxSwizzling.h
//  Pods
//
//  Created by Segii Shulga on 4/13/16.
//
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

typedef void (^RxInvocationCallback)(id host, SEL aliasSelector);

SEL RxAliasForSelector(SEL originalSelector);

Class RxSwizzleClass(NSObject *self, RxInvocationCallback onNext);

void RxReplaceMethod(Class class, SEL selector, SEL aliasSelector, Method method);
