import Quick
import Nimble
import RxSwift
import NSObject_Rx
import Foundation

class Test: QuickSpec {
    override func spec() {
        it("respects setter") {
            let subject = NSObject()
            let disposeBag = DisposeBag()
            subject.rx_disposeBag = disposeBag

            expect(subject.rx_disposeBag) === disposeBag
        }

        it("diposes when object is deallocated") {
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
        
        it("should have same observable for same selector") {
            let mock = Mock()
            let observable1 = mock.rx_observableForSelector(#selector(Mock.funcWithOutParams))
            let observable2 = mock.rx_observableForSelector(#selector(Mock.funcWithOutParams))
            
            expect(observable1) === observable2
        }
        
        it("should have different observables for different selectors") { 
            let mock = Mock()
            let observable1 = mock.rx_observableForSelector(#selector(Mock.funcWithOutParams))
            let observable2 = mock.rx_observableForSelector(#selector(Mock.funcWithParamsReturnsVoid(_:)))
            
            expect(observable1) !== observable2
        }
        
        it("observes selector for method without params") {
            var completed = false
            var nextCalled = false
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWithOutParams))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            mock?.funcWithOutParams()
            mock = nil
            expect(completed) == true
            expect(nextCalled) == true
        }
        
        it("observes selector for method which returns bool") {
            var completed = false
            var nextCalled = false
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWhichReturnsBool))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            _ = mock?.funcWhichReturnsBool()
            mock = nil
            expect(completed) == true
            expect(nextCalled) == true
        }
        
        it("observes selector for method which returns object") { 
            var completed = false
            var nextCalled = false
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWithParamsReturnsParam(_:)))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            _ = mock?.funcWithParamsReturnsParam(1)
            mock = nil
            expect(completed) == true
            expect(nextCalled) == true
        }
        
        it("calls observed method") { 
            var completed = false
            var nextCalled = false
            var methodCalled = false
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWithClosure(_:)))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            _ = mock?.funcWithClosure({ 
                methodCalled = true
            })
            mock = nil
            expect(completed) == true
            expect(nextCalled) == true
            expect(methodCalled) == true
        }
        
        it("send next every time method invoked") { 
            var completed = false
            var count = 0
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWithOutParams))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        count += 1
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            mock?.funcWithOutParams()
            mock?.funcWithOutParams()
            mock = nil
            expect(completed) == true
            expect(count) == 2
        }
        
        it("send events when perform selector called") {
            var completed = false
            var nextCalled = false
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWithOutParams))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            mock?.performSelector(#selector(Mock.funcWithOutParams))
            mock = nil
            expect(completed) == true
            expect(nextCalled) == true
        }
        
        it("should send events for KVO'd object") { 
            var completed = false
            var nextCalled = false
            let numberToChange: NSNumber = 2
            var numberChanged: NSNumber?
            var mock: Mock? = Mock()
            
            _ = mock?.rx_observeWeakly(NSNumber.self, "number", options: [.New])
                .subscribeNext({ (n) in
                    numberChanged = n
                })
            
            _ = mock?.rx_observableForSelector(#selector(Mock.funcWithOutParams))
                .subscribe { (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Completed:
                        completed = true
                    default : break
                    }
            }
            _ = mock?.rx_deallocating.subscribeNext {
                print("")
            }
            
            mock?.number = numberToChange
            mock?.funcWithOutParams()
            
            expect(numberChanged).toNot(beNil())
            expect(numberChanged) == numberToChange
            
            mock = nil
            
            expect(completed) == true
            expect(nextCalled) == true
        }
 
        it("responds to original selector") {
            let mock = Mock()
            _ = mock.rx_observableForSelector(#selector(Mock.funcWithOutParams))
            
            expect(mock.respondsToSelector(#selector(Mock.funcWithOutParams))) == true
        }
        
        it("is member of class") { 
            let mock = Mock()
            _ = mock.rx_observableForSelector(#selector(Mock.funcWithOutParams))
            
            expect(mock.isKindOfClass(Mock)) == true
        }
        
        it("is member of the same class") { 
            let mock = Mock()
            _ = mock.rx_observableForSelector(#selector(Mock.funcWithOutParams))
            
            expect(mock.isMemberOfClass(Mock)) == true
        }
        
        it("sends error if object does not respond to selector") { 
            let mock = Mock()
            var error: ErrorType?
            var nextCalled = false
            var completed = false
            _ = mock.rx_observableForSelector(#selector(NSMutableArray.addObject(_:)))
                .subscribe({ (event) in
                    switch event {
                    case .Next:
                        nextCalled = true
                    case .Error(let err):
                        error = err
                    case .Completed:
                        completed = false
                    }
                })
            mock.funcWithOutParams()
            
            expect(error).toNot(beNil())
            expect(nextCalled) == false
            expect(completed) == false
        }
        
    }
}
