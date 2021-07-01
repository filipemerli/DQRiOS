import CoreData


final class DataManager {
    
    let userDefaults: UserDefaults
    private let currenciesKey = "storedCurrencies"
    private let quotesKey = "storedQuotes"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func storeCurrencyModel(currencyModel: CurrenmciesModel) {
        userDefaults.setValue(nil, forKey: currenciesKey)
        userDefaults.setValue(currencyModel.currencies, forKey: currenciesKey)
    }

    func getCurrencies() -> [String: String]? {
        return userDefaults.value(forKey: currenciesKey) as? [String: String]
    }
    
    func updateAllQuotes(quotes: QuotesModel) {
        userDefaults.setValue(nil, forKey: quotesKey)
        userDefaults.setValue(quotes.quotes, forKey: quotesKey)
    }
    
    func getQuotes() -> [String: Double]? {
        return userDefaults.value(forKey: quotesKey) as? [String: Double]
    }
}
