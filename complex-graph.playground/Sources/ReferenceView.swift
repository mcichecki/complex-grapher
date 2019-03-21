import UIKit

protocol ReferenceViewDelegate: AnyObject {
    func didClose()
}

public class ReferenceView: UIView {
    
    weak var delegate: ReferenceViewDelegate?
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let closeButton: UIButton = {
        let closeButton = UIButton(frame: .zero)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
        
        return closeButton
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupStyling()
    }
    
    private var selected: AngleOption = .degrees
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(blurEffectView)
        
        [closeButton].forEach { blurEffectView.contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        let blurEffectViewConstraints = [
            blurEffectView.widthAnchor.constraint(equalTo: widthAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        
        let closeButtonConstraints = [
            closeButton.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor)
        ]
        
        [blurEffectViewConstraints, closeButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupStyling() {
        
    }
    
    @objc private func onCloseButtonTap() {
        delegate?.didClose()
    }
}
