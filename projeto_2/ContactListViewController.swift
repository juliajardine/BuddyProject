import UIKit

protocol ContactListViewDisplaying: AnyObject {
    func showLoading()
    func hideLoading()
    
    func reloadData()
    func show(message: String)
}

class ContactListViewController: UIViewController {
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.rowHeight = 100
        tableView.backgroundColor = .white
        tableView.backgroundView = loadingIndicator
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var presenter: ContactListPresenting
    
    init(presenter: ContactListPresenting = ContactListPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableViewConstraints()
        
        presenter.fetchContacts()
    }
}

extension ContactListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else { return UITableViewCell() }
        let contact = presenter.contact(at: indexPath.row)
        cell.configureCell(contact: contact)
        
        return cell
    }
}

extension ContactListViewController {
    func setupTableViewConstraints() {
        let constraints = [
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ContactListViewController: ContactListViewDisplaying {
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func show(message: String) {
        print(message)
    }
}


/*
 -> Repo no git
 -> Revisar pontos comentados
 -> Fazer uma factory (organizar inits no factory, e atrelar a factory no scene)
 */
