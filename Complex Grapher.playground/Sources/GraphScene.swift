import Foundation
import SpriteKit

public final class GraphScene: SKScene {
    public let sceneSize = CGSize(width: 700.0, height: 950.0)
    private(set) static var angleOption = AngleOption.degrees
    private let frameWidth: CGFloat
    private let frameHeight: CGFloat
    private let complexNumbersList = ComplexNumbersList()
    private var complexNumbersPositions: [CGPoint] = []
    private var activePointName: String?
    private var pointTouch: UITouch?
    private var throttle = 0
    private let sumVectorView = SumVectorView(frame: .zero)
    private let referenceView = ReferenceView(frame: .zero)
    private lazy var speechSynthesizer = SpeechSynthesizer()
    private lazy var centerOfAxes: CGPoint = { return centerPoint + Constant.offset }()
    private lazy var centerPoint: CGPoint = { return CGPoint(x: frameWidth * 0.5, y: frameHeight * 0.5) }()
    
    private let bottomView = BottomView()
    
    private lazy var sumLabel: UILabel = {
        let sumLabel = UILabel(frame: .zero)
        sumLabel.text = "Sum: "
        sumLabel.font = UIFont.systemFont(ofSize: 14.0)
        sumLabel.textColor = .white
        
        return sumLabel
    }()
    
    private lazy var angleControlView: AngleControlView = {
        let angleControlView = AngleControlView(frame: .zero)
        angleControlView.translatesAutoresizingMaskIntoConstraints = false
        return angleControlView
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
        pointsCollectionView.alwaysBounceHorizontal = true
        
        return pointsCollectionView
    }()
    
    private let topStackView: UIStackView = {
        let topStackView = UIStackView(frame: .zero)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .vertical
        topStackView.spacing = 2.0
        
        return topStackView
    }()
    
    private enum NodeName: String {
        case xAxis, yAxis
        case sumNumber, sumVectorNode
        case arcNode, arcLabel
        case firstSumVector, secondSumVector
        case positionLabel
    }
    
    private enum Constant {
        static let lengthOfAxis: CGFloat = 700.0
        static let offset = CGPoint(x: 0.0, y: -125.0)
        static let positionLabelOffset = CGPoint(x: 0.0, y: 15.0)
        static let dashedPattern: [CGFloat] = [10.0, 8.0]
    }
    
    public override init() {
        self.frameWidth = sceneSize.width
        self.frameHeight = sceneSize.height
        
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .mainGray
        
        setupScene()
    }
    
    public func plot(complexNumber: ComplexNumber? = nil, withArc: Bool = false) {
        guard let attributedPoint = complexNumbersList.add() else { return }
        
        let yAbsoluteOffset = abs(Constant.offset.y)
        let startingXPoint = CGFloat.random(in: frameWidth * 0.2...frameWidth * 0.8)
        let startingYPoint = CGFloat.random(in: yAbsoluteOffset * 1.2...(yAbsoluteOffset + Constant.lengthOfAxis) * 0.8)
        let randomPoint = CGPoint(x: startingXPoint, y: startingYPoint)
        
        var startingPoint = randomPoint
        
        if let complexNumber = complexNumber {
            startingPoint = transformComplexNumber(complexNumber)
        }
        
        let pointNode = PointNode(radius: 7.0, position: startingPoint)
        pointNode.name = attributedPoint.complexNumberNodeName
        pointNode.zPosition = 5.0
        pointNode.fillColor = attributedPoint.nodeColor
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        
        let vectorNode = SKShapeNode(path: vectorPath)
        vectorNode.lineWidth = 2.0
        vectorNode.strokeColor = attributedPoint.nodeColor
        vectorNode.name = attributedPoint.vectorNumberNodeName
        
        [pointNode, vectorNode].forEach(addChild(_:))
        
        complexNumbersPositions.append(pointNode.position)
        activePointName = attributedPoint.complexNumberNodeName
        
        switch complexNumbersList.numberOfPoints {
        case 1:
            plotArc(startingPoint)
            positionLabelNode.text = ""
            positionLabelNode.zPosition = 10.0
            addChild(positionLabelNode)
        case 2:
            plotComplexNumbersSumIfNeeded(true)
            fallthrough
        default:
            updateSumPosition()
        }
    }
    
    private func plotArc(_ position: CGPoint) {
        let complexNumber = transformPosition(position)
        let endAngle = CGFloat(complexNumber.thetaRadians)
        let radius = CGFloat(complexNumber.modulus) * AxisNode.scaleOffset * 0.5
        
        let arcPath = UIBezierPath(arcCenter: centerOfAxes, radius: radius,
                                   startAngle: 0, endAngle: endAngle, clockwise: true)
        let arcDashedPath = arcPath.cgPath.copy(dashingWithPhase: 1.0, lengths: Constant.dashedPattern)
        let arcNode = SKShapeNode(path: arcDashedPath)
        arcNode.alpha = 0.75
        if let activeName = activePointName {
            arcNode.strokeColor = complexNumbersList.colorForPoint(activeName) ?? .white
        }
        arcNode.lineWidth = 2.0
        arcNode.name = NodeName.arcNode.rawValue
        
        // arc label
        let labelPosition = centerOfAxes + endAngle.offset(radius: radius)
        arcLabelNode.text = complexNumber.degreesDescription(GraphScene.angleOption)
        arcLabelNode.zPosition = 10.0
        arcLabelNode.position = labelPosition
        
        [arcNode, arcLabelNode].forEach(addChild(_:))
    }
    
    private func plotSum(_ complexNumber: ComplexNumber) {
        let startingPoint = transformComplexNumber(complexNumber)
        
        let pointNode = PointNode(radius: 8.0, position: startingPoint)
        pointNode.name = NodeName.sumNumber.rawValue
        pointNode.zPosition = 5.0
        pointNode.fillColor = .white
        pointNode.strokeColor = .darkGray
        
        let vectorPath = CGMutablePath()
        vectorPath.move(to: centerOfAxes)
        vectorPath.addLine(to: startingPoint)
        
        let vectorNode = SKShapeNode(path: vectorPath)
        vectorNode.name = NodeName.sumVectorNode.rawValue
        
        [pointNode, vectorNode].forEach(addChild(_:))
    }
    
    private func setupScene() {
        setupBackgroundView()
        setupAxes()
        setupCollectionView()
        setupSumComplexNumberView()
    }
    
    private func setupBackgroundView() {
        let backgroundView = UIView(frame: .zero)
        backgroundView.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight - frameWidth - 25.0)
        backgroundView.backgroundColor = backgroundColor.darker(by: 5.0)
        
        view?.addSubview(backgroundView)
    }
    
    private func setupAxes() {
        let xAxisNode = AxisNode(length: Constant.lengthOfAxis, center: centerOfAxes)
        xAxisNode.name = NodeName.xAxis.rawValue
        
        let yAxisNode = AxisNode(length: Constant.lengthOfAxis, center: centerOfAxes, orientation: .vertical)
        yAxisNode.name = NodeName.yAxis.rawValue
        
        [xAxisNode, yAxisNode].forEach(addChild(_:))
    }
    
    private func setupCollectionView() {
        view?.addSubview(topStackView)
        
        guard let view = view else { return }
        
        pointsCollectionView.register(PointCollectionViewCell.self, forCellWithReuseIdentifier: PointCollectionViewCell.reuseIdentifier)
        pointsCollectionView.register(AddPointCollectionViewCell.self, forCellWithReuseIdentifier: AddPointCollectionViewCell.reuseIdentifier)
        pointsCollectionView.dataSource = self
        pointsCollectionView.delegate = self
        
        let pointsCollectionViewConstraints = [
            pointsCollectionView.heightAnchor.constraint(equalToConstant: 90.0),
            pointsCollectionView.widthAnchor.constraint(equalToConstant: frameWidth)
        ]
        
        let topStackViewConstraints = [
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        
        NSLayoutConstraint.activate(pointsCollectionViewConstraints + topStackViewConstraints)
        
        topStackView.addArrangedSubview(pointsCollectionView)
    }
    
    private func setupSumComplexNumberView() {
        let bottomBackgroundView = UIView(frame: .zero)
        let sumLabelBackgroundView = UIView()
        [sumLabelBackgroundView].forEach { topStackView.addArrangedSubview($0) }
        sumLabelBackgroundView.addSubview(sumLabel)
        [bottomBackgroundView, sumLabelBackgroundView, sumLabel, sumVectorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        topStackView.addArrangedSubview(bottomBackgroundView)
        [sumVectorView, angleControlView].forEach { bottomBackgroundView.addSubview($0) }
        angleControlView.delegate = self
        
        guard let view = view else { return }
        
        [[sumLabelBackgroundView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
          sumLabelBackgroundView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
          sumLabelBackgroundView.heightAnchor.constraint(equalToConstant: 18.0)],
         [bottomBackgroundView.heightAnchor.constraint(equalToConstant: 80.0)],
         [sumVectorView.leadingAnchor.constraint(equalTo: angleControlView.trailingAnchor, constant: 10.0)],
         [sumLabel.leadingAnchor.constraint(equalTo: sumLabelBackgroundView.leadingAnchor, constant: 120.0),
          sumLabel.heightAnchor.constraint(equalToConstant: 16.0),
          sumLabel.trailingAnchor.constraint(equalTo: sumLabelBackgroundView.trailingAnchor)],
         [angleControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
          angleControlView.heightAnchor.constraint(equalTo: sumVectorView.heightAnchor)]]
            .forEach { NSLayoutConstraint.activate($0) }
        
        sumVectorView.isHidden = complexNumbersList.numberOfPoints < 2
        sumLabel.text = complexNumbersList.numberOfPoints < 2 ? " " : "Sum: "
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.glossaryButton.addTarget(self, action: #selector(onGlossaryButtonTap), for: .touchUpInside)
        bottomView.detailsSwitch.addTarget(self, action: #selector(onDetailsSwitchChange(sender:)), for: .valueChanged)
        topStackView.addArrangedSubview(bottomView)
    }
    
    @objc private func onReferenceButtonTap() {
        referenceView.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
        referenceView.delegate = self
        referenceView.alpha = 0.0
        view?.addSubview(referenceView)
        
        UIView.animate(withDuration: 0.3) {
            self.referenceView.alpha = 1.0
        }
    }
    
    @discardableResult
    private func plotComplexNumbersSumIfNeeded(_ plot: Bool = false) -> CGPoint {
        let complexNumbers = complexNumbersPositions.map { transformPosition($0) }
        let sum = complexNumbers.sum
        if plot {
            plotSum(sum)
        }
        
        sumVectorView.configure(with: complexNumbers, colors: complexNumbersList.list.map { $0.nodeColor })
        
        return transformComplexNumber(sum)
    }
    
    private func updatePosition(_ position: CGPoint, force: Bool = false) {
        guard let activeName = activePointName else { return }
        let index = complexNumbersList.indexForPoint(activeName)
        complexNumbersPositions[index] = position
        
        let section = complexNumbersList.reachedMaxNumberOfElements ? 0 : 1
        let indexPathToBeReloaded = IndexPath(item: index, section: section)
        
        throttle += 1
        if throttle % 8 == 0 || force {
            guard index <= complexNumbersList.numberOfPoints else { return }
            pointsCollectionView.reloadItems(at: [indexPathToBeReloaded])
        }
        
        updateSumPosition()
    }
    
    private func updateSumPosition() {
        let sumPosition = plotComplexNumbersSumIfNeeded()
        
        guard let sumNode = childNode(withName: NodeName.sumNumber.rawValue) else { return }
        
        let newPath = CGMutablePath()
        newPath.move(to: centerOfAxes)
        newPath.addLine(to: sumPosition)
        
        let vectorNode = childNode(withName: NodeName.sumVectorNode.rawValue)
        if let vectorNode = vectorNode as? SKShapeNode {
            vectorNode.path = newPath
        }
        
        sumVectorView.isHidden = complexNumbersList.numberOfPoints < 2
        sumLabel.text = complexNumbersList.numberOfPoints < 2 ? " " : "Sum: "
        
        let numberOfComplexNumbers = complexNumbersPositions.count
        switch numberOfComplexNumbers {
        case 2: // two nodes = sum vectors
            if childNode(withName: NodeName.firstSumVector.rawValue) == nil || childNode(withName: NodeName.secondSumVector.rawValue) == nil {
                for (index, complexNumberPosition) in complexNumbersPositions.enumerated() {
                    let sumVectorPath = CGMutablePath()
                    sumVectorPath.move(to: complexNumberPosition)
                    sumVectorPath.addLine(to: sumPosition)
                    let dashedPath = sumVectorPath.copy(dashingWithPhase: 10.0, lengths: Constant.dashedPattern)
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
                    
                    let dashedPath = sumVectorPath.copy(dashingWithPhase: 10.0, lengths: Constant.dashedPattern)
                    firstSumVector.alpha = 0.5
                    firstSumVector.path = dashedPath
                }
                
                let secondSumVector = childNode(withName: NodeName.secondSumVector.rawValue)
                if let secondSumVector = secondSumVector as? SKShapeNode {
                    let sumVectorPath = CGMutablePath()
                    let index = 1
                    sumVectorPath.move(to: complexNumbersPositions.elementExists(at: index) ? complexNumbersPositions[index] : .zero)
                    sumVectorPath.addLine(to: sumPosition)
                    
                    let dashedPath = sumVectorPath.copy(dashingWithPhase: 10.0, lengths: Constant.dashedPattern)
                    secondSumVector.alpha = 0.5
                    secondSumVector.path = dashedPath
                }
            }
        case 1:
            let sumVectorNode = childNode(withName: NodeName.sumVectorNode.rawValue)
            let sumVectorPoint = childNode(withName: NodeName.sumNumber.rawValue)
            
            [sumVectorNode, sumVectorPoint].forEach { $0?.removeFromParent() }
            fallthrough
        default:
            let firstSumVector = childNode(withName: NodeName.firstSumVector.rawValue)
            let secondSumVector = childNode(withName: NodeName.secondSumVector.rawValue)
            
            [firstSumVector, secondSumVector].forEach { $0?.removeFromParent() }
        }
        
        sumNode.position = sumPosition
    }
    
    private func transformPosition(_ position: CGPoint) -> ComplexNumber {
        let transformedPosition = position - centerOfAxes
        let divisor = AxisNode.scaleOffset
        let zPosition = CGPoint(x: transformedPosition.x / divisor, y: transformedPosition.y / divisor)
        
        let complexNumber = ComplexNumber(re: Double(zPosition.x).rounded(2), im: Double(zPosition.y).rounded(2))
        
        return complexNumber
    }
    
    private func transformComplexNumber(_ complexNumber: ComplexNumber) -> CGPoint {
        let multiplier = Double(AxisNode.scaleOffset)
        let multipliedPosition = CGPoint(x: (complexNumber.realPart ?? 0.0) * multiplier,
                                         y: (complexNumber.imaginaryPart ?? 0.0) * multiplier)
        let graphPosition = multipliedPosition + centerOfAxes
        
        return graphPosition
    }
    
    @objc private func onGlossaryButtonTap() {
        referenceView.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
        referenceView.delegate = self
        referenceView.alpha = 0.0
        view?.addSubview(referenceView)
        
        UIView.animate(withDuration: 0.3) {
            self.referenceView.alpha = 1.0
        }
    }
    
    @objc private func onDetailsSwitchChange(sender: UISwitch) {
        let nodes: [NodeName] = [.arcNode, .arcLabel, .firstSumVector, .secondSumVector, .positionLabel]
        nodes.map { $0.rawValue }
            .compactMap { childNode(withName: $0) }
            .forEach { $0.isHidden = !sender.isOn }
    }
}

// MARK: Touch handling

extension GraphScene {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = nodes(at: touch.location(in: self)).first,
                node.name?.contains(AttributedPoint.NodeNames.complexNumberNodeName.rawValue) ?? false,
                let nodeName = node.name {
                activePointName = nodeName
                pointTouch = touch
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointTouch = pointTouch else { return }
        
        for touch in touches where touch == pointTouch {
            let location = touch.location(in: self)
            guard let activePointName = activePointName,
                let movedNode = childNode(withName: activePointName) else { return }
            
            let newPath = CGMutablePath()
            newPath.move(to: centerOfAxes)
            newPath.addLine(to: location)
            
            // vector
            let vecctorNode = childNode(withName: complexNumbersList.vectorNameForPoint(activePointName) ?? "")
            if let vecctorNode = vecctorNode as? SKShapeNode {
                vecctorNode.path = newPath
            }
            
            [NodeName.arcNode,
             NodeName.arcLabel,
             NodeName.positionLabel]
                .map { $0.rawValue }
                .compactMap { childNode(withName: $0) }
                .forEach { $0.isHidden = !bottomView.detailsSwitch.isOn }
            
            updateLabels(with: movedNode.position)
            
            movedNode.position = location
            
            updatePosition(movedNode.position)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointTouch = pointTouch else { return }
        
        for touch in touches where touch == pointTouch {
            self.pointTouch = nil
            
            guard let movedNode = childNode(withName: activePointName ?? "") else { return }
            
            updateLabels(with: movedNode.position)
            updatePosition(movedNode.position, force: true)
        }
    }
    
    private func updateLabels(with position: CGPoint) {
        // arc
        let complexNumber = transformPosition(position)
        let endAngle = CGFloat(complexNumber.thetaRadians)
        let radius = CGFloat(complexNumber.modulus) * AxisNode.scaleOffset * 0.5
        
        let arcPath = UIBezierPath(arcCenter: centerOfAxes, radius: radius,
                                   startAngle: 0, endAngle: endAngle,
                                   clockwise: true)
        
        let arcNode = childNode(withName: NodeName.arcNode.rawValue)
        if let arcNode = arcNode as? SKShapeNode {
            let arcDashedPath = arcPath.cgPath.copy(dashingWithPhase: 1.0, lengths: Constant.dashedPattern)
            if let activeName = activePointName {
                arcNode.strokeColor = complexNumbersList.colorForPoint(activeName) ?? .white
            }
            arcNode.path = arcDashedPath
        }
        
        // arc label
        if let arcLabel = childNode(withName: NodeName.arcLabel.rawValue) as? SKLabelNode {
            let labelPosition = centerOfAxes + endAngle.offset(radius: radius)
            arcLabel.text = complexNumber.degreesDescription(GraphScene.angleOption)
            arcLabel.position = labelPosition
        }
        
        // position label
        if let positionLabel = childNode(withName: NodeName.positionLabel.rawValue) as? SKLabelNode {
            positionLabel.text = complexNumber.description
            let labelPosition = CGPoint(x: position.x + Constant.positionLabelOffset.x,
                                        y: position.y + Constant.positionLabelOffset.y)
            positionLabel.position = labelPosition
        }
    }
}

// MARK: UICollectionViewDataSource methods

extension GraphScene: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return complexNumbersList.reachedMaxNumberOfElements ? 1 : 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return complexNumbersList.reachedMaxNumberOfElements ? complexNumbersList.list.count : 1
        } else if section == 1 {
            return complexNumbersList.list.count
        }
        
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (indexPath.section != 0 ||
            complexNumbersList.reachedMaxNumberOfElements) else {
                let pointCellIdentifier = AddPointCollectionViewCell.reuseIdentifier
                let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: pointCellIdentifier, for: indexPath)
                
                guard let cell = dequeuedCell as? AddPointCollectionViewCell else {
                    fatalError("Could not dequeue a cell")
                }
                
                return cell
        }
        
        let pointCellIdentifier = PointCollectionViewCell.reuseIdentifier
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: pointCellIdentifier, for: indexPath)
        
        guard let cell = dequeuedCell as? PointCollectionViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        guard indexPath.item <= complexNumbersPositions.count - 1 else {
            fatalError("No complex number for \(indexPath.item)")
        }
        
        let position = complexNumbersPositions[indexPath.item]
        cell.tag = indexPath.item
        cell.delegate = self
        cell.setupCell(with: transformPosition(position), color: complexNumbersList.list[indexPath.item].nodeColor)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate methods

extension GraphScene: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.numberOfSections == 2,
            indexPath.section == 0,
            indexPath.item == 0 else {
                let position = complexNumbersPositions[indexPath.item]
                speechSynthesizer.speak(transformPosition(position))
                
                return
        }
        
        plot()
        
        if complexNumbersList.reachedMaxNumberOfElements {
            updateSumPosition()
            collectionView.reloadData()
            return
        }
        
        updateSumPosition()
        let newItemIndexPath = IndexPath(item: complexNumbersList.numberOfPoints - 1, section: 1)
        collectionView.insertItems(at: [newItemIndexPath])
    }
}

// MARK: PointCollectionViewCellDelegateMethods

extension GraphScene: PointCollectionViewCellDelegate {
    func didTapRemove(_ cell: PointCollectionViewCell, item: Int) {
        // TODO: fix
        complexNumbersList.remove(at: item).forEach { childNode(withName: $0)?.removeFromParent() }
        
        let nodes = [
            NodeName.arcNode,
            NodeName.arcLabel,
            NodeName.positionLabel
        ]
        
        if complexNumbersList.numberOfPoints == 0 {
            nodes.map { $0.rawValue }
                .compactMap { childNode(withName: $0) }
                .forEach { $0.removeFromParent() }
        }
        
        nodes.map { $0.rawValue }
            .compactMap { childNode(withName: $0) }
            .forEach { $0.isHidden = true }
        
        complexNumbersPositions.remove(at: item)
        updateSumPosition()
        pointsCollectionView.reloadData()
    }
}

extension GraphScene: AngleControlViewDelegate {
    func didSelect(option: AngleOption) {
        GraphScene.angleOption = option
        
        pointsCollectionView.reloadData()
        updateSumPosition()
        guard let activeName = activePointName,
            let node = childNode(withName: activeName) else { return }
        
        arcLabelNode.text = transformPosition(node.position)
            .degreesDescription(GraphScene.angleOption)
    }
}

extension GraphScene: ReferenceViewDelegate {
    func didClose() {
        UIView.animate(withDuration: 0.5, animations: {
            self.referenceView.alpha = 0.0
        }, completion: { _ in
            self.referenceView.removeFromSuperview()
        })
    }
}
