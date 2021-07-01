import Foundation

protocol ConversionViewModelDelegate: AnyObject {
    func onGetCurrencyCompleted(result: String)
    func onGetDataCompleted()
    func onFetchFailed(with reason: String)
    func displayOfflineAlert()
}

final class ConversionViewModel {
    
    //MARK: Properties
    
    private var currencies: [String: String] = [:]
    private var offlineCurrencies: [String: Double]?
    private var keys: [String] = []
    private let apiClient = CurrencyApiClient.shared
    private weak var delegate: ConversionViewModelDelegate?
    public var sourceSelected: Int?
    public var resultDesired: Int?
    private var dataManager: DataManager?
    
    public var pickerCount: Int {
        return keys.count
    }
    
    //MARK: Initializer
    
    init(delegate: ConversionViewModelDelegate) {
        self.dataManager = DataManager()
        self.delegate = delegate
        getAllCurrencies()
    }
    
    //MARK: Class Methods
    
    public func getCode(index: Int) -> String? {
        return keys[index]
    }
    
    public func getOfflineCodesData() {
        currencies = dataManager?.getCurrencies() ?? [:]
        filterByCode()
    }
    
    private func getAllCurrencies() {
        apiClient.getAllCurrencies() { result in
            switch result {
            case .success(let model):
                self.currencies = model.currencies
                self.dataManager?.storeCurrencyModel(currencyModel: model)
                self.filterByCode()
            case .failure(let error):
                if error.reason == ResponseError.rede.reason {
                    self.getOfflineCodesData()
                } else {
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            }
        }
    }
    
    public func getCurrency(value: String, sourceCode: String, desiredCode: String) {
        guard keys.count > 0 else { return }
        apiClient.getQuote(currency: "\(sourceCode),\(desiredCode)") { result in
            switch result {
            case .success(let model):
                guard
                    let sourceRespose = model.quotes["USD\(sourceCode)"],
                    let desiredResponse = model.quotes["USD\(desiredCode)"],
                    let multiplier = Double(value)
                else { return }
                let number = ((desiredResponse / sourceRespose) * multiplier)
                let text = String.localizedStringWithFormat("%.2f", number)
                self.delegate?.onGetCurrencyCompleted(result: text)
            case .failure(let error):
                if error.reason == ResponseError.rede.reason && self.offlineCurrencies?.count ?? 0 > 0 {
                    self.offlineFlow(value: value, sourceCode: sourceCode, desiredCode: desiredCode)
                } else {
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            }
        }
    }
    
    public func updateOfflineQuotes() {
        apiClient.getAllQuotes { result in
            switch result {
            case.success(let model):
                self.offlineCurrencies = model.quotes
                self.dataManager?.updateAllQuotes(quotes: model)
            case.failure(_ ):
                guard let offlineQuotes = self.dataManager?.getQuotes() else {
                    return
                }
                self.offlineCurrencies = offlineQuotes
                return
            }
        }
    }
    
    private func filterByCode() {
        let sorted = currencies.sorted { $0.key < $1.key }
        keys.removeAll()
        keys = Array(sorted.map({ $0.key }))
        delegate?.onGetDataCompleted()
    }
    
    private func offlineFlow(value: String, sourceCode: String, desiredCode: String) {
        guard let sourceValue = offlineCurrencies?["USD\(sourceCode)"] else { return }
        guard let desiredValue = offlineCurrencies?["USD\(desiredCode)"] else { return }
        guard let multiplier = Double(value) else { return }
        let number = ((desiredValue / sourceValue) * multiplier)
        let text = String.localizedStringWithFormat("%.2f", number)
        self.delegate?.onGetCurrencyCompleted(result: text)
    }
    
}

