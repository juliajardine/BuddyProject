import Foundation

protocol Requestable {
    func request<D>(with endpoint: Endpoint, completion: @escaping (Result<D, ApiError>) -> Void) where D: Decodable
}

struct RequestManager: Requestable {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<D>(with endpoint: Endpoint, completion: @escaping (Result<D, ApiError>) -> Void) where D: Decodable {
        let request = createURLRequest(with: endpoint)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(.dataMissing))
                    return
                }
                
                do {
                    let contacts = try JSONDecoder().decode(D.self, from: data)
                    completion(.success(contacts))
                } catch {
                    completion(.failure(.other(error: error)))
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func createURLRequest(with endpoint: Endpoint) -> URLRequest {
        var url = endpoint.baseURL
        url.appendPathComponent(endpoint.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        return urlRequest
    }
}
