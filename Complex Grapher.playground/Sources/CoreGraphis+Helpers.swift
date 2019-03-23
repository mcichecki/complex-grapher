import CoreGraphics

extension CGFloat {
    var size: CGSize {
        return CGSize(width: self, height: self)
    }
}

extension CGFloat {
    func offset(radius: CGFloat) -> CGPoint {
        let cosAlpha = cos(self)
        let sinAlpha = sin(self)
        let xPoint = cosAlpha * radius
        let yPoint = sinAlpha * radius
        
        return CGPoint(x: xPoint, y: yPoint)
    }
}

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: right.x + left.x, y: right.y + left.y)
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
