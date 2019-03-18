import UIKit

final class ComplexNumberView: UIView {
    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView(frame: .zero)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5.0
        return labelsStackView
    }()
    
    private lazy var complexNumberLabel: UILabel = {
        let complexNumberLabel = UILabel(frame: .zero)
        complexNumberLabel.font = UIFont.systemFont(ofSize: 14.0)
        complexNumberLabel.textColor = isDarkModeEnabled ? .black : .white
        
        return complexNumberLabel
    }()
    
    private lazy var modulusLabel: UILabel = {
        let modulusLabel = UILabel(frame: .zero)
        modulusLabel.font = UIFont.systemFont(ofSize: 14.0)
        modulusLabel.textColor = isDarkModeEnabled ? .black : .white
        
        return modulusLabel
    }()
    
    private lazy var angleLabel: UILabel = {
        let angleLabel = UILabel(frame: .zero)
        angleLabel.font = UIFont.systemFont(ofSize: 14.0)
        angleLabel.textColor = isDarkModeEnabled ? .black : .white
        
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
    
    // TODO: check if it is not called every time we move complex number
    public func setupView(with complexNumber: ComplexNumber) {
        complexNumberLabel.text = complexNumber.description
        modulusLabel.text = complexNumber.modulusDescription
        angleLabel.text = complexNumber.degreesDescription
        //        print("SETUP VIEW")
    }
    
    private func addSubviews() {
        addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [complexNumberLabel, modulusLabel, angleLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                labelsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        let labelConstraints = [complexNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0)]
        
        let stackViewConstraints = [
            labelsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        [labelConstraints,
         stackViewConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        self.layer.cornerRadius = 5.0
    }
}
