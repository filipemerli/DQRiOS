import XCTest

@testable import iOSBTG

class DataManagerTests: XCTestCase {

    var sut: DataManager!
    var mockedData: CurrenmciesModel = CurrenmciesModel(currencies: ["USD": "United States", "BRL": "Brazilian"], success: true)
    var mockedOfflineQuotes: QuotesModel = QuotesModel(quotes: ["USD": 3.0, "BRL": 100.0], success: true)

    override func setUp() {
        super.setUp()
        sut = DataManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_store_currency() {
        sut.storeCurrencyModel(currencyModel: mockedData)
        XCTAssertNotNil(sut.getCurrencies())
    }
    
    func test_quotes_storage() {
        sut.updateAllQuotes(quotes: mockedOfflineQuotes)
        XCTAssertNotNil(sut.getQuotes())
    }

}
