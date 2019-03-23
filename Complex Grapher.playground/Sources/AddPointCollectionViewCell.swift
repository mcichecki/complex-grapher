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
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30.0),
            addButton.widthAnchor.constraint(equalToConstant: 30.0)
            ])
    }
    
    private func setupStyling() {
        contentView.layer.cornerRadius = 10.0
        contentView.backgroundColor = .white
    }
}
