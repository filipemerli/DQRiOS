import Foundation

public enum ResponseError: Error {
    case generic
    case rede
    case decoding
    
    var reason: String {
        switch self {
        case .rede:
            return "Ocorreu um erro ao receber os dados da rede. Verifique sua conexão e tente novamente"
        case .decoding:
            return "Ocorreu um erro ao decodificar os dados da rede. Tente novamente mais tarde."
        case .generic:
            return "Ocorreu um erro inesperado."
        }
    }
}
