import Foundation

class ApiClient {
    
    fileprivate let configuration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
        
    func buildRequest(_ verb: RequestType, url: URL, parameters: Dictionary<String, Any> = [:]) -> URLRequest {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var request: URLRequest
        let buildRequest: () -> URLRequest = {
            var req = URLRequest(url: urlComponents?.url ?? URL(fileURLWithPath: "https://"))
            req.httpMethod = verb.rawValue
            return req
        }
        if parameters.keys.count > 0 {
            urlComponents?.queryItems = parameters.toQueryItems()
        }
        request = buildRequest()
        return request
    }
}
