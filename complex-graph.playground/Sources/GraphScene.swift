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
    
    private enum NodeName {
        static let xAxisName = "x axis node"
        
        static let yAxisName = "y axis node"
        
        static let sumNumberName = "sum node"
        
        static let sumVectorNodeName = "sum vector"
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
    
    public func plot(complexNumber: ComplexNumber? = nil) {
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
        let dashedPath = vectorPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
        let vectorNode = SKShapeNode(path: dashedPath)
        vectorNode.name = attributedPoint.vectorNumberNodeName
        
        addChild(vectorNode)
        
        complexNumbers[attributedPoint.index] = pointNode.position
        activePointName = attributedPoint.complexNumberNodeName
    }
    
    private func plotSum(_ complexNumber: ComplexNumber) {
        let startingPoint = transformComplexNumber(complexNumber)
        
        let pointNode = PointNode(radius: 10.0, position: startingPoint)
        pointNode.name = NodeName.sumNumberName
        pointNode.zPosition = 5.0
        pointNode.fillColor = .white
        
        addChild(pointNode)
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        let dashedPath = vectorPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
        let vectorNode = SKShapeNode(path: dashedPath)
        vectorNode.name = NodeName.sumVectorNodeName
        
        addChild(vectorNode)
    }
    
    private func setupScene() {
        setupAxes()
        
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
        let position = plotComplexNumbersSum()
        
        guard let sumNode = childNode(withName: NodeName.sumNumberName) else {
            return
        }
        
        let newPath = CGMutablePath()
        newPath.move(to: centerOfAxes)
        newPath.addLine(to: position)
        let dashedPath = newPath.copy(dashingWithPhase: 1.0, lengths: dashedPatter)
        
        let lineNode = childNode(withName: NodeName.sumVectorNodeName)
        if let lineNode = lineNode as? SKShapeNode {
            lineNode.path = dashedPath
        }
        
        sumNode.position = position
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
