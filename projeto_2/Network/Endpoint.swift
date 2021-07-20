import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var absolutURLString: String { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    var baseURL: URL {
        guard let url = URL(string: "https://run.mocky.io/v3/") else {
            fatalError("baseURL must be setted")
        }
        
        return url
    }
    
    var absolutURLString: String {
        "\(baseURL.absoluteString)\(path)"
    }
    
    var method: HTTPMethod {
        .get
    }
}
