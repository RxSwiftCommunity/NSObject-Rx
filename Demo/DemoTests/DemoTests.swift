import Quick
import Nimble
import RxSwift
import NSObject_Rx

class Test: QuickSpec {
    override func spec() {
        it("something") {
            var executed = false
            let variable = Variable(0)

            do {
                let subject = NSObject()
                variable.subscribeNext { _ in
                    executed = true
                }.addDisposableTo(subject.rx_disposeBag)
                // Force the old bag to deinit and dispose itself.
                subject.rx_disposeBag = DisposeBag()
            }

            // Force a new value through the subscription
            variable.value = 1

            expect(executed) == false
        }
    }
}
