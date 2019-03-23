import Foundation

public struct ComplexNumber {
    public let realPart: Double?
    
    public let imaginaryPart: Double?
    
    public init(re realPart: Double = 0.0, im imaginaryPart: Double = 0.0) {
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

// MARK: Description

extension ComplexNumber: CustomStringConvertible {
    public var description: String {
        let numberOfDecimalPlaces = 2
        
        if let realPart = realPart,
            let imaginaryPart = imaginaryPart {
            let sign = imaginaryPart < 0 ? "-" : "+"
            return "\(realPart.rounded(numberOfDecimalPlaces)) \(sign) \(abs(imaginaryPart.rounded(numberOfDecimalPlaces)))i"
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
        return description + ", |z| = \(modulus.rounded(3)), θ = \(thetaDegrees.rounded(3))°"
    }
    
    public var descriptionWithRadiansPi: String {
        return description + ", |z| = \(modulus.rounded(3)), θ = \(thetaRadiansPi.rounded(3))π rad"
    }
    
    public var descriptionWithRadians: String {
        return description + ", |z| = \(modulus.rounded(3)), θ = \(thetaRadians.rounded(3)) rad"
    }
    
    public var modulusDescription: String {
        return "|z| = \(modulus.rounded(3))"
    }
    
    // TODO: is it really theta or fi?
    public var degreesDescription: String {
        return "θ = \(thetaDegrees.rounded(3))°"
    }
    
    public var radiansDescription: String {
        return "θ = \(thetaRadians.rounded(3)) rad"
    }
    
    public var piRadiansDescription: String {
        return "θ = \(thetaRadiansPi.rounded(3))π rad"
    }
    
    public var synthesizerDescription: String {
        var synthDescription = description
            .replacingOccurrences(of: ".", with: " point ")
            .replacingOccurrences(of: "-", with: " minus ")
            .replacingOccurrences(of: "+", with: " plus ")
        synthDescription.append("\n--modulus: \(String(modulus.rounded(3)).replacingOccurrences(of: ".", with: " point "))")
        synthDescription.append("\n--angle: ")
        var angleDescription = ""
        switch GraphScene.angleOption {
        case .degrees:
            angleDescription.append(String(thetaDegrees.rounded(3)).replacingOccurrences(of: ".", with: "point") + "degrees")
        case .pi:
            angleDescription.append(String(thetaRadiansPi.rounded(3)).replacingOccurrences(of: ".", with: "point") + "pi radians")
        case .radians:
            angleDescription.append(String(thetaRadians.rounded(3)).replacingOccurrences(of: ".", with: "point") + "radians")
            
        }
        synthDescription.append(angleDescription)
        return synthDescription
    }
    
    func degreesDescription(_ option: AngleOption) -> String {
        switch option {
        case .degrees: return degreesDescription
        case .pi: return piRadiansDescription
        case .radians: return radiansDescription
        }
    }
}
