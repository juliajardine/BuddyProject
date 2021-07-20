@testable import projeto_2
import XCTest

private final class RequestManagerMock: Requestable {
    var expectedResult: Result<Data, ApiError>?
    
    func request<D>(with endpoint: Endpoint, completion: @escaping (Result<D, ApiError>) -> Void) where D: Decodable {
        guard let expectedResult = expectedResult else {
            XCTFail("expect result não deveria ser nulo")
            return
        }
        
        do {
            switch expectedResult {
            case .success(let data):
                let decoded = try JSONDecoder().decode(D.self, from: data)
                completion(.success(decoded))
            case .failure(let error):
                completion(.failure(error))
            }
            
        } catch {
            completion(.failure(.other(error: error)))
        }
    }
}

final class ContactListServiceTests: XCTestCase {
    private let requestManagerMock = RequestManagerMock()
    private lazy var sut: ContactListServicing = ContactListService(manager: requestManagerMock)
    
    private var contactsMock: Data = {
        """
            [
                {
                    "id": 1,
                    "name": "Shakira",
                    "photoURL": "https://api.adorable.io/avatars/285/a1.png"
                }
            ]
        """.data(using: .utf8) ?? Data()
    }()
    
    func testFetchContacts_WhenRequestReturnSuccess_ShouldReturnAtLeastOneContact() {
        // arranged = seta as informações do teste
        let fetchContactsExpectation = expectation(description: "fetchContacts success")
        requestManagerMock.expectedResult = .success(contactsMock)
        // act = chama os métodos dos atores
        sut.fetchContacts { result in
            fetchContactsExpectation.fulfill()
            
            guard case .success(let contacts) = result else {
                XCTFail("não deveria retornar um caso de falha")
                return
            }
            // assert = valida os resultados
            XCTAssertGreaterThan(contacts.count, 0)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchContacts_WhenRequestReturnFailure_ShoudReturnNoContacts() {
        let fetchContactsExpectation = expectation(description: "fetchContacts failure")
        requestManagerMock.expectedResult = .failure(.dataMissing)
        
        sut.fetchContacts { result in
            fetchContactsExpectation.fulfill()
            
            guard case .failure(let error) = result else {
                XCTFail("não deveria retornar um caso de sucesso")
                return
            }
            
            XCTAssertEqual(error, .dataMissing)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}


// fazer os testes do presenter
// 1 - teste do index do contato - success
// 2 - number of rows = contacts.count - success
// 3 - teste success
// 4 - teste failure

// guide line tests
// ler sobre XCTest
