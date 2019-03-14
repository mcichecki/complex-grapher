import Foundation

extension Double {
    func rounded(_ numberOfDecimalPlaces: Int) -> Double {
        let power = Double(truncating: pow(10.0, numberOfDecimalPlaces) as NSNumber)
        return (self * power).rounded() / power
    }
    
    var radiansPi: Double {
        return self / 180.0
    }
}
