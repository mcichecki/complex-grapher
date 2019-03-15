import Foundation
import SpriteKit

public final class PointNode: SKShapeNode {
    //    private let initialPosition: CGP.oint
    
    //    override init() {
    //        super.init()
    //    }
    //
    //    public convenience init(position: CGPoint, radius: CGFloat) {
    //        self.init()
    //        self.init(circleOfRadius: radius)
    //    }
    
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
        strokeColor = .darkBlue
    }
}
