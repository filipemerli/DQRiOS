import Foundation

struct QuotesModel: Decodable {
    let quotes: [String : Double]
    let success: Bool
}
