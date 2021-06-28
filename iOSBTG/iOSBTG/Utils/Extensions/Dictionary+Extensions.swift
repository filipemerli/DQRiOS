import Foundation

extension Dictionary {
    func toQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [URLQueryItem]()
        
        for pair in self.enumerated() {
            items.append(URLQueryItem(name: "\(pair.element.key)", value: "\(pair.element.value)"))
        }
        
        return items
    }
}
