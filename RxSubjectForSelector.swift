//
//  RxSubjectForSelector.swift
//  Pods
//
//  Created by Segii Shulga on 4/13/16.
//
//

import class RxSwift.Observable
import class RxSwift.PublishSubject
import RxCocoa

private struct AssociationKey {
    static var subjectsDictionaryAssosiatedKey = "RXSubjectsDictionaryAssosiatedKey"
}

func RxSubjectForSelector(host: NSObject, selector: Selector) -> PublishSubject<Void> {
    objc_sync_enter(host); defer { objc_sync_exit(host) }
    let aliasSelector = RxAliasForSelector(selector)
    
    return lazySubjectForSelector(host, selector: aliasSelector, factory: { _ -> PublishSubject<Void> in
        let subject = PublishSubject<Void>()
        let clas: AnyClass! = RxSwizzleClass(host) { (h, sel) in
            let subject = RxSubjectForSelector(h as! NSObject, selector: sel)
            subject.onNext()
        }
        let targetMehtod = class_getInstanceMethod(clas, selector)
        _ = host.rx_deallocating.subscribeNext(subject.onCompleted)
        RxReplaceMethod(clas, selector, aliasSelector, targetMehtod)
        
        return subject
    })
}

func lazySubjectForSelector(host: AnyObject, selector: Selector, factory: () -> PublishSubject<Void>) -> PublishSubject<Void> {
    let selectorsDict = lazyAssociatedProperty(host, key: &AssociationKey.subjectsDictionaryAssosiatedKey) {
        return NSMutableDictionary()
    }
    guard let subject = selectorsDict[selector.description] as? PublishSubject<Void> else {
        selectorsDict[selector.description] = factory()
        return lazySubjectForSelector(host, selector: selector, factory: factory)
    }
    return subject
}

func lazyAssociatedProperty<T: AnyObject>(host: AnyObject,
                            key: UnsafePointer<Void>,
                            policy: objc_AssociationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN,
                            factory: () -> T ) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, policy)
        return associatedProperty
    }()
}
