import Foundation

enum Endpoints<T: CurrencyApiClient> {
    
    case getCurrencies
    case getQuote

    var url: URL {
        let path: String
        
        switch self {
        case .getQuote:
            path = "live"
        case .getCurrencies:
            path = "list"
        }
        return URL(string: Constants.kApiBaseUrl + path) ?? URL(fileURLWithPath: "https://")
    }
}
