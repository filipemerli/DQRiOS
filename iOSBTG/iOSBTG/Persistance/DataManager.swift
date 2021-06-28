import CoreData


final class DataManager {
    
    let userDefaults: UserDefaults
    private let key = "stored"
    private let offlineKey = "stored"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func storeInfo(currencyModel: CurrenmciesModel) {
        userDefaults.setValue(nil, forKey: key)
        userDefaults.setValue(currencyModel.currencies, forKey: key)
    }

    func getInfo() -> [String: String]? {
        return userDefaults.value(forKey: key) as? [String : String]
    }
    
    func updateAllQuotes(quotes: QuotesModel) {
        userDefaults.setValue(nil, forKey: offlineKey)
        userDefaults.setValue(quotes.quotes, forKey: offlineKey)
    }
    
    func getOfflineQuote(currency: String) -> Double? {
        guard let quotes = userDefaults.value(forKey: offlineKey) as? [String: Double] else { return nil }
        for quote in quotes {
            if quote.key == currency {
                return quote.value
            }
        }
        return nil
    }
}
