import Foundation

public struct ComplexNumber {
    public let realPart: Double?
    
    public let imaginaryPart: Double?
    
    public init(re realPart: Double?, im imaginaryPart: Double?) {
        self.realPart = realPart
        self.imaginaryPart = imaginaryPart
    }
    
    public var modulus: Double {
        let sumOfSquareRoots = pow(realPart ?? 0.0, 2) + pow(imaginaryPart ?? 0.0, 2)
        let squareRoot = sqrt(sumOfSquareRoots)
        return abs(squareRoot)
    }
    
    public var thetaDegrees: Double {
        // e.g. 2
        if let realPart = realPart,
            imaginaryPart == nil {
            return realPart >= 0 ? 0.0 : 180.0
        }
        
        // e.g. 4.2i
        if realPart == nil,
            let imaginaryPart = imaginaryPart {
            return imaginaryPart >= 0.0 ? 90.0 : 270.0
        }
        
        guard let imaginaryPart = imaginaryPart,
            let realPart = realPart else {
                return 0.0
        }
        
        let division = imaginaryPart/realPart
        let degrees = atan(abs(division)) * 180.0 / Double.pi
        
        if (realPart >= 0.0 && imaginaryPart >= 0.0) {
            return degrees
        } else if (realPart < 0.0 && imaginaryPart >= 0.0) {
            return 180.0 - degrees
        } else if (realPart <= 0.0 && imaginaryPart < 0.0) {
            return 180.0 + degrees
        } else {
            return 360.0 - degrees
        }
    }
}
