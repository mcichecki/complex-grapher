import UIKit

final class PointCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "PointCollectionViewCell"
    
    private let complexNumberLabel: UILabel = {
        let complexNumberLabel = UILabel(frame: .zero)
        complexNumberLabel.backgroundColor = .green
        
        return complexNumberLabel
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        //        setupConstraints()
        setupStyling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupCell(with complexNumber: ComplexNumber) {
        print("complexNumber: \(complexNumber.description)")
        complexNumberLabel.text = complexNumber.description
    }
    
    private func addSubviews() {
        [complexNumberLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        //        NSLayoutConstraint.activate([
        //
        //            ])
        //        self.contentView.addConstraints([
        //            NSLayoutConstraint(item: complexNumberLabel, attribute: .top, relatedBy: .equal,
        //                               toItem: contentView, attribute: .top,
        //                               multiplier: 0.0, constant: 20.0)
        //            ])
        
        complexNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        complexNumberLabel.leadingAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0).isActive = true
        complexNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20.0).isActive = true
    }
    
    private func setupStyling() {
        contentView.backgroundColor = .yellow
    }
}
