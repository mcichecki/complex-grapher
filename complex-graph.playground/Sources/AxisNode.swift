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
            for _ in 0...numberOfScales {
                let scalePath = CGMutablePath()
                let movePoint = tmpYOffset
                
                scalePath.move(to: CGPoint(x: movePoint, y: centerOfAxis.y + offsetSize))
                scalePath.addLine(to: CGPoint(x: movePoint, y: centerOfAxis.y - offsetSize))
                
                tmpYOffset += scaleOffset
                let scaleNode = SKShapeNode(path: scalePath)
                addChild(scaleNode)
            }
            
            tmpYOffset = centerOfAxis.x - scaleOffset
            // y axis from center to left
            for _ in 0...(numberOfScales - 1) {
                let scalePath = CGMutablePath()
                scalePath.move(to: CGPoint(x: tmpYOffset, y: centerOfAxis.y + offsetSize))
                scalePath.addLine(to: CGPoint(x: tmpYOffset, y: centerOfAxis.y - offsetSize))
                
                tmpYOffset -= scaleOffset
                let scaleNode = SKShapeNode(path: scalePath)
                addChild(scaleNode)
            }
            
            return
        }
        
        var tmpXOffset = centerOfAxis.y
        // x axis from center to top
        for _ in 0...numberOfScales {
            let scalePath = CGMutablePath()
            scalePath.move(to: CGPoint(x: centerOfAxis.x - offsetSize, y: tmpXOffset))
            scalePath.addLine(to: CGPoint(x: centerOfAxis.x + offsetSize, y: tmpXOffset))
            
            tmpXOffset += scaleOffset
            let scaleNode = SKShapeNode(path: scalePath)
            scaleNode.fillColor = .red
            addChild(scaleNode)
        }
        
        tmpXOffset = centerOfAxis.y - scaleOffset
        // x axis from center to bottom
        for _ in 0...(numberOfScales - 1) {
            let scalePath = CGMutablePath()
            scalePath.move(to: CGPoint(x: centerOfAxis.x - offsetSize, y: tmpXOffset))
            scalePath.addLine(to: CGPoint(x: centerOfAxis.x + offsetSize, y: tmpXOffset))
            
            tmpXOffset -= scaleOffset
            let scaleNode = SKShapeNode(path: scalePath)
            addChild(scaleNode)
        }
        
        return
    }
}
