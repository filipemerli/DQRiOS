import Foundation

struct CurrenmciesModel: Decodable {
    let currencies: [String : String]
    let success: Bool
}

