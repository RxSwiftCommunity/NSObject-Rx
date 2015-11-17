import Foundation
import RxSwift

public final class Action {
    public typealias Closure = () -> Void

    public let enabled: Observable<Bool>
    public let closure: Closure

    private let _errors = PublishSubject<ErrorType>()
    public var errors: Observable<ErrorType> {
        return self._errors.asObservable()
    }

    public init(enabled: Observable<Bool>, closure: Closure) {
        self.enabled = enabled
        self.closure = closure
    }

    public convenience init(closure: Closure) {
        self.init(enabled: just(true), closure: closure)
    }

    public func execute() {

    }
}
