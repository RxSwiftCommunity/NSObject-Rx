import XCTest
import RxSwift
@testable import NSObject_Rx

class MockNSObject: NSObject {
}

class DisposableObject: HasDisposeBag {
}

class NSObject_RxTests: XCTestCase {

    private var mockNSObject: MockNSObject!
    private var disposableObject: DisposableObject!

    override func setUp() {
        super.setUp()
        self.mockNSObject = MockNSObject()
        self.disposableObject = DisposableObject()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNSObject() {
        XCTAssertNotNil(self.mockNSObject.rx.disposeBag)
        let newDisposeBag = DisposeBag()
        self.mockNSObject.rx.disposeBag = newDisposeBag
        let address1 = Unmanaged<AnyObject>.passUnretained(self.mockNSObject.rx.disposeBag as AnyObject).toOpaque()
        let address2 = Unmanaged<AnyObject>.passUnretained(newDisposeBag as AnyObject).toOpaque()
        XCTAssert(address1 == address2)
    }

    func testDisposeBagable() {
        XCTAssertNotNil(self.disposableObject.disposeBag)
        let newDisposeBag = DisposeBag()
        self.disposableObject.disposeBag = newDisposeBag
        let address1 = Unmanaged<AnyObject>.passUnretained(self.disposableObject.disposeBag as AnyObject).toOpaque()
        let address2 = Unmanaged<AnyObject>.passUnretained(newDisposeBag as AnyObject).toOpaque()
        XCTAssert(address1 == address2)
    }
}

