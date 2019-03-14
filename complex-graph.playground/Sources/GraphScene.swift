import Foundation
import SpriteKit

public final class GraphScene: SKScene {
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .darkGray
        
        setupScene()
    }
    
    private func setupScene() {
        guard let frameWidth = self.view?.frame.width,
            let frameHeight = self.view?.frame.height else {
                return
        }
        
        let xAxisStartPoint = CGPoint(x: frameWidth * 0.5, y: 0.0)
        let xAxisEndPoint = CGPoint(x: frameWidth * 0.5, y: frameHeight)
        let xAxis = Axis(startPoint: xAxisStartPoint, endPoint: xAxisEndPoint)
        
        let yAxisStartPoint = CGPoint(x: 0.0, y: frameWidth * 0.5)
        let yAxisEndPoint = CGPoint(x: frameWidth, y: frameWidth * 0.5)
        let yAxis = Axis(startPoint: yAxisStartPoint, endPoint: yAxisEndPoint)
        
        [xAxis, yAxis]
            .forEach(addChild(_:))
    }
}
