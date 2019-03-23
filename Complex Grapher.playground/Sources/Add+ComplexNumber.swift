import Foundation

public func +(left: ComplexNumber, right: ComplexNumber) -> ComplexNumber {
    let realSum = (left.realPart ?? 0.0) + (right.realPart ?? 0.0)
    let imaginarySum = (left.imaginaryPart ?? 0.0) + (right.imaginaryPart ?? 0.0)
    return ComplexNumber(re: realSum, im: imaginarySum)
}
