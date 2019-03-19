import Foundation

extension Array {
    func elementExists(at index: Int) -> Bool {
        return index <= self.count - 1
    }
}

extension Array where Element == ComplexNumber {
    var sum: ComplexNumber {
        return reduce(ComplexNumber(), +)
    }
    
    var realParts: [Double] {
        return compactMap { $0.realPart }
    }
    
    var imaginaryParts: [Double] {
        return compactMap { $0.imaginaryPart }
    }
}
