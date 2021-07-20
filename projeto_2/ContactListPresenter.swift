import Foundation

protocol ContactListPresenting {
    var view: ContactListViewDisplaying? { get set }
    var numberOfRows: Int { get }

    func contact(at index: Int) -> Contact
    func fetchContacts()
}

class ContactListPresenter: ContactListPresenting {
    private var contacts: [Contact] = []
    private let service: ContactListServicing
    
    weak var view: ContactListViewDisplaying?
    
    var numberOfRows: Int {
        contacts.count
    }
    
    init(service: ContactListServicing = ContactListService()) {
        self.service = service
    }
    
    func contact(at index: Int) -> Contact {
        contacts[index]
    }
    
    func fetchContacts() {
        view?.showLoading()
        
        service.fetchContacts { result in
            self.view?.hideLoading()
            
            switch result {
            case .success(let contacts):
                self.contacts = contacts
                self.view?.reloadData()
            case .failure(let error):
                self.view?.show(message: error.localizedDescription)
            }
        }
    }
}
