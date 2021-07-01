import Foundation

protocol ListViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class ListViewModel {
    
    //MARK: Properties
    
    private var currencies: [String: String] = [:]
    private let apiClient = CurrencyApiClient.shared
    private weak var delegate: ListViewModelDelegate?
    private var keys: [String] = []
    private var values: [String] = []
    private var noResultsFound: Bool = false
    private let dataManager: DataManager?
    
    var totalCount: Int {
        return keys.count
    }
    
    init(delegate: ListViewModelDelegate) {
        self.delegate = delegate
        self.dataManager = DataManager()
        getCodes()
    }
    
    //MARK: Class Methods
    
    public func getCode(at row: Int) -> String? {
        guard keys.count > 0, keys.count > row else { return "" }
        return "\(keys[row])"
    }
    
    public func currency(at index: Int) -> String? {
        if values.count != 0 && keys.count != 0 {
            if noResultsFound {
                return "No results found"
            }
            return "\(keys[index]) = \(values[index])"
        } else {
            return nil
        }
    }
    
    private func getCodes() {
        if let currenciesData = dataManager?.getCurrencies() {
            currencies = currenciesData
            filterByCode()
        } else {
            apiClient.getAllCurrencies() { result in
                switch result {
                case .success(let model):
                    self.currencies = model.currencies
                    self.dataManager?.storeCurrencyModel(currencyModel: model)
                    self.filterByCode()
                case .failure(let error):
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            }
        }
    }
    
    public func filterByName() {
        let sorted = currencies.sorted { $0.key < $1.key }
        keys = Array(sorted.map({ $0.key }))
        values = Array(sorted.map({ $0.value }))
        delegate?.onFetchCompleted()
    }
    
    public func filterByCode() {
        let sorted = currencies.sorted { $0.value < $1.value }
        keys = Array(sorted.map({ $0.key }))
        values = Array(sorted.map({ $0.value }))
        delegate?.onFetchCompleted()
    }
    
    public func searchAction(text: String) {
        resetOriginalData()
        noResultsFound = false
        var newKeys: [String] = []
        var newValues: [String] = []
        var  index = -1
        for key in keys {
            index += 1
            if key.uppercased().contains(text.uppercased()) {
                let value = values[index]
                newKeys.append(key)
                newValues.append(value)
            } else if values[index].uppercased().contains(text.uppercased()) {
                let key = keys[index]
                newKeys.append(key)
                newValues.append(values[index])
            }
        }
            
        clearPairsData()
        if newKeys.count != 0 {
            keys = newKeys
            values = newValues
        } else {
            keys.append(" ")
            values.append(" ")
            noResultsFound = true
        }
        delegate?.onFetchCompleted()
        
    }
    
    private func clearPairsData() {
        keys.removeAll()
        values.removeAll()
    }
    
    private func resetOriginalData() {
        values = currencies.map { $0.value }
        keys = currencies.map { $0.key }
    }
    
    func clearSearch() {
        resetOriginalData()
        delegate?.onFetchCompleted()
    }
    
}
