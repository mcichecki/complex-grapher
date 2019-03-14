import Foundation
import SpriteKit

public final class GraphScene: SKScene {
    private let frameWidth: CGFloat
    
    private let frameHeight: CGFloat
    
    public override init(size: CGSize) {
        self.frameWidth = size.width
        self.frameHeight = size.height
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .darkGray
        
        print("GraphScene dimensions: \(view.frame.size)")
    }
}
