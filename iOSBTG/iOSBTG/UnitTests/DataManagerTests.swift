import XCTest

@testable import iOSBTG

class DataManagerTests: XCTestCase {

    var sut: DataManager!
    var mockedData: CurrenmciesModel = CurrenmciesModel(currencies: ["USD": "United States", "BRL": "Brazilian"], success: true)
    var mockedOfflineData: QuotesModel = QuotesModel(quotes: ["USD": 3.0, "BRL": 100.0], success: true)

    override func setUp() {
        super.setUp()
        sut = DataManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_storeInfor() {
        sut.storeInfo(currencyModel: mockedData)
        XCTAssertNotNil(sut.getInfo())
    }
    
    func test_offline_store() {
        sut.updateAllQuotes(quotes: mockedOfflineData)
        XCTAssertNotNil(sut.getOfflineQuote(currency: "USD"))
    }
    

}
