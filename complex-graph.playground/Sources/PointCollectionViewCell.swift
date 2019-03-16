import UIKit

final class PointCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "PointCollectionViewCell"
    
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
        contentView.layer.borderColor = color.darker(by: 25.0).cgColor
    }
    
    private func addSubviews() {
        contentView.addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        [complexNumberLabel, modulusLabel, angleLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                labelsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            complexNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0)
            ])
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
            ])
    }
    
    private func setupStyling() {
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 2.0
    }
}
