import UIKit

protocol PointCollectionViewCellDelegate: class {
    func didTapRemove(_ cell: PointCollectionViewCell, item: Int)
}

final class PointCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "PointCollectionViewCell"
    
    weak var delegate: PointCollectionViewCellDelegate?
    
    private lazy var complexNumberView: ComplexNumberView = {
        let complexNumberView = ComplexNumberView(frame: .zero)
        
        return complexNumberView
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(frame: .zero)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.bold)
        deleteButton.backgroundColor = .red
        deleteButton.layer.zPosition = 10.0
        deleteButton.addTarget(self, action: #selector(tappedDelete), for: .touchUpInside)
        
        return deleteButton
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
    
    public func setupCell(with complexNumber: ComplexNumber, color: UIColor) {
        contentView.backgroundColor = color
        complexNumberView.setupView(with: complexNumber)
    }
    
    private func addSubviews() {
        [complexNumberView, deleteButton]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        let buttonSize: CGFloat = 16.0
        let offset = buttonSize * 0.5
        
        let complexNumberViewConstraints = [
            complexNumberView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            complexNumberView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            complexNumberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            complexNumberView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ]
        
        let deleteButtonConstraints = [
            deleteButton.bottomAnchor.constraint(equalTo: complexNumberView.topAnchor, constant: buttonSize * 0.4),
            deleteButton.trailingAnchor.constraint(equalTo: complexNumberView.trailingAnchor, constant: buttonSize * 0.6),
            deleteButton.widthAnchor.constraint(equalToConstant: buttonSize),
            deleteButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ]
        
        [complexNumberViewConstraints,
         deleteButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
        
        deleteButton.layer.cornerRadius = buttonSize * 0.5
    }
    
    private func setupStyling() {
        contentView.layer.cornerRadius = 5.0
    }
    
    @objc private func tappedDelete() {
        delegate?.didTapRemove(self, item: tag)
    }
}
