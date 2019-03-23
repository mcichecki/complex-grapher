import UIKit

final class BottomView: UIView {
    
    let glossaryButton: UIButton = {
        let glossaryButton = UIButton(frame: .zero)
        glossaryButton.setTitle("Glossary", for: .normal)
        
        return glossaryButton
    }()
    
    let detailsButton: UIButton = {
        let detailsButton = UIButton(frame: .zero)
        detailsButton.setTitle("Details", for: .normal)
        
        return detailsButton
    }()
    
    private let buttonStyle: (UIButton) -> Void = { button in
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.backgroundColor = .mainGray
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.mainGray.darker(by: 10.0).cgColor
        button.layer.cornerRadius = 5.0
    }
    
    public init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupConstraints()
        setupStyling()
    }
    
    private var selected: AngleOption = .degrees
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [glossaryButton, detailsButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        [glossaryButton, detailsButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let glossaryButtonConstraints = [
            glossaryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            glossaryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            glossaryButton.heightAnchor.constraint(equalToConstant: 26.0),
            glossaryButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            glossaryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            glossaryButton.widthAnchor.constraint(equalToConstant: 120.0)
        ]
        
        let detailsButtonConstraints: [NSLayoutConstraint] = [
            detailsButton.leadingAnchor.constraint(equalTo: glossaryButton.trailingAnchor, constant: 20.0),
            detailsButton.centerYAnchor.constraint(equalTo: glossaryButton.centerYAnchor),
            detailsButton.heightAnchor.constraint(equalTo: glossaryButton.heightAnchor),
            detailsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            detailsButton.widthAnchor.constraint(equalTo: glossaryButton.widthAnchor)
        ]
        
        [glossaryButtonConstraints, detailsButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        [glossaryButton, detailsButton].forEach { $0.apply(buttonStyle) }
        detailsButton.backgroundColor = .confirmationGreen
    }
}

private extension UIButton {
    @discardableResult
    func apply(_ style: (UIButton) -> Void) -> UIButton {
        style(self)
        
        return self
    }
}
