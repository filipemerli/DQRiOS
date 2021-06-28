import Foundation

final class QuotesApiClient: ApiClient {
    
    //MARK: Properties
    
    static var shared: QuotesApiClient = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        config.requestCachePolicy = .useProtocolCachePolicy
        return QuotesApiClient(configuration: config)
    }()
    
    lazy var defaultParameters: [String:String] = {
        return ["access_key": "\(Constants.kApiKey)", "format": "1", "source": "USD"]
    }()
    
    //MARK: Class Methods
    
    func getQuote(currency: String, completion: @escaping (Result<QuotesModel, ResponseError>) -> Void) {
        let url = Endpoints<CurrencyApiClient>.getQuote.url
        let parameters = ["currencies" : currency].merging(defaultParameters, uniquingKeysWith: +)
        let request = buildRequest(.get, url: url, parameters: parameters)
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data else {
                completion(Result.failure(ResponseError.rede))
                return
            }
            guard let decodedResponse = try? JSONDecoder().decode(QuotesModel.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            decodedResponse.success == true ? completion(Result.success(decodedResponse)) : completion(Result.failure(ResponseError.rede))
        }).resume()
    }
    
    func getAllQuotes(completion: @escaping (Result<QuotesModel, ResponseError>) -> Void) {
        let url = Endpoints<CurrencyApiClient>.getQuote.url
        let request = buildRequest(.get, url: url, parameters: defaultParameters)
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data else {
                completion(Result.failure(ResponseError.rede))
                return
            }
            guard let decodedResponse = try? JSONDecoder().decode(QuotesModel.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            decodedResponse.success == true ? completion(Result.success(decodedResponse)) : completion(Result.failure(ResponseError.rede))
        }).resume()
    }
    
}
