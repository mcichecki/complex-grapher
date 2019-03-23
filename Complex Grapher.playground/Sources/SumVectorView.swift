import UIKit

final class SumVectorView: UIView {
    private let sumComplexNumberView = ComplexNumberView(frame: .zero, isDarkModeEnabled: true)
    
    private let realLabel: UILabel = {
        let realLabel = UILabel(frame: .zero)
        realLabel.textColor = .white
        realLabel.font = realLabel.font.withSize(15.0)
        return realLabel
    }()
    
    private let imaginaryLabel: UILabel = {
        let imaginaryLabel = UILabel(frame: .zero)
        imaginaryLabel.textColor = .white
        imaginaryLabel.font = imaginaryLabel.font.withSize(15.0)
        
        return imaginaryLabel
    }()
    
    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView(frame: .zero)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5.0
        
        return labelsStackView
    }()
    
    private var sum = ComplexNumber()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupStyling()
        setupGestureRecognizer()
    }
    
    private let speechSynthesizer = SpeechSynthesizer()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with complexNumbers: [ComplexNumber], colors: [UIColor]) {
        let sum = complexNumbers.sum
        self.sum = sum
        let realParts = complexNumbers.realParts
        let imaginaryParts = complexNumbers.imaginaryParts
        
        let realPartsAttributedString = NSMutableAttributedString(string: "")
        let imaginaryPartsAttributedString = NSMutableAttributedString(string: "")
        let font = UIFont.systemFont(ofSize: 14.0)
        let defaultAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.black]
        
        [realParts,
         imaginaryParts]
            .enumerated()
            .forEach {
                for (index, part) in $0.element.enumerated() {
                    let nodeColorAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: colors[index]]
                    let isReal = $0.offset == 0
                    if index == 0 {
                        let attributedString = NSAttributedString(string: "\(part)", attributes: nodeColorAttributes)
                        isReal ? realPartsAttributedString.append(attributedString) : imaginaryPartsAttributedString.append(attributedString)
                    } else {
                        let sign = part < 0 ? "-" : "+"
                        let attributedString = NSMutableAttributedString(string: " \(sign)", attributes: defaultAttributes)
                        attributedString.append(NSAttributedString(string: " \(abs(part))", attributes: nodeColorAttributes))
                        isReal ? realPartsAttributedString.append(attributedString) : imaginaryPartsAttributedString.append(attributedString)
                    }
                }
        }
        
        let realAttributedString = NSMutableAttributedString(string: "Re: ", attributes: defaultAttributes)
        realAttributedString.append(realPartsAttributedString)
        
        let imaginaryAttributedString = NSMutableAttributedString(string: "Im: ", attributes: defaultAttributes)
        imaginaryAttributedString.append(imaginaryPartsAttributedString)
        
        realLabel.attributedText = realAttributedString
        imaginaryLabel.attributedText = imaginaryAttributedString
        
        sumComplexNumberView.setupView(with: sum)
    }
    
    private func addSubviews() {
        [sumComplexNumberView, labelsStackView].forEach { addSubview($0) }
        
        [realLabel, imaginaryLabel].forEach { labelsStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        [self, sumComplexNumberView, realLabel, imaginaryLabel, labelsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let constraints: [NSLayoutConstraint] = [
            heightAnchor.constraint(equalToConstant: 80.0),
            ]
        
        let sumComplexNumberViewConstraints: [NSLayoutConstraint] = [
            sumComplexNumberView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
            sumComplexNumberView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            sumComplexNumberView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            sumComplexNumberView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        let labelsStackViewConstraints: [NSLayoutConstraint] = [
            labelsStackView.leadingAnchor.constraint(equalTo: sumComplexNumberView.trailingAnchor, constant: 10.0),
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0)
        ]
        
        let realLabelConstraints: [NSLayoutConstraint] = [realLabel.heightAnchor.constraint(equalToConstant: 20.0)]
        let imaginaryLabelConstraints: [NSLayoutConstraint] = [imaginaryLabel.heightAnchor.constraint(equalToConstant: 20.0)]
        
        [constraints, sumComplexNumberViewConstraints, realLabelConstraints, imaginaryLabelConstraints, labelsStackViewConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        layer.cornerRadius = 5.0
        backgroundColor = .white
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func tapped() {
        speechSynthesizer.speak(sum, isSum: true)
    }
}
