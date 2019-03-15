import Foundation
import SpriteKit

public final class GraphScene: SKScene {
    private let startingPoint = CGPoint(x: 380, y: 400)
    
    private var pointTouch: UITouch?
    
    private lazy var centerPoint: CGPoint = {
        return CGPoint(x: frameWidth * 0.5, y: frameHeight * 0.5)
    }()
    
    private var firstLineNode: SKShapeNode!
    
    private var firstLinePath: CGMutablePath!
    
    private var secondLineNode: SKShapeNode!
    
    private var secondLinePath: CGMutablePath!
    
    private let frameWidth: CGFloat
    
    private let frameHeight: CGFloat
    
    private var activePointName: String?
    
    private let complexNumberLabel: UILabel = {
        let complexNumberLabel = UILabel(frame: .zero)
        complexNumberLabel.textColor = .white
        complexNumberLabel.numberOfLines = 0
        complexNumberLabel.font = UIFont.systemFont(ofSize: 16.0)
        complexNumberLabel.layer.borderColor = UIColor.white.cgColor
        complexNumberLabel.layer.borderWidth = 2.0
        return complexNumberLabel
    }()
    
    private enum NodeName {
        static let xAxisName = "x axis node"
        
        static let yAxisName = "y axis node"
        
        static let firstPointNodeName = "first point node"
        
        static let secondPointNodeName = "second point node"
        
        static let firstLineNodeName = "first line node"
        
        static let secondLineNodeName = "second line node"
    }
    
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
        backgroundColor = .mainBlue
        
        print("GraphScene dimensions: \(view.frame.size)")
        
        setupScene()
    }
    
    private func setupScene() {
        setupAxes()
        setupFirstPoint()
        setupSecondPoint()
        setupComplexLabel()
    }
    
    private func setupAxes() {
        let xAxisStartPoint = CGPoint(x: frameWidth * 0.5, y: 0.0)
        let xAxisEndPoint = CGPoint(x: frameWidth * 0.5, y: frameHeight)
        let xAxisNode = AxisNode(startPoint: xAxisStartPoint, endPoint: xAxisEndPoint)
        xAxisNode.name = NodeName.xAxisName
        
        let yAxisStartPoint = CGPoint(x: 0.0, y: frameWidth * 0.5)
        let yAxisEndPoint = CGPoint(x: frameWidth, y: frameWidth * 0.5)
        let yAxisNode = AxisNode(startPoint: yAxisStartPoint, endPoint: yAxisEndPoint)
        yAxisNode.name = NodeName.yAxisName
        
        [xAxisNode, yAxisNode]
            .forEach {
                addChild($0)
                $0.isUserInteractionEnabled = false
        }
    }
    
    private func setupFirstPoint() {
        let pointNode = PointNode(radius: 10.0, position: startingPoint)
        pointNode.name = NodeName.firstPointNodeName
        pointNode.zPosition = 5.0
        
        addChild(pointNode)
        
        setupFirstLine()
    }
    
    private func setupFirstLine() {
        firstLinePath = CGMutablePath()
        firstLinePath.move(to: centerPoint)
        firstLinePath.addLine(to: startingPoint)
        let dashedPath = firstLinePath.copy(dashingWithPhase: 1.0, lengths: [10.0, 8.0])
        firstLineNode = SKShapeNode(path: dashedPath)
        firstLineNode.name = NodeName.firstLineNodeName
        
        addChild(firstLineNode)
    }
    
    private func setupSecondPoint() {
        let pointNode = PointNode(radius: 10.0, position: startingPoint)
        pointNode.name = NodeName.secondPointNodeName
        pointNode.zPosition = 5.0
        
        addChild(pointNode)
        
        setupSecondLine()
    }
    
    private func setupSecondLine() {
        secondLinePath = CGMutablePath()
        secondLinePath.move(to: centerPoint)
        secondLinePath.addLine(to: startingPoint)
        let dashedPath = secondLinePath.copy(dashingWithPhase: 1.0, lengths: [10.0, 8.0])
        secondLineNode = SKShapeNode(path: dashedPath)
        secondLineNode.name = NodeName.secondLineNodeName
        
        addChild(secondLineNode)
    }
    
    private func setupComplexLabel() {
        let complexNumberLabelWidth: CGFloat = 300.0
        let complexNumberLabelHeight: CGFloat = 60.0
        complexNumberLabel.frame = CGRect(x: 10.0, y: 0, width: complexNumberLabelWidth, height: complexNumberLabelHeight)
        
        self.view?.addSubview(complexNumberLabel)
    }
    
    private func updatePosition(_ position: CGPoint) {
        let transformedPosition = CGPoint(x: position.x - frameHeight * 0.5,
                                          y: position.y - frameWidth * 0.5)
        let divisor = AxisNode.scaleOffset
        let zPosition = CGPoint(x: transformedPosition.x / divisor,
                                y: transformedPosition.y / divisor)
        
        //        print("og position: \(position)")
        //        print("transformed position: \(transformedPosition)")
        //        print("z position: \(zPosition)")
        
        let complexNumber = ComplexNumber(re: Double(zPosition.x).rounded(2),
                                          im: Double(zPosition.y).rounded(2))
        
        complexNumberLabel.text = "Complex number:\n\(complexNumber.descriptionWithDegrees)"
    }
}

// MARK: Touch handling

extension GraphScene {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        for touch in touches {
            if let node = nodes(at: touch.location(in: self)).first,
                node.name == NodeName.firstPointNodeName || node.name == NodeName.secondPointNodeName {
                // switching between points
                activePointName = node.name
                pointTouch = touch
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointTouch = pointTouch else {
            return
        }
        
        //        print("touches moved")
        for touch in touches where touch == pointTouch {
            let location = touch.location(in: self)
            guard let movedNode = childNode(withName: activePointName ?? "") else {
                return
            }
            //            let touchedNodes = nodes(at: location)
            //            guard let touchedNode = touchedNodes.first,
            //                touchedNode.name == NodeName.pointNodeName else {
            //                    self.pointTouch = nil
            //                    return
            //            }
            
            let newPath = CGMutablePath()
            newPath.move(to: centerPoint)
            newPath.addLine(to: location)
            let dashedPath = newPath.copy(dashingWithPhase: 1.0, lengths: [10.0, 8.0])
            let activeLineNode = activePointName == NodeName.firstPointNodeName ? firstLineNode : secondLineNode
            activeLineNode?.path = dashedPath
            
            movedNode.position = location
            updatePosition(movedNode.position)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointTouch = pointTouch else {
            return
        }
        
        print("touches ended")
        for touch in touches where touch == pointTouch {
            self.pointTouch = nil
        }
    }
}
