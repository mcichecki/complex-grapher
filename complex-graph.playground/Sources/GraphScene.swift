import Foundation
import SpriteKit

public final class GraphScene: SKScene {
    private let frameWidth: CGFloat
    
    private let frameHeight: CGFloat
    
    private let complexNumbersSet = ComplexNumbersSet()
    
    private let dashedPatter: [CGFloat] = [10.0, 8.0]
    
    private let lengthOfAxis: CGFloat = 700.0
    
    private let offset = CGPoint(x: 0.0, y: -100.0)
    
    private let positionLabelOffset = CGPoint(x: 0.0, y: 15.0)
    
    private lazy var centerOfAxes: CGPoint = {
        return CGPoint(x: centerPoint.x + offset.x, y: centerPoint.y + offset.y)
    }()
    
    private var complexNumbersPositions: [CGPoint] = []
    
    private var activePointName: String?
    
    private var pointTouch: UITouch?
    
    private lazy var centerPoint: CGPoint = {
        return CGPoint(x: frameWidth * 0.5, y: frameHeight * 0.5)
    }()
    
    private lazy var arcLabelNode: SKLabelNode = {
        let arcLabelNode = SKLabelNode(fontNamed: "SFCompactText-Regular")
        arcLabelNode.fontSize = 14.0
        arcLabelNode.name = NodeName.arcLabel.rawValue
        arcLabelNode.fontColor = .white
        
        return arcLabelNode
    }()
    
    private lazy var positionLabelNode: SKLabelNode = {
        let positionLabelNode = SKLabelNode(fontNamed: "SFCompactText-Regular")
        positionLabelNode.fontSize = 14.0
        positionLabelNode.name = NodeName.positionLabel.rawValue
        positionLabelNode.fontColor = .white
        
        return positionLabelNode
    }()
    
    private let pointsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        flowLayout.estimatedItemSize = CGSize(width: 50.0, height: 50.0)
        
        let pointsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        pointsCollectionView.backgroundColor = .clear
        pointsCollectionView.isUserInteractionEnabled = true
        pointsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return pointsCollectionView
    }()
    
    private let sumLabel: UILabel = {
        let sumLabel = UILabel(frame: .zero)
        //        sumLabel.text = "sum: (1.5 + 2.0) + (2.0 + 2.5)i = 3.5 + 4.5i"
        sumLabel.textColor = .white
        
        return sumLabel
    }()
    
    private let realLabel: UILabel = {
        let realLabel = UILabel(frame: .zero)
        realLabel.textColor = .white
        
        return realLabel
    }()
    
    private let imaginaryLabel: UILabel = {
        let imaginaryLabel = UILabel(frame: .zero)
        imaginaryLabel.textColor = .white
        
        return imaginaryLabel
    }()
    
    private enum NodeName: String {
        case xAxis
        case yAxis
        case sumNumber
        case sumVectorNode
        case arcNode
        case arcLabel
        case firstSumVector
        case secondSumVector
        case positionLabel
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
        //        print("new name: \(attributedPoint.complexNumberNodeName)")
        pointNode.zPosition = 5.0
        pointNode.fillColor = attributedPoint.nodeColor
        
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        let vectorNode = SKShapeNode(path: vectorPath)
        vectorNode.strokeColor = attributedPoint.nodeColor
        vectorNode.name = attributedPoint.vectorNumberNodeName
        
        [pointNode, vectorNode]
            .forEach(addChild(_:))
        
        complexNumbersPositions.append(pointNode.position)
        activePointName = attributedPoint.complexNumberNodeName
        
        switch complexNumbersSet.numberOfPoints {
        case 1:
            plotArc(startingPoint)
            positionLabelNode.text = ""
            addChild(positionLabelNode)
        case 2:
            plotComplexNumbersSum(true)
        default:
            return
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
        arcNode.alpha = 0.5
        arcNode.name = NodeName.arcNode.rawValue
        addChild(arcNode)
        
        let cosAlpha = cos(endAngle)
        let sinAlpha = sin(endAngle)
        let xPoint = cosAlpha * radius
        let yPoint = sinAlpha * radius
        
        // arc label
        let labelPosition = CGPoint(x: centerOfAxes.x + xPoint, y: centerOfAxes.y + yPoint)
        arcLabelNode.text = complexNumber.degreesDescription
        arcLabelNode.position = labelPosition
        
        addChild(arcLabelNode)
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
        setupLabels()
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
    
    private func setupLabels() {
        let width: CGFloat = frameWidth * 0.95
        let height: CGFloat = 20.0
        
        [sumLabel,
         realLabel,
         imaginaryLabel]
            .enumerated()
            .forEach {
                $0.element.frame = CGRect(x: (frameWidth - width) * 0.5,
                                          y: 140.0 + CGFloat($0.offset * 25),
                                          width: width,
                                          height: height)
                self.view?.addSubview($0.element)
        }
    }
    
    @discardableResult
    private func plotComplexNumbersSum(_ plot: Bool = false) -> CGPoint {
        let complexNumbers = complexNumbersPositions
            .map { transformPosition($0) }
        
        let sum = complexNumbers
            .reduce(ComplexNumber(re: 0.0, im: 0.0)) { (result, complexNumber) in
                return result + complexNumber
        }
        
        if plot {
            plotSum(sum)
        }
        
        let realParts = complexNumbers
            .compactMap { $0.realPart }
        
        let imaginaryParts = complexNumbers
            .compactMap { $0.imaginaryPart }
        
        var realPartsString = ""
        var imaginaryPartsString = ""
        
        [realParts,
         imaginaryParts]
            .enumerated()
            .forEach {
                for (index, part) in $0.element.enumerated() {
                    let isReal = $0.offset == 0
                    if index == 0 {
                        isReal ?
                            realPartsString.append("\(part)") :
                            imaginaryPartsString.append("\(part)")
                    } else {
                        let sign = part < 0 ? "-" : "+"
                        isReal ?
                            realPartsString.append(" \(sign)" + " \(abs(part))") :
                            imaginaryPartsString.append(" \(sign)" + " \(abs(part))")
                    }
                }
        }
        
        let sumString = "sum: \(sum.description)"
        //        let realPartsWithDescription = "real: \(realPartsString)"
        //        let imaginaryPartsWithDescription = "im: \(imaginaryPartsString)"
        
        let font = realLabel.font
        let defaultAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let greenTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.nodesColors[2],
                                                                  .font: UIFont.systemFont(ofSize: font?.pointSize ?? 15.0, weight: .bold)]
        let orangeTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.nodesColors[4],
                                                                   .font: UIFont.systemFont(ofSize: font?.pointSize ?? 15.0, weight: .bold)]
        
        let realAttributedString = NSMutableAttributedString(string: "real: ",
                                                             attributes: defaultAttributes)
        let realPartAttributedString = NSAttributedString(string: realPartsString,
                                                          attributes: greenTextAttributes)
        realAttributedString.append(realPartAttributedString)
        
        let imaginaryAttributedString = NSMutableAttributedString(string: "imaginary: ",
                                                                  attributes: defaultAttributes)
        let imaginaryPartAttributedString = NSAttributedString(string: imaginaryPartsString,
                                                               attributes: orangeTextAttributes)
        
        let sumAttributedString = NSMutableAttributedString(string: "sum: ", attributes: defaultAttributes)
        let realPartSumAttributedString = NSAttributedString(string: "\(sum.realPart?.rounded(2) ?? 0.0)", attributes: greenTextAttributes)
        let signAttributedString = NSAttributedString(string: (sum.imaginaryPart ?? 0.0) < 0.0 ? " - " : " + ", attributes: defaultAttributes)
        let imaginaryPartSumAttributedString = NSAttributedString(string: "\(abs(sum.imaginaryPart?.rounded(2) ?? 0.0))i", attributes: orangeTextAttributes)
        sumAttributedString.append(realPartSumAttributedString)
        sumAttributedString.append(signAttributedString)
        sumAttributedString.append(imaginaryPartSumAttributedString)
        
        imaginaryAttributedString.append(imaginaryPartAttributedString)
        sumLabel.attributedText = sumAttributedString
        realLabel.attributedText = realAttributedString
        imaginaryLabel.attributedText = imaginaryAttributedString
        return transformComplexNumber(sum)
    }
    
    private func updatePosition(_ position: CGPoint) {
        guard let activeName = activePointName else {
            print("no active")
            return
        }
        
        let index = complexNumbersSet.indexForPoint(activeName)
        
        complexNumbersPositions[index] = position
        
        let section = complexNumbersSet.reachedMaxNumberOfElements ? 0 : 1
        let indexPathToBeReloaded = IndexPath(item: index, section: section)
        pointsCollectionView.reloadItems(at: [indexPathToBeReloaded]) // << it has to be changed!
        
        // update sum, do we need this if?
        if complexNumbersSet.numberOfPoints > 1 {
            updateSumPosition()
        } else {
            childNode(withName: NodeName.sumNumber.rawValue)?.removeFromParent()
            childNode(withName: NodeName.sumVectorNode.rawValue)?.removeFromParent()
        }
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
        
        let numberOfComplexNumbers = complexNumbersPositions.count
        
        switch numberOfComplexNumbers {
        case 2: // two nodes = sum vectors
            if childNode(withName: NodeName.firstSumVector.rawValue) == nil || childNode(withName: NodeName.secondSumVector.rawValue) == nil {
                for (index, complexNumberPosition) in complexNumbersPositions.enumerated() {
                    let sumVectorPath = CGMutablePath()
                    sumVectorPath.move(to: complexNumberPosition)
                    sumVectorPath.addLine(to: sumPosition)
                    let dashedPath = sumVectorPath.copy(dashingWithPhase: 10.0, lengths: dashedPatter)
                    let sumVectorNode = SKShapeNode(path: dashedPath)
                    switch index {
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
                    let index = 0
                    sumVectorPath.move(to: complexNumbersPositions.elementExists(at: index) ? complexNumbersPositions[index] : .zero)
                    sumVectorPath.addLine(to: sumPosition)
                    
                    let dashedPath = sumVectorPath.copy(dashingWithPhase: 10.0, lengths: dashedPatter)
                    firstSumVector.alpha = 0.5
                    firstSumVector.path = dashedPath
                }
                
                let secondSumVector = childNode(withName: NodeName.secondSumVector.rawValue)
                if let secondSumVector = secondSumVector as? SKShapeNode {
                    let sumVectorPath = CGMutablePath()
                    let index = 1
                    sumVectorPath.move(to: complexNumbersPositions.elementExists(at: index) ? complexNumbersPositions[index] : .zero)
                    sumVectorPath.addLine(to: sumPosition)
                    
                    let dashedPath = sumVectorPath.copy(dashingWithPhase: 10.0, lengths: dashedPatter)
                    secondSumVector.alpha = 0.5
                    secondSumVector.path = dashedPath
                }
            }
        case 1:
            let sumVectorNode = childNode(withName: NodeName.sumVectorNode.rawValue)
            let sumVectorPoint = childNode(withName: NodeName.sumNumber.rawValue)
            
            [sumVectorNode, sumVectorPoint]
                .forEach { $0?.removeFromParent() }
            fallthrough
        default:
            let firstSumVector = childNode(withName: NodeName.firstSumVector.rawValue)
            let secondSumVector = childNode(withName: NodeName.secondSumVector.rawValue)
            
            [firstSumVector, secondSumVector]
                .forEach { $0?.removeFromParent() }
        }
        
        sumNode.position = sumPosition
    }
    
    // TODO: Remove
    private func listPoints() -> String {
        return "\(complexNumbersPositions.map { transformPosition($0) }))"
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
        print("=== touches began")
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
        
        //        print("=== touches moved")
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
            
            [NodeName.arcNode,
             NodeName.arcLabel,
             NodeName.positionLabel]
                .map { $0.rawValue }
                .compactMap { childNode(withName: $0) }
                .forEach { $0.isHidden = false }
            
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
            
            if let arcLabel = childNode(withName: NodeName.arcLabel.rawValue) as? SKLabelNode {
                let cosAlpha = cos(endAngle)
                let sinAlpha = sin(endAngle)
                let xPoint = cosAlpha * radius
                let yPoint = sinAlpha * radius
                let labelPosition = CGPoint(x: centerOfAxes.x + xPoint, y: centerOfAxes.y + yPoint)
                arcLabel.text = complexNumber.degreesDescription
                arcLabel.position = labelPosition
            }
            
            if let positionLabel = childNode(withName: NodeName.positionLabel.rawValue) as? SKLabelNode {
                positionLabel.text = complexNumber.description
                let labelPosition = CGPoint(x: movedNode.position.x + positionLabelOffset.x,
                                            y: movedNode.position.y + positionLabelOffset.y)
                positionLabel.position = labelPosition
            }
            
            movedNode.position = location
            
            updatePosition(movedNode.position)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointTouch = pointTouch else {
            return
        }
        
        print("=== touches ended")
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
        
        //        guard let position = complexNumbers[indexPath.item] else {
        //            print("complexNumbers: \(complexNumbers)")
        //            fatalError("No complex number for \(indexPath.item)")
        //        }
        guard indexPath.item <= complexNumbersPositions.count - 1 else {
            fatalError("No complex number for \(indexPath.item)")
        }
        
        let position = complexNumbersPositions[indexPath.item]
        
        cell.tag = indexPath.item
        cell.delegate = self
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
        //        print(#line)
        
        if complexNumbersSet.reachedMaxNumberOfElements {
            collectionView.reloadData()
            return
        }
        
        updateSumPosition()
        let newItemIndexPath = IndexPath(item: complexNumbersSet.numberOfPoints - 1, section: 1)
        collectionView.insertItems(at: [newItemIndexPath])
    }
}

// MARK: PointCollectionViewCellDelegateMethods

extension GraphScene: PointCollectionViewCellDelegate {
    func didTapRemove(_ cell: PointCollectionViewCell, item: Int) {
        let activeIndex = complexNumbersSet.indexForPoint(activePointName ?? "")
        print("remove: \(item), active: \(activeIndex)")
        
        // TODO: fix
        complexNumbersSet.remove(at: item)
            .forEach {
                childNode(withName: $0)?.removeFromParent()
        }
        
        let nodes = [
            NodeName.arcNode,
            NodeName.arcLabel,
            NodeName.positionLabel
        ]
        
        if complexNumbersSet.numberOfPoints == 0 {
            nodes.map { $0.rawValue }
                .compactMap { childNode(withName: $0) }
                .forEach { $0.removeFromParent() }
        }
        
        //        if activeIndex == item {
        nodes.map { $0.rawValue }
            .compactMap { childNode(withName: $0) }
            .forEach { $0.isHidden = true }
        //        }
        
        complexNumbersPositions.remove(at: item)
        updateSumPosition()
        pointsCollectionView.reloadData()
    }
}
