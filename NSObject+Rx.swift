import Foundation
import RxSwift
import ObjectiveC

public extension NSObject {
    private struct AssociatedKeys {
        static var DisposeBag = "rx_diposeBag"
    }

    var rx_disposeBag: DisposeBag {
        get {
            guard let disposeBag = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag else {
                let newDisposeBag = DisposeBag()
                self.rx_disposeBag = newDisposeBag
                return newDisposeBag
            }
            return disposeBag
        }

        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
