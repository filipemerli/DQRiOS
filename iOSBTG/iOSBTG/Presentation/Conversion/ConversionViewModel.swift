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
    private var offlineCurrencies: [String: Double] = [:]
    private var keys: [String] = []
    private let apiClient = QuotesApiClient.shared
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
        getData()
        updateOfflineQuotes()
    }
    
    //MARK: Class Methods
    
    public func getCode(index: Int) -> String? {
        return keys[index]
    }
    
    public func getData() {
        currencies = dataManager?.getInfo() ?? [:]
        filterByCode()
    }
    
    public func getCurrency(value: String, sourceRow: Int, desiredRow: Int) {
        let source = keys[sourceRow]
        let desired = keys[desiredRow]
        apiClient.getQuote(currency: "\(source),\(desired)") { result in
            switch result {
            case .success(let model):
                let response = model.quotes.map { $0.value }
                guard
                    let sourceRespose = response.first,
                    let desiredResponse = response.last,
                    let multiplier = Double(value)
                else { return }
                let number = ((sourceRespose / desiredResponse) * multiplier)
                let text = String.localizedStringWithFormat("%.2f", number)
                self.delegate?.onGetCurrencyCompleted(result: text)
            case .failure(let error):
                if error.reason == ResponseError.rede.reason {
                    self.offlineFlow(value: value, sourceRow: sourceRow, desiredRow: desiredRow)
                } else {
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            }
        }
    }
    
    private func updateOfflineQuotes() {
        apiClient.getAllQuotes { result in
            switch result {
            case.success(let model):
                self.offlineCurrencies = model.quotes
                self.dataManager?.updateAllQuotes(quotes: model)
            case.failure(_ ):
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
    
    private func offlineFlow(value: String, sourceRow: Int, desiredRow: Int) {
        let codeSource = keys[sourceRow] // Prevent out of index
        let codeDesired = keys[desiredRow]
        guard let sourceValue = offlineCurrencies["USD\(codeSource)"] else { return }
        guard let desiredValue = offlineCurrencies["USD\(codeDesired)"] else { return }
        guard let multiplier = Double(value) else { return }
        let number = ((sourceValue / desiredValue) * multiplier)
        let text = String.localizedStringWithFormat("%.2f", number)
        self.delegate?.onGetCurrencyCompleted(result: text)
    }
    
}

