import Foundation
import SpriteKit

public final class PointNode: SKShapeNode {
    public override var fillColor: UIColor {
        didSet {
            strokeColor = fillColor.darker(by: 17.0)
        }
    }
    override public init() {
        super.init()
        setupPoint()
    }
    
    convenience init(radius: CGFloat, position: CGPoint) {
        self.init(circleOfRadius: radius)
        self.position = position
        setupPoint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPoint() {
        fillColor = .lightBlue
    }
}
