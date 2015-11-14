import Quick
import Nimble
import RxSwift
import NSObject_Rx

class Test: QuickSpec {
    override func spec() {
        it("something") {
            var executed = false
            let variable = PublishSubject<Int>()

            // Force the bag to deinit (and dispose itself).
            do {
                let subject = NSObject()
                variable.subscribeNext { _ in
                    executed = true
                }.addDisposableTo(subject.rx_disposeBag)
            }

            // Force a new value through the subscription to test its been disposed of.
            variable.onNext(1)
            expect(executed) == false
        }
    }
}
