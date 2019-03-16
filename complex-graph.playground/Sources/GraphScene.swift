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
    
    private var complexNumbers: [Int: CGPoint] = [:]
    
    private var activePointName: String?
    
    private var pointTouch: UITouch?
    
    private lazy var centerPoint: CGPoint = {
        return CGPoint(x: frameWidth * 0.5, y: frameHeight * 0.5)
    }()
    
    private let pointsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        flowLayout.estimatedItemSize = CGSize(width: 50.0, height: 50.0)
        let pointsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        pointsCollectionView.backgroundColor = .clear
        return pointsCollectionView
    }()
    
    private enum NodeName: String {
        case xAxis
        case yAxis
        case sumNumber
        case sumVectorNode
        case arcNode
        case firstSumVector
        case secondSumVector
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
        
        // TODO: move somewhere else
        
        plotComplexNumbersSum(true)
    }
    
    //    public override func update(_ currentTime: TimeInterval) {
    //        super.update(currentTime)
    //
    //        print("children: \(children.count)")
    //    }
    
    public func plot(complexNumber: ComplexNumber? = nil, withArc: Bool = false) {
        guard let attributedPoint = complexNumbersSet.add() else {
            return
        }
        
        let yAbsoluteOffset = abs(offset.y)
        let startingXPoint = CGFloat.random(in: frameWidth * 0.2...frameWidth * 0.8)
        let startingYPoint = CGFloat.random(in: yAbsoluteOffset * 1.2...(yAbsoluteOffset + lengthOfAxis) * 0.8)
        let randomPoint = CGPoint(x: startingXPoint, y: startingYPoint)
        
        var startingPoint = randomPoint
        
        if let complexNumber = complexNumber {
            startingPoint = transformComplexNumber(complexNumber)
        }
        
        let pointNode = PointNode(radius: 10.0, position: startingPoint)
        pointNode.name = attributedPoint.complexNumberNodeName
        pointNode.zPosition = 5.0
        pointNode.fillColor = attributedPoint.nodeColor
        
        addChild(pointNode)
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        let vectorNode = SKShapeNode(path: vectorPath)
        vectorNode.strokeColor = attributedPoint.nodeColor
        vectorNode.name = attributedPoint.vectorNumberNodeName
        
        addChild(vectorNode)
        
        complexNumbers[attributedPoint.index] = pointNode.position
        activePointName = attributedPoint.complexNumberNodeName
        
        if withArc {
            plotArc(startingPoint)
        }
    }
    
    private func plotArc(_ position: CGPoint) {
        let complexNumber = transformPosition(position)
        let endAngle = CGFloat(complexNumber.thetaRadians)
        let radius = CGFloat(complexNumber.modulus) * AxisNode.scaleOffset * 0.5
        
        let arcPath = UIBezierPath(arcCenter: centerOfAxes, radius: radius,
                                   startAngle: 0, endAngle: endAngle,
                                   clockwise: true)
        let arcDashedPath = arcPath.cgPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
        
        let arcNode = SKShapeNode(path: arcDashedPath)
        arcNode.name = NodeName.arcNode.rawValue
        addChild(arcNode)
    }
    
    private func plotSum(_ complexNumber: ComplexNumber) {
        let startingPoint = transformComplexNumber(complexNumber)
        
        let pointNode = PointNode(radius: 10.0, position: startingPoint)
        pointNode.name = NodeName.sumNumber.rawValue
        pointNode.zPosition = 5.0
        pointNode.fillColor = .white
        
        addChild(pointNode)
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        let vectorNode = SKShapeNode(path: vectorPath)
        vectorNode.name = NodeName.sumVectorNode.rawValue
        
        addChild(vectorNode)
    }
    
    private func setupScene() {
        setupAxes()
        
        setupCollectionView()
    }
    
    private func setupAxes() {
        let xAxisNode = AxisNode(length: lengthOfAxis, center: centerOfAxes)
        xAxisNode.name = NodeName.xAxis.rawValue
        
        let yAxisNode = AxisNode(length: lengthOfAxis, center: centerOfAxes, orientation: .vertical)
        yAxisNode.name = NodeName.yAxis.rawValue
        
        [xAxisNode, yAxisNode]
            .forEach {
                addChild($0)
                $0.isUserInteractionEnabled = false
        }
        
        //        let centerNode = SKShapeNode(circleOfRadius: 5.0)
        //        centerNode.fillColor = .red
        //        centerNode.position = centerOfAxes
        //        addChild(centerNode)
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
        pointsCollectionView.register(AddPointCollectionViewCell.self,
                                      forCellWithReuseIdentifier: AddPointCollectionViewCell.reuseIdentifier)
        
        pointsCollectionView.dataSource = self
        pointsCollectionView.delegate = self
        
        self.view?.addSubview(pointsCollectionView)
    }
    
    @discardableResult
    private func plotComplexNumbersSum(_ plot: Bool = false) -> CGPoint {
        let sum = complexNumbers
            .map { transformPosition($0.value) }
            .reduce(ComplexNumber(re: 0.0, im: 0.0)) { (result, complexNumber) in
                return result + complexNumber
        }
        
        if plot {
            plotSum(sum)
        }
        
        return transformComplexNumber(sum)
    }
    
    private func updatePosition(_ position: CGPoint) {
        guard let activeName = activePointName else {
            print("no active")
            return
        }
        
        guard let lastCharacter = activeName.last,
            let activeNameIndex = Int(String(lastCharacter)) else {
                return
        }
        complexNumbers[activeNameIndex] = position
        
        let section = complexNumbersSet.reachedMaxNumberOfElements ? 0 : 1
        let indexPathToBeReloaded = IndexPath(item: activeNameIndex, section: section)
        pointsCollectionView.reloadItems(at: [indexPathToBeReloaded])
        
        // update sum
        updateSumPosition()
    }
    
    private func updateSumPosition() {
        let sumPosition = plotComplexNumbersSum()
        
        guard let sumNode = childNode(withName: NodeName.sumNumber.rawValue) else {
            return
        }
        
        let newPath = CGMutablePath()
        newPath.move(to: centerOfAxes)
        newPath.addLine(to: sumPosition)
        
        let vectorNode = childNode(withName: NodeName.sumVectorNode.rawValue)
        if let vectorNode = vectorNode as? SKShapeNode {
            vectorNode.path = newPath
        }
        
        if complexNumbers.count == 2 {
            if childNode(withName: NodeName.firstSumVector.rawValue) == nil || childNode(withName: NodeName.secondSumVector.rawValue) == nil {
                for complexNumberPosition in complexNumbers {
                    let sumVectorPath = CGMutablePath()
                    sumVectorPath.move(to: complexNumberPosition.value)
                    sumVectorPath.addLine(to: sumPosition)
                    
                    let sumVectorNode = SKShapeNode(path: sumVectorPath)
                    switch complexNumberPosition.key {
                    case 0:
                        sumVectorNode.name = NodeName.firstSumVector.rawValue
                    case 1:
                        sumVectorNode.name = NodeName.secondSumVector.rawValue
                    default:
                        return
                    }
                    
                    sumVectorNode.strokeColor = .white
                    addChild(sumVectorNode)
                }
            } else {
                let firstSumVector = childNode(withName: NodeName.firstSumVector.rawValue)
                if let firstSumVector = firstSumVector as? SKShapeNode {
                    let sumVectorPath = CGMutablePath()
                    sumVectorPath.move(to: complexNumbers[0] ?? .zero)
                    sumVectorPath.addLine(to: sumPosition)
                    
                    firstSumVector.path = sumVectorPath
                }
                
                let secondSumVector = childNode(withName: NodeName.secondSumVector.rawValue)
                if let secondSumVector = secondSumVector as? SKShapeNode {
                    let sumVectorPath = CGMutablePath()
                    sumVectorPath.move(to: complexNumbers[1] ?? .zero)
                    sumVectorPath.addLine(to: sumPosition)
                    
                    secondSumVector.path = sumVectorPath
                }
            }
        } else {
            let firstSumVector = childNode(withName: NodeName.firstSumVector.rawValue)
            let secondSumVector = childNode(withName: NodeName.secondSumVector.rawValue)
            
            [firstSumVector, secondSumVector].forEach { $0?.removeFromParent() }
        }
        
        sumNode.position = sumPosition
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
    
    private func transformComplexNumber(_ complexNumber: ComplexNumber) -> CGPoint {
        let multiplier = Double(AxisNode.scaleOffset)
        let multipledPosition = CGPoint(x: (complexNumber.realPart ?? 0.0) * multiplier,
                                        y: (complexNumber.imaginaryPart ?? 0.0) * multiplier)
        let graphPosition = CGPoint(x: multipledPosition.x + centerOfAxes.x,
                                    y: multipledPosition.y + centerOfAxes.y)
        
        //        print("complexNumber: x: \(complexNumber.realPart) + y: \(complexNumber.imaginaryPart)")
        //        print("mult position: \(multipledPosition)")
        //        print("graph position: \(graphPosition)")
        
        return graphPosition
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
            
            // vector
            let vecctorNode = childNode(withName: complexNumbersSet.vectorNameForPoint(activePointName) ?? "")
            if let vecctorNode = vecctorNode as? SKShapeNode {
                vecctorNode.path = newPath
            }
            
            // arc
            let complexNumber = transformPosition(movedNode.position)
            let endAngle = CGFloat(complexNumber.thetaRadians)
            let radius = CGFloat(complexNumber.modulus) * AxisNode.scaleOffset * 0.5
            
            let arcPath = UIBezierPath(arcCenter: centerOfAxes, radius: radius,
                                       startAngle: 0, endAngle: endAngle,
                                       clockwise: true)
            
            let arcNode = childNode(withName: NodeName.arcNode.rawValue)
            if let arcNode = arcNode as? SKShapeNode {
                let arcDashedPath = arcPath.cgPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
                arcNode.path = arcDashedPath
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

// MARK: UICollectionViewDataSource methods

extension GraphScene: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return complexNumbersSet.reachedMaxNumberOfElements ? 1 : 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return complexNumbersSet.reachedMaxNumberOfElements ? complexNumbersSet.sortedSet.count : 1
        } else if section == 1 {
            return complexNumbersSet.sortedSet.count
        }
        
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (indexPath.section != 0 ||
            complexNumbersSet.reachedMaxNumberOfElements) else {
                let pointCellIdentifier = AddPointCollectionViewCell.reuseIdentifier
                let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: pointCellIdentifier,
                                                                      for: indexPath)
                
                guard let cell = dequeuedCell as? AddPointCollectionViewCell else {
                    fatalError("Could not dequeue a cell")
                }
                
                return cell
        }
        
        let pointCellIdentifier = PointCollectionViewCell.reuseIdentifier
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: pointCellIdentifier,
                                                              for: indexPath)
        
        guard let cell = dequeuedCell as? PointCollectionViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        guard let position = complexNumbers[indexPath.item] else {
            fatalError("No complex number")
        }
        
        cell.setupCell(with: transformPosition(position), color: complexNumbersSet.sortedSet[indexPath.item].nodeColor)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate methods

extension GraphScene: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0,
            indexPath.item == 0 else {
                return
        }
        
        plot()
        
        if complexNumbersSet.reachedMaxNumberOfElements {
            collectionView.reloadData()
            return
        }
        
        updateSumPosition()
        let newItemIndexPath = IndexPath(item: complexNumbersSet.numberOfPoints - 1, section: 1)
        collectionView.insertItems(at: [newItemIndexPath])
    }
}
