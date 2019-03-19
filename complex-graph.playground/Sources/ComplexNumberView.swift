import UIKit

final class ComplexNumberView: UIView {
    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView(frame: .zero)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5.0
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return labelsStackView
    }()
    
    private lazy var complexNumberLabel: UILabel = {
        let complexNumberLabel = UILabel(frame: .zero)
        complexNumberLabel.font = UIFont.systemFont(ofSize: 14.0)
        complexNumberLabel.textColor = isDarkModeEnabled ? .black : .white
        complexNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return complexNumberLabel
    }()
    
    private lazy var modulusLabel: UILabel = {
        let modulusLabel = UILabel(frame: .zero)
        modulusLabel.font = UIFont.systemFont(ofSize: 14.0)
        modulusLabel.textColor = isDarkModeEnabled ? .black : .white
        modulusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return modulusLabel
    }()
    
    private lazy var angleLabel: UILabel = {
        let angleLabel = UILabel(frame: .zero)
        angleLabel.font = UIFont.systemFont(ofSize: 14.0)
        angleLabel.textColor = isDarkModeEnabled ? .black : .white
        angleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return angleLabel
    }()
    
    private let isDarkModeEnabled: Bool
    
    public init(frame: CGRect, isDarkModeEnabled: Bool = false) {
        self.isDarkModeEnabled = isDarkModeEnabled
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupStyling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(with complexNumber: ComplexNumber) {
        complexNumberLabel.text = complexNumber.description
        modulusLabel.text = complexNumber.modulusDescription
        angleLabel.text = complexNumber.degreesDescription
    }
    
    private func addSubviews() {
        addSubview(labelsStackView)
        
        [complexNumberLabel, modulusLabel, angleLabel].forEach { labelsStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        let labelConstraints = [complexNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0)]
        
        let stackViewConstraints = [
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        [labelConstraints,
         stackViewConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        self.layer.cornerRadius = 5.0
    }
}
