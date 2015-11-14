import Foundation
import RxSwift
import ObjectiveC

public extension NSObject {
    private struct AssociatedKeys {
        static var DisposeBag = "rx_diposeBag"
    }

    private func doLocked(closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        closure()
    }

    var rx_disposeBag: DisposeBag {
        get {
            var lookup: DisposeBag?
            doLocked {
                lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag
            }

            guard let disposeBag = lookup else {
                let newDisposeBag = DisposeBag()
                self.rx_disposeBag = newDisposeBag
                return newDisposeBag
            }

            return disposeBag
        }

        set {
            doLocked {
                objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
