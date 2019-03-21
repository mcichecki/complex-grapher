import UIKit

protocol ReferenceViewDelegate: AnyObject {
    func didClose()
}

public enum Symbol: String, CaseIterable {
    case z
    case realPart = "Re(z) = a"
    case imaginaryPart = "Im(z) = b"
    case i
    case modulusZ = "|z|"
    case argumentZ = "arg(z) or θ"
    
    var labelDescription: String {
        switch self {
        case .z: return "complex number - any number that can be written as a + bi"
        case .realPart: return "real part, e.g. Re(2 + 3i) = 2"
        case .imaginaryPart: return "imaginary part, e.g. Im(2 + 3i) = 3"
        case .i: return "imaginary number - solution of the equation x²-1, i² = -1, i = √-1"
        case .modulusZ: return "modulus of z (complex number) - distance between the origin (0,0) and point z. |z| = √(a² + b²)"
        case .argumentZ: return "argument of z or theta - angle between the positive real axis and the line joining the point to the origin"
        }
    }
    
    var speechDescription: String {
        switch self {
        case .z: return "complex number - any number that can be written as a plus b times i"
        case .realPart: return "real part, e.g. real part of the equation 2 + 3 times i-is equal 2"
        case .imaginaryPart: return "imaginary part, e.g. imaginary part of the equation 2 + 3 times i-is equal 3"
        case .i: return "imaginary number - solution of the equation x²-1,- i² = -1,- i = square root of -1"
        case .modulusZ: return "modulus of z - distance between the origin (point zero zero) and point z.- modulus of z is equal to the sum of real and imaginary parts to the power of two"
        case .argumentZ: return "argument of z or theta - angle between the positive real axis and the line joining the point to the origin"
        }
    }
}

protocol DescriptionViewDelegate: AnyObject {
    func didSelect(symbol: Symbol)
}

private final class DescriptionView: UIView {
    weak var delegate: DescriptionViewDelegate?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let symbolLabel: UILabel = {
        let symbolLabel = UILabel(frame: .zero)
        symbolLabel.numberOfLines = 1
        symbolLabel.font = UIFont.systemFont(ofSize: 16.0)
        symbolLabel.textColor = .white
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.textAlignment = .right
        
        return symbolLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14.0)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionLabel
    }()
    
    let symbol: Symbol
    
    public init(symbol: Symbol) {
        self.symbol = symbol
        
        super.init(frame: .zero)
        
        symbolLabel.text = symbol.rawValue
        descriptionLabel.text = symbol.labelDescription
        addSubviews()
        setupConstraints()
        setupStyling()
        setupGestureRecognizer()
    }
    
    private var selected: AngleOption = .degrees
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [symbolLabel, descriptionLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        let symbolLabelConstraints = [
            symbolLabel.widthAnchor.constraint(equalToConstant: 80.0),
            symbolLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            symbolLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 20.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        [symbolLabelConstraints, descriptionLabelConstraints].forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        backgroundColor = UIColor.mainGray.darker(by: 15.0)
        layer.cornerRadius = 5.0
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTap() {
        delegate?.didSelect(symbol: symbol)
    }
}

public class ReferenceView: UIView {
    private let speechSynthesizer = SpeechSynthesizer()
    
    weak var delegate: ReferenceViewDelegate?
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let closeButton: UIButton = {
        let closeButton = UIButton(frame: .zero)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .warningRed
        closeButton.titleLabel?.textAlignment = .center
        closeButton.layer.cornerRadius = 5.0
        closeButton.clipsToBounds = true
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
        closeButton.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
        
        return closeButton
    }()
    
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView(frame: .zero)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 5.0
        mainStackView.distribution = .fillEqually
        
        return mainStackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupStackView()
    }
    
    private var selected: AngleOption = .degrees
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(blurEffectView)
        
        [closeButton, mainStackView].forEach { blurEffectView.contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        let blurEffectViewConstraints = [
            blurEffectView.widthAnchor.constraint(equalTo: widthAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        
        let closeButtonConstraints = [
            closeButton.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -20.0),
            closeButton.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor)
        ]
        
        let stackViewConstraints = [
            mainStackView.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor, constant: 0.0),
            mainStackView.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor, multiplier: 0.8),
            mainStackView.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor, multiplier: 0.35)
        ]
        
        [blurEffectViewConstraints, stackViewConstraints, closeButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStackView() {
        
        Symbol.allCases
            .map {
                let descriptionView = DescriptionView(symbol: $0)
                descriptionView.delegate = self
                return descriptionView
            }
            .forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.layer.cornerRadius = 5.0
        mainStackView.clipsToBounds = true
    }
    
    @objc private func onCloseButtonTap() {
        delegate?.didClose()
    }
}

extension ReferenceView: DescriptionViewDelegate {
    func didSelect(symbol: Symbol) {
        speechSynthesizer.speak(text: symbol.speechDescription)
    }
}
