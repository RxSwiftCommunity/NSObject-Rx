import Foundation
import RxSwift
import ObjectiveC

public extension NSObject {
    private struct AssociatedKeys {
        static var DisposeBag = "rx_disposeBag"
    }

    private func doLocked(closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        closure()
    }

    var rx_disposeBag: DisposeBag {
        get {
            var disposeBag: DisposeBag!
            doLocked {
                let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag
                if let lookup = lookup {
                    disposeBag = lookup
                } else {
                    let newDisposeBag = DisposeBag()
                    self.rx_disposeBag = newDisposeBag
                    disposeBag = newDisposeBag
                }
            }
            return disposeBag
        }

        set {
            doLocked {
                objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    /**
     Creates a observable associated with the receiver, which will send event
     each time the given selector is invoked
     
     
     - parameter selector: The selector for whose invocations are to be observed
     
     - returns: Observable which will propagate event every time invocation of the selector,
     then completes when the receiver is deallocated. 
     If object does not respond to selector returns Observable which fails
     */
    func rx_observableForSelector(selector: Selector) -> Observable<Void> {
        if !self.respondsToSelector(selector) {
            let message = "Object \(self) does not respond to selector \(selector)"
            return Observable.error(NSError(domain: "RxSelectorObservableErrorDomain",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey : message]))
        }
        return RxSubjectForSelector(self, selector: selector)
    }
}
