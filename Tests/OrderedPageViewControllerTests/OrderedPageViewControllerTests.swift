import XCTest
@testable import OrderedPageViewController

class OrderedPageViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDescription() {
        let pageViewController = OrderedPageViewController()
        XCTAssertEqual(pageViewController.numberOfPages, NSNotFound)
    }
}
