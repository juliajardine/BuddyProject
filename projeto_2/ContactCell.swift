import Foundation
import UIKit

class ContactCell: UITableViewCell {
    static let identifier = String(describing: ContactCell.self)
    
    private lazy var nameLabel = UILabel()
    private lazy var avatarImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupConstraints()
        additionalSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(contact: Contact) {
        nameLabel.text = contact.name
        
        avatarImage.setImage(with: contact.photoURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImage.cancel()
    }
}

private extension ContactCell {
    func additionalSetup() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImage.contentMode = .scaleAspectFit
    }
    
    func setupHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImage)
    }
    
    func setupConstraints() {
        let imageConstraints = [
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImage.heightAnchor.constraint(equalToConstant: 100),
            avatarImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let nameConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(nameConstraints)
    }
}
