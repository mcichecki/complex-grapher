import UIKit

final class AddPointCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "AddPointCollectionViewCell"
    
    private let addButton: UIButton = {
        let addButton = UIButton(frame: .zero)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.darkGray, for: .normal)
        addButton.backgroundColor = .white
        addButton.isUserInteractionEnabled = false
        return addButton
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupStyling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [addButton]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
            ])
    }
    
    private func setupStyling() {
        contentView.layer.cornerRadius = 5.0
        contentView.backgroundColor = .white
    }
}
