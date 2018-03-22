import Quick
import Nimble
import RxSwift
import NSObject_Rx

class DisposeBagTest: HasDisposeBag {}

class Test: QuickSpec {
    override func spec() {
        
        it("should respects the setter") {
            var subject = NSObject()
            let disposeBag = DisposeBag()
            subject.rx.disposeBag = disposeBag
            let subjectProtocol = DisposeBagTest()
            subjectProtocol.disposeBag = disposeBag
            expect(subject.rx.disposeBag) === disposeBag
            expect(subjectProtocol.disposeBag) === disposeBag
        }

        it("should dispose when the object is deallocated") {
            var executed = false
            var executedProtocol = false

            let variable = PublishSubject<Int>()
            let variableProtocol = PublishSubject<Int>()

            // Force the bag to deinit (and dispose itself).
            do {
                let subject = NSObject()
                let subjectProtocol = DisposeBagTest()

                variable.subscribe(onNext: { _ in executed = true })
                    .disposed(by: subject.rx.disposeBag)
                
                variableProtocol.subscribe(onNext: { _ in executedProtocol = true })
                    .disposed(by: subjectProtocol.disposeBag)
            }

            // Force a new value through the subscription to test its been disposed of.
            variable.onNext(1)
            variableProtocol.onNext(1)
            expect(executed) == false
            expect(executedProtocol) == false
        }

        it("should disposes using rx.disposeBag") {
            var executed = false
            let variable = PublishSubject<Int>()

            do {
                let subject = NSObject()

                variable.subscribe(onNext: { _ in executed = true })
                    .disposed(by: subject.rx.disposeBag)
            }

            variable.onNext(1)
            expect(executed) == false
        }
    }
}
