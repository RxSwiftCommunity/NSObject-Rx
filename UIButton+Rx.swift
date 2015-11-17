import UIKit
import RxSwift
import RxCocoa
import ObjectiveC

public extension UIButton {
    private struct AssociatedKeys {
        static var Action = "rx_action"
        static var DisposeBag = "rx_diposeBag"
    }

    /// Binds enabled state of action to button, and subscribes to rx_tap to execute action.
    /// These subscriptions are managed in a private, inaccessible dispose bag. To cancel
    /// them, set the rx_action to nil or another action.
    public var rx_action: Action? {
        get {
            var action: Action?
            doLocked {
                action = objc_getAssociatedObject(self, &AssociatedKeys.Action) as? Action
            }
            return action
        }

        set {
            doLocked {
                objc_setAssociatedObject(self, &AssociatedKeys.Action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                // This effectively disposes of any existing subscriptions.
                self.resetActionDisposeBag()

                if let action = newValue {
                    action.enabled.bindTo(self.rx_enabled).addDisposableTo(self.actionDisposeBag)
                    self.rx_tap.subscribeNext { _ -> Void in
                        action.execute()
                    }.addDisposableTo(self.actionDisposeBag)
                }
            }
        }
    }
}

// Note: Actions performed in this extension are _not_ locked
// So be careful!
private extension UIButton {

    // A dispose bag to be used exclusively for the instance's rx_action.
    // We use a separate DisposeBag to operate indepdenctly from the rx_disposeBag.
    private var actionDisposeBag: DisposeBag {
        var disposeBag: DisposeBag

        let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag
        if let lookup = lookup {
            disposeBag = lookup
        } else {
            let newDisposeBag = DisposeBag()
            self.rx_disposeBag = newDisposeBag
            disposeBag = newDisposeBag
        }

        return disposeBag
    }

    // Resets the actionDisposeBag to nil, disposeing of any subscriptions within it.
    func resetActionDisposeBag() {
        objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
