import UIKit

final class BottomView: UIView {
    
    let glossaryButton: UIButton = {
        let glossaryButton = UIButton(frame: .zero)
        glossaryButton.setTitle("Glossary", for: .normal)
        glossaryButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        glossaryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        glossaryButton.backgroundColor = .mainGray
        glossaryButton.layer.borderWidth = 2.0
        glossaryButton.layer.borderColor = UIColor.mainGray.darker(by: 10.0).cgColor
        glossaryButton.layer.cornerRadius = 5.0
        return glossaryButton
    }()
    
    let detailsSwitch: UISwitch = {
        let detailsSwitch = UISwitch(frame: .zero)
        detailsSwitch.onTintColor = .confirmationGreen
        detailsSwitch.tintColor = .warningRed
        detailsSwitch.backgroundColor = .warningRed
        
        return detailsSwitch
    }()
    
    let detailsView: UIView = {
        let detailsView = UIView(frame: .zero)
        detailsView.backgroundColor = .mainGray
        detailsView.layer.borderWidth = 2.0
        detailsView.layer.borderColor = UIColor.mainGray.darker(by: 10.0).cgColor
        detailsView.layer.cornerRadius = 5.0
        
        return detailsView
    }()
    
    private let detailsLabel: UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.text = "Additional information"
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        detailsLabel.textColor = .white
        detailsLabel.textAlignment = .center
        
        return detailsLabel
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
        [glossaryButton, detailsView].forEach { addSubview($0) }
        
        [detailsSwitch, detailsLabel].forEach { detailsView.addSubview($0) }
    }
    
    private func setupConstraints() {
        [glossaryButton, detailsView, detailsSwitch, detailsLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let glossaryButtonConstraints = [
            glossaryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            glossaryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            glossaryButton.heightAnchor.constraint(equalToConstant: 26.0),
            glossaryButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            glossaryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            glossaryButton.widthAnchor.constraint(equalToConstant: 120.0)
        ]
        
        let detailsViewConstraints = [
            detailsView.leadingAnchor.constraint(equalTo: glossaryButton.trailingAnchor, constant: 20.0),
            detailsView.centerYAnchor.constraint(equalTo: glossaryButton.centerYAnchor),
            detailsView.heightAnchor.constraint(equalTo: glossaryButton.heightAnchor),
            detailsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            detailsView.widthAnchor.constraint(equalTo: glossaryButton.widthAnchor)
        ]
        
        let detailsLabelConstraints = [
            detailsLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 10.0),
            detailsLabel.widthAnchor.constraint(equalTo: detailsView.widthAnchor, multiplier: 0.6),
            detailsLabel.centerYAnchor.constraint(equalTo: detailsView.centerYAnchor)
        ]
        
        let detailsSwitchConstraints = [
            detailsSwitch.widthAnchor.constraint(equalToConstant: 50.0),
            detailsSwitch.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor),
            detailsSwitch.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -10.0)
            
        ]
        
        [glossaryButtonConstraints, detailsViewConstraints, detailsLabelConstraints, detailsSwitchConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        detailsSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        detailsSwitch.isOn = true
        detailsSwitch.layer.cornerRadius = 16.0

    }
}
