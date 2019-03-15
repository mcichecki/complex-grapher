import Foundation
import SpriteKit

public final class GraphScene: SKScene {
    private let frameWidth: CGFloat
    
    private let frameHeight: CGFloat
    
    private let complexNumbersSet = ComplexNumbersSet()
    
    private let dashedPatter: [CGFloat] = [10.0, 8.0]
    
    private let lengthOfAxis: CGFloat = 700.0
    
    private let offset = CGPoint(x: 0.0, y: -100.0)
    
    private lazy var centerOfAxes: CGPoint = {
        return CGPoint(x: centerPoint.x + offset.x, y: centerPoint.y + offset.y)
    }()
    
    private var complexNumbers: [String: CGPoint] = [:]
    
    private var activePointName: String?
    
    private var pointTouch: UITouch?
    
    private lazy var centerPoint: CGPoint = {
        return CGPoint(x: frameWidth * 0.5, y: frameHeight * 0.5)
    }()
    
    private let complexNumberLabel: UILabel = {
        let complexNumberLabel = UILabel(frame: .zero)
        complexNumberLabel.textColor = .white
        complexNumberLabel.numberOfLines = 0
        complexNumberLabel.backgroundColor = .white
        complexNumberLabel.font = UIFont.systemFont(ofSize: 16.0)
        return complexNumberLabel
    }()
    
    private let pointsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let pointsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        pointsCollectionView.backgroundColor = .red
        return pointsCollectionView
    }()
    
    private enum NodeName {
        static let xAxisName = "x axis node"
        
        static let yAxisName = "y axis node"
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
        backgroundColor = .mainGray
        
        print("GraphScene dimensions: \(view.frame.size)")
        print("Center: \(centerPoint)")
        
        setupScene()
    }
    
    public func addPoint() {
        guard let attributedPoint = complexNumbersSet.add() else {
            return
        }
        
        let startingXPoint = CGFloat.random(in: frameWidth * 0.2...frameWidth * 0.8)
        let startingYPoint = CGFloat.random(in: frameWidth * 0.2...frameHeight * 0.8)
        let startingPoint = CGPoint(x: startingXPoint, y: startingYPoint)
        
        let pointNode = PointNode(radius: 10.0, position: startingPoint)
        pointNode.name = attributedPoint.complexNumberNodeName
        pointNode.zPosition = 5.0
        pointNode.fillColor = attributedPoint.nodeColor
        
        addChild(pointNode)
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        let dashedPath = vectorPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
        let vectorNode = SKShapeNode(path: dashedPath)
        vectorNode.name = attributedPoint.vectorNumberNodeName
        
        addChild(vectorNode)
        
        complexNumbers[attributedPoint.complexNumberNodeName] = pointNode.position
        activePointName = attributedPoint.complexNumberNodeName
    }
    
    private func setupScene() {
        setupAxes()
        
        //        setupComplexLabel()
        setupCollectionView()
    }
    
    private func setupAxes() {
        let xAxisNode = AxisNode(length: lengthOfAxis, center: centerOfAxes)
        xAxisNode.name = NodeName.xAxisName
        
        let yAxisNode = AxisNode(length: lengthOfAxis, center: centerOfAxes, orientation: .vertical)
        yAxisNode.name = NodeName.yAxisName
        
        [xAxisNode, yAxisNode]
            .forEach {
                addChild($0)
                $0.isUserInteractionEnabled = false
        }
        
        let centerNode = SKShapeNode(circleOfRadius: 5.0)
        centerNode.fillColor = .red
        centerNode.position = centerOfAxes
        addChild(centerNode)
    }
    
    private func setupCollectionView() {
        let collectionViewWidth: CGFloat = frameWidth * 0.95
        let collectionViewHeight: CGFloat = 120.0
        pointsCollectionView.frame = CGRect(x: (frameWidth - collectionViewWidth) * 0.5,
                                            y: 10.0,
                                            width: collectionViewWidth,
                                            height: collectionViewHeight)
        
        pointsCollectionView.register(PointCollectionViewCell.self,
                                      forCellWithReuseIdentifier: PointCollectionViewCell.reuseIdentifier)
        
        pointsCollectionView.dataSource = self
        
        
        self.view?.addSubview(pointsCollectionView)
    }
    
    //    private func setupComplexLabel() {
    //        let complexNumberLabelWidth: CGFloat = 320.0
    //        let complexNumberLabelHeight: CGFloat = 60.0
    //        complexNumberLabel.frame = CGRect(x: 10.0, y: 0, width: complexNumberLabelWidth, height: complexNumberLabelHeight)
    //
    //        self.view?.addSubview(complexNumberLabel)
    //    }
    
    private func updatePosition(_ position: CGPoint) {
        guard let activeName = activePointName else {
            print("no active")
            return
        }
        
        complexNumbers[activeName] = position
        
        //        print("complexNumbers: \(complexNumbers)")
        
        //        let attributedText = getFormattedLabelText()
        //        complexNumberLabel.attributedText = attributedText
    }
    
    private func getFormattedLabelText() -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: "")
        for i in 0..<complexNumbersSet.numberOfPoints {
            
            guard let nodeName = complexNumbersSet.attributedPoint(for: i)?.complexNumberNodeName,
                let nodePosition = childNode(withName: nodeName)?.position else {
                    continue
            }
            
            let complexNumber = transformPosition(nodePosition)
            let attributedString = NSAttributedString(string: "\(i): \(complexNumber.descriptionWithDegrees)\n", attributes: [NSAttributedString.Key.foregroundColor: complexNumbersSet.colorForPoint(nodeName) ?? .white])
            mutableAttributedString.append(attributedString)
            
        }
        return mutableAttributedString
    }
    
    private func transformPosition(_ position: CGPoint) -> ComplexNumber {
        let transformedPosition = CGPoint(x: position.x + offset.x * 0.5 - lengthOfAxis * 0.5,
                                          y: position.y + offset.y * 0.5 - lengthOfAxis * 0.5)
        let divisor = AxisNode.scaleOffset
        let zPosition = CGPoint(x: transformedPosition.x / divisor,
                                y: transformedPosition.y / divisor)
        
        //        print("og position: \(position)")
        //        print("transformed position: \(transformedPosition)")
        //        print("z position: \(zPosition)")
        
        let complexNumber = ComplexNumber(re: Double(zPosition.x).rounded(2),
                                          im: Double(zPosition.y).rounded(2))
        
        return complexNumber
    }
}

// MARK: Touch handling

extension GraphScene {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        for touch in touches {
            if let node = nodes(at: touch.location(in: self)).first,
                node.name?.contains(AttributedPoint.NodeNames.complexNumberNodeName.rawValue) ?? false {
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
            guard let activePointName = activePointName,
                let movedNode = childNode(withName: activePointName) else {
                    return
            }
            
            let newPath = CGMutablePath()
            newPath.move(to: centerOfAxes)
            newPath.addLine(to: location)
            let dashedPath = newPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
            
            let lineNode = childNode(withName: complexNumbersSet.vectorNameForPoint(activePointName) ?? "")
            if let lineNode = lineNode as? SKShapeNode {
                lineNode.path = dashedPath
            }
            
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

extension GraphScene: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of cells: \(complexNumbersSet.sortedSet.count)")
        return complexNumbersSet.sortedSet.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: PointCollectionViewCell.reuseIdentifier,
                                                              for: indexPath)
        
        guard let cell = dequeuedCell as? PointCollectionViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        guard let position = complexNumbers[activePointName ?? ""] else {
            fatalError("No complex number")
        }
        
        cell.setupCell(with: transformPosition(position))
        
        return cell
    }
}
