import UIKit

extension UIColor {
    static let pointGray = UIColor.color(r: 126, g: 139, b: 158)
    
    static let darkBlue = UIColor.color(r: 25, g: 39, b: 62)
    
    static let mainBlue = UIColor.color(r: 69, g: 96, b: 139)
    
    static let lightBlue = UIColor.color(r: 129, g: 162, b: 215)
    
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let maxRGBValue: CGFloat = 255.0
        return UIColor(red: r/maxRGBValue, green: g/maxRGBValue, blue: b/maxRGBValue, alpha: alpha)
    }
}
