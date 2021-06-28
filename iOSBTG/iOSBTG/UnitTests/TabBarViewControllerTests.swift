import XCTest

@testable import iOSBTG

class TabBarViewControllerTests: XCTestCase {


    var sut: TabBarViewController!

    override func setUp() {
        super.setUp()
        sut = TabBarViewController()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_tab_viewControllers_setup() {
        sut.viewDidLoad()
        XCTAssert(sut.viewControllers?.count == 2)
        XCTAssert(sut.viewControllers?.first is ListViewController)
        XCTAssert(sut.viewControllers?.last is ConversionViewController)
    }
    

}
