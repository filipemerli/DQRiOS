
import XCTest

@testable import iOSBTG

class ApiClientTests: XCTestCase {

    var sut: ApiClient!
    var urlMock: String = "http://apilayer.net/api"

    override func setUp() {
        super.setUp()
        sut = ApiClient(configuration: URLSessionConfiguration())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_build_request() {
        guard let url = URL(string: urlMock) else { return }
        let request = sut.buildRequest(RequestType.get, url: url, parameters: [:])
        XCTAssertNotNil(request)
        let requestUrl = request.url
        XCTAssertEqual(url, requestUrl)
        let requestMethod = request.httpMethod?.description
        XCTAssertEqual(requestMethod, "GET")
    }


}
