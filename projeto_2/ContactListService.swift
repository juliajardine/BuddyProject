import Foundation

protocol ContactListServicing {
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void)
}

struct ContactListService: ContactListServicing {
    private let requestManager: Requestable
    
    init(manager: Requestable = RequestManager()) {
        requestManager = manager
    }
    
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void) {
        let endpoint: ContactListEndpoint = .fetchContacts
        
        
        requestManager.request(with: endpoint, completion: completion)
//        requestManager.request(with: endpoint) { (result: Result<[Contact], ApiError>) in
//            completion(result)
//        }
    }
}
