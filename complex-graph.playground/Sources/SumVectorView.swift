import UIKit

final class SumVectorView: UIView {
    var sumComplexNumberView: ComplexNumberView = {
        let sumComplexNumberView = ComplexNumberView(frame: .zero, isDarkModeEnabled: true)
        return sumComplexNumberView
    }()
    
    let realLabel: UILabel = {
        let realLabel = UILabel(frame: .zero)
        realLabel.textColor = .white
        realLabel.font = realLabel.font.withSize(15.0)
        return realLabel
    }()
    
    let imaginaryLabel: UILabel = {
        let imaginaryLabel = UILabel(frame: .zero)
        imaginaryLabel.textColor = .white
        imaginaryLabel.font = imaginaryLabel.font.withSize(15.0)
        
        return imaginaryLabel
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
    
    public func configure(with complexNumbers: [ComplexNumber], colors: [UIColor]) {
        let sum = complexNumbers.sum
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
        
        let realAttributedString = NSMutableAttributedString(string: "real: ", attributes: defaultAttributes)
        realAttributedString.append(realPartsAttributedString)
        
        let imaginaryAttributedString = NSMutableAttributedString(string: "imaginary: ", attributes: defaultAttributes)
        imaginaryAttributedString.append(imaginaryPartsAttributedString)
        
        realLabel.attributedText = realAttributedString
        imaginaryLabel.attributedText = imaginaryAttributedString
        
        sumComplexNumberView.setupView(with: sum)
    }
    
    private func addSubviews() {
        [sumComplexNumberView, realLabel, imaginaryLabel]
            .forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        [self, sumComplexNumberView, realLabel, imaginaryLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let constraints: [NSLayoutConstraint] = [
            heightAnchor.constraint(equalToConstant: 80.0),
            ]
        
        let sumComplexNumberViewConstraints: [NSLayoutConstraint] = [
            sumComplexNumberView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0),
            sumComplexNumberView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            sumComplexNumberView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            sumComplexNumberView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        let realLabelConstraints: [NSLayoutConstraint] = [
            realLabel.leadingAnchor.constraint(equalTo: sumComplexNumberView.trailingAnchor, constant: 0.0),
            realLabel.heightAnchor.constraint(equalToConstant: 20.0),
            realLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10.0)
        ]
        
        let imaginaryLabelConstraints: [NSLayoutConstraint] = [
            imaginaryLabel.leadingAnchor.constraint(equalTo: realLabel.leadingAnchor, constant: 0.0),
            imaginaryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            imaginaryLabel.heightAnchor.constraint(equalToConstant: 20.0),
            imaginaryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10.0)
        ]
        
        [constraints, sumComplexNumberViewConstraints, realLabelConstraints, imaginaryLabelConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        layer.cornerRadius = 5.0
        backgroundColor = .white
    }
}
