import UIKit

protocol PointCollectionViewCellDelegate: class {
    func didTapRemove(_ cell: PointCollectionViewCell, item: Int)
}

final class PointCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "PointCollectionViewCell"
    
    weak var delegate: PointCollectionViewCellDelegate?
    
    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView(frame: .zero)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5.0
        return labelsStackView
    }()
    
    private lazy var complexNumberLabel: UILabel = {
        let complexNumberLabel = UILabel(frame: .zero)
        complexNumberLabel.font = UIFont.systemFont(ofSize: 14.0)
        complexNumberLabel.textColor = .white
        
        return complexNumberLabel
    }()
    
    private lazy var modulusLabel: UILabel = {
        let modulusLabel = UILabel(frame: .zero)
        modulusLabel.font = UIFont.systemFont(ofSize: 14.0)
        modulusLabel.textColor = .white
        
        return modulusLabel
    }()
    
    private lazy var angleLabel: UILabel = {
        let angleLabel = UILabel(frame: .zero)
        angleLabel.font = UIFont.systemFont(ofSize: 14.0)
        angleLabel.textColor = .white
        
        return angleLabel
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
        complexNumberLabel.text = complexNumber.description
        modulusLabel.text = complexNumber.modulusDescription
        angleLabel.text = complexNumber.degreesDescription
    }
    
    private func addSubviews() {
        contentView.addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        [complexNumberLabel, modulusLabel, angleLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                labelsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        let buttonSize: CGFloat = 16.0
        let offset = buttonSize * 0.5
        
        let labelConstraints = [complexNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0)]
        
        let stackViewConstraints = [labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
                                    labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
                                    labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
                                    labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)]
        
        let deleteButtonConstraints = [deleteButton.bottomAnchor.constraint(equalTo: labelsStackView.topAnchor, constant: buttonSize * 0.4),
                                       deleteButton.trailingAnchor.constraint(equalTo: labelsStackView.trailingAnchor, constant: buttonSize * 0.6),
                                       deleteButton.widthAnchor.constraint(equalToConstant: buttonSize),
                                       deleteButton.heightAnchor.constraint(equalToConstant: buttonSize)]
        
        [labelConstraints,
         stackViewConstraints,
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
