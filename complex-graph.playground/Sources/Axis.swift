import SpriteKit

public class Axis: SKShapeNode {
    private let startPoint: CGPoint
    
    private let endPoint: CGPoint
    
    private var isXAxis: Bool {
        return startPoint.x == endPoint.x
    }
    
    public init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        super.init()
        
        drawLine()
        drawArrow()
        drawScale()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawLine() {
        let linePath = CGMutablePath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        path = linePath
        strokeColor = .green
    }
    
    private func drawArrow() {
        let arrowPath = CGMutablePath()
        arrowPath.move(to: endPoint)
        
        let xPoint = endPoint.x
        let yPoint = endPoint.y
        let offset: CGFloat = 7.0
        let yAxisOffset = xPoint - (offset * 2)
        let xAxisOffset = yPoint - (offset * 2)
        let secondPoint = isXAxis ?
            CGPoint(x: xPoint - offset, y: xAxisOffset) :
            CGPoint(x: yAxisOffset, y: yPoint + offset)
        
        let thirdPoint = isXAxis ?
            CGPoint(x: xPoint + offset, y: xAxisOffset) :
            CGPoint(x: yAxisOffset, y: yPoint - offset)
        
        arrowPath.addLine(to: secondPoint)
        arrowPath.addLine(to: thirdPoint)
        arrowPath.closeSubpath()
        
        let arrowNode = SKShapeNode(path: arrowPath)
        arrowNode.fillColor = .white
        addChild(arrowNode)
    }
    
    private func drawScale() {
        //        print("start: \(startPoint)")
        //        print("end: \(endPoint)")
        let centerPoint = CGPoint(x: isXAxis ? startPoint.x : startPoint.y,
                                  y: isXAxis ? endPoint.x : endPoint.y)
        
        //        print("center point: \(centerPoint)")
        
        let offset: CGFloat = 5.0
        let scaleOffset: CGFloat = 50.0
        let length = isXAxis ?
            endPoint.y :
            endPoint.x
        let numberOfScales = Int(length / scaleOffset * 0.5) - 1
        
        if isXAxis {
            var tmpXOffset = centerPoint.y
            // x axis from center to top
            for _ in 0...numberOfScales {
                let scalePath = CGMutablePath()
                scalePath.move(to: CGPoint(x: centerPoint.x - offset, y: tmpXOffset))
                scalePath.addLine(to: CGPoint(x: centerPoint.x + offset, y: tmpXOffset))
                
                tmpXOffset += scaleOffset
                let scaleNode = SKShapeNode(path: scalePath)
                addChild(scaleNode)
            }
            
            tmpXOffset = centerPoint.y - scaleOffset
            // x axis from center to bottom
            for _ in 0...(numberOfScales - 1) {
                let scalePath = CGMutablePath()
                scalePath.move(to: CGPoint(x: centerPoint.x - offset, y: tmpXOffset))
                scalePath.addLine(to: CGPoint(x: centerPoint.x + offset, y: tmpXOffset))
                
                tmpXOffset -= scaleOffset
                let scaleNode = SKShapeNode(path: scalePath)
                addChild(scaleNode)
            }
            
            return
        }
        
        var tmpYOffset = centerPoint.x
        // y axis from center to right
        for _ in 0...numberOfScales {
            let scalePath = CGMutablePath()
            scalePath.move(to: CGPoint(x: tmpYOffset, y: centerPoint.y + offset))
            scalePath.addLine(to: CGPoint(x: tmpYOffset, y: centerPoint.y - offset))
            
            tmpYOffset += scaleOffset
            let scaleNode = SKShapeNode(path: scalePath)
            addChild(scaleNode)
        }
        
        tmpYOffset = centerPoint.x - scaleOffset
        // y axis from center to left
        for _ in 0...(numberOfScales - 1) {
            let scalePath = CGMutablePath()
            scalePath.move(to: CGPoint(x: tmpYOffset, y: centerPoint.y + offset))
            scalePath.addLine(to: CGPoint(x: tmpYOffset, y: centerPoint.y - offset))
            
            tmpYOffset -= scaleOffset
            let scaleNode = SKShapeNode(path: scalePath)
            addChild(scaleNode)
        }
    }
}
