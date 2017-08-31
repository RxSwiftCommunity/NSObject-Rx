import Foundation
import RxSwift
import ObjectiveC

extension NSObject: HasDisposeBag {
}

public extension Reactive where Base: HasDisposeBag {

    /// a unique DisposeBag that is related to the Reactive.Base instance
    var disposeBag: DisposeBag {
        get { return base.disposeBag }
        set {
            var mutableBase = base
            mutableBase.disposeBag = newValue
        }
    }
}
