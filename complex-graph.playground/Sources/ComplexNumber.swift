import Foundation

public struct ComplexNumber {
    public let realPart: Double?
    
    public let imaginaryPart: Double?
    
    public init(_ realPart: Double?, _ imaginaryPart: Double?) {
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
    
    public var thetaRadiansPi: Double {
        return thetaDegrees.radiansPi
    }
    
    public var thetaRadians: Double {
        return thetaRadiansPi * Double.pi
    }
}

extension ComplexNumber: CustomStringConvertible {
    public var description: String {
        let numberOfDecimalPlaces = 2
        
        if let realPart = realPart,
            let imaginaryPart = imaginaryPart {
            return "\(realPart.rounded(numberOfDecimalPlaces)) + \(imaginaryPart.rounded(numberOfDecimalPlaces))i"
        }
        
        if let realPart = realPart, imaginaryPart == nil {
            return "\(realPart.rounded(numberOfDecimalPlaces))"
        }
        
        if let imaginaryPart = imaginaryPart, realPart == nil {
            return "\(imaginaryPart.rounded(numberOfDecimalPlaces))i"
        }
        
        return ""
    }
    
    public var descriptionWithDegrees: String {
        return description + ", |z| = \(modulus), φ = \(thetaDegrees.rounded(3))°"
    }
    
    public var descriptionWithRadiansPi: String {
        return description + ", |z| = \(modulus), φ = \(thetaRadiansPi.rounded(3))π rad"
    }
    
    public var descriptionWithRadians: String {
        return description + ", |z| = \(modulus), φ = \(thetaRadians.rounded(3)) rad"
    }
}
