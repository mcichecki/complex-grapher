import Foundation
import SpriteKit

public final class AxisNode: SKShapeNode {
    public enum Orientation {
        case horizontal, vertical
    }
    
    static let scaleOffset: CGFloat = 50.0
    
    private let startPoint: CGPoint
    
    private let endPoint: CGPoint
    
    private let centerOfAxis: CGPoint
    
    private var isXAxis: Bool {
        return startPoint.y == endPoint.y
    }
    
    private enum LabelProperties {
        static let fontSize: CGFloat = 12.0
        static let fontName = "HelveticaNeue-CondensedBold"
        static let color = UIColor.white.adjust(by: 0.8)
    }
    
    public init(length: CGFloat, center: CGPoint, orientation: Orientation = .horizontal) {
        let halfLength = length * 0.5
        //        print("axe center: \(center)")
        let horizontal = orientation == .horizontal
        
        let startX = center.x - (horizontal ? halfLength : 0)
        let startY = center.y - (horizontal ? 0 : halfLength)
        self.startPoint = CGPoint(x: startX, y: startY)
        
        let endX = center.x + (horizontal ? halfLength : 0)
        let endY = center.y + (horizontal ? 0 : halfLength)
        self.endPoint = CGPoint(x: endX, y: endY)
        self.centerOfAxis = center
        
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
        strokeColor = .white //.green
    }
    
    private func drawArrow() {
        let arrowPath = CGMutablePath()
        arrowPath.move(to: endPoint)
        
        let xPoint = endPoint.x
        let yPoint = endPoint.y
        let offsetSize: CGFloat = 7.0
        let yAxisOffset = xPoint - (offsetSize * 2)
        let xAxisOffset = yPoint - (offsetSize * 2)
        let secondPoint = isXAxis ?
            CGPoint(x: yAxisOffset, y: yPoint + offsetSize) :
            CGPoint(x: xPoint - offsetSize, y: xAxisOffset)
        
        let thirdPoint = isXAxis ?
            CGPoint(x: yAxisOffset, y: yPoint - offsetSize) :
            CGPoint(x: xPoint + offsetSize, y: xAxisOffset)
        
        arrowPath.addLine(to: secondPoint)
        arrowPath.addLine(to: thirdPoint)
        arrowPath.closeSubpath()
        
        let arrowNode = SKShapeNode(path: arrowPath)
        arrowNode.fillColor = .white
        addChild(arrowNode)
        
        let axisLabelNode = SKLabelNode(text: isXAxis ? "Re" : "Im")
        axisLabelNode.fontName = LabelProperties.fontName
        axisLabelNode.fontSize  = LabelProperties.fontSize
        axisLabelNode.position = CGPoint(x: thirdPoint.x + (isXAxis ? 5.0 : 10.0), y: thirdPoint.y + (isXAxis ? 18.0 : 0.0))
        addChild(axisLabelNode)
    }
    
    private func drawScale() {
        let offsetSize: CGFloat = 5.0
        let scaleOffset = AxisNode.scaleOffset
        let length = isXAxis ?
            endPoint.x :
            endPoint.y
        let numberOfScales = Int(length / scaleOffset * 0.5) - 1
        
        if isXAxis {
            var tmpYOffset = centerOfAxis.x
            // y axis from center to right
            for i in 0...numberOfScales {
                let scalePath = CGMutablePath()
                let movePoint = tmpYOffset
                
                scalePath.move(to: CGPoint(x: movePoint, y: centerOfAxis.y + offsetSize))
                scalePath.addLine(to: CGPoint(x: movePoint, y: centerOfAxis.y - offsetSize))
                
                tmpYOffset += scaleOffset
                let scaleNode = SKShapeNode(path: scalePath)
                addChild(scaleNode)
                
                if i == 0 {
                    continue
                }
                
                // label
                let numberLabelNode = SKLabelNode(text: String(i))
                numberLabelNode.fontSize = LabelProperties.fontSize
                numberLabelNode.fontName = LabelProperties.fontName
                numberLabelNode.fontColor = LabelProperties.color
                numberLabelNode.position = CGPoint(x: movePoint, y: centerOfAxis.y + offsetSize - 25.0)
                addChild(numberLabelNode)
            }
            
            tmpYOffset = centerOfAxis.x - scaleOffset
            // y axis from center to left
            for i in 0...(numberOfScales - 1) {
                let scalePath = CGMutablePath()
                scalePath.move(to: CGPoint(x: tmpYOffset, y: centerOfAxis.y + offsetSize))
                scalePath.addLine(to: CGPoint(x: tmpYOffset, y: centerOfAxis.y - offsetSize))
                
                let scaleNode = SKShapeNode(path: scalePath)
                addChild(scaleNode)
                
                // label
                let numberLabelNode = SKLabelNode(text: String(-(1 + i)))
                numberLabelNode.fontSize = LabelProperties.fontSize
                numberLabelNode.fontName = LabelProperties.fontName
                numberLabelNode.fontColor = LabelProperties.color
                numberLabelNode.position = CGPoint(x: tmpYOffset - 2.5, y: centerOfAxis.y + offsetSize - 25.0)
                addChild(numberLabelNode)
                
                tmpYOffset -= scaleOffset
            }
            
            return
        }
        
        var tmpXOffset = centerOfAxis.y
        // x axis from center to top
        for i in 0...numberOfScales {
            let scalePath = CGMutablePath()
            scalePath.move(to: CGPoint(x: centerOfAxis.x - offsetSize, y: tmpXOffset))
            scalePath.addLine(to: CGPoint(x: centerOfAxis.x + offsetSize, y: tmpXOffset))
            
            let scaleNode = SKShapeNode(path: scalePath)
            scaleNode.fillColor = .red
            addChild(scaleNode)
            
            // label
            if i == 0 {
                tmpXOffset += scaleOffset
                continue
            }
            
            let numberLabelNode = SKLabelNode(text: String(i))
            numberLabelNode.fontSize = LabelProperties.fontSize
            numberLabelNode.fontName = LabelProperties.fontName
            numberLabelNode.fontColor = LabelProperties.color
            numberLabelNode.position = CGPoint(x: centerOfAxis.x + offsetSize + 7.5, y: tmpXOffset - 5.0)
            addChild(numberLabelNode)
            
            tmpXOffset += scaleOffset
        }
        
        tmpXOffset = centerOfAxis.y - scaleOffset
        // x axis from center to bottom
        for i in 0...(numberOfScales - 1) {
            let scalePath = CGMutablePath()
            scalePath.move(to: CGPoint(x: centerOfAxis.x - offsetSize, y: tmpXOffset))
            scalePath.addLine(to: CGPoint(x: centerOfAxis.x + offsetSize, y: tmpXOffset))
            
            let scaleNode = SKShapeNode(path: scalePath)
            addChild(scaleNode)
            
            // label
            let numberLabelNode = SKLabelNode(text: String(-(1+i)))
            numberLabelNode.fontSize = LabelProperties.fontSize
            numberLabelNode.fontName = LabelProperties.fontName
            numberLabelNode.fontColor = LabelProperties.color
            numberLabelNode.position = CGPoint(x: centerOfAxis.x + offsetSize + 7.5, y: tmpXOffset - 5.0)
            addChild(numberLabelNode)
            
            tmpXOffset -= scaleOffset
        }
        
        return
    }
}
