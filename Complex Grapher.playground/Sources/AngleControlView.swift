import UIKit

protocol AngleControlViewDelegate: AnyObject {
    func didSelect(option: AngleOption)
}

enum AngleOption: Int, CaseIterable {
    case degrees, pi, radians
    
    var name: String {
        switch self {
        case .degrees: return "°"
        case .pi: return "π rad"
        case .radians: return "rad"
        }
    }
}

final class AngleControlView: UIView {
    var delegate: AngleControlViewDelegate?
    
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView(frame: .zero)
        mainStackView.axis = .vertical
        mainStackView.spacing = 5.0
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.distribution = .fillEqually
        
        return mainStackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupStyling()
        mainStackView.subviews
            .compactMap { $0 as? UIButton }
            .filter { (AngleOption(rawValue: $0.tag) ?? AngleOption.pi) == AngleOption.degrees }
            .forEach { $0.backgroundColor = .confirmationGreen }
    }
    
    private var selected: AngleOption = .degrees
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([mainStackView.widthAnchor.constraint(equalToConstant: 100.0)])
        
        AngleOption.allCases
            .map {
                let button = UIButton(frame: .zero)
                button.setTitle($0.name, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .mainGray
                button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                button.addTarget(self, action: #selector(onTap(sender:)), for: .touchUpInside)
                button.tag = $0.rawValue
                
                return button
            }
            .forEach {
                mainStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        let mainStackViewConstraints = [
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor),
            mainStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        
        NSLayoutConstraint.activate(mainStackViewConstraints)
    }
    
    private func setupStyling() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.mainGray.darker(by: 10.0).cgColor
        layer.borderWidth = 2.0
        clipsToBounds = true
    }
    
    @objc private func onTap(sender: UIButton) {
        mainStackView.subviews
            .compactMap { $0 as? UIButton}
            .forEach { $0.backgroundColor = .mainGray }
        
        sender.backgroundColor = .confirmationGreen
        
        guard let selectedOption = AngleOption(rawValue: sender.tag) else { return }
        if selectedOption == selected {
            return
        }
        
        selected = selectedOption
        
        delegate?.didSelect(option: selectedOption)
    }
}
