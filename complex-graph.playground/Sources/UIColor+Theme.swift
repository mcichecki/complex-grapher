import UIKit

// https://flatuicolors.com/palette/au
extension UIColor {
    static let pointGray = UIColor.rgb(126, 139, 158)
    
    static let darkBlue = UIColor.rgb(25, 39, 62)
    
    static let mainGray = UIColor.rgb(83, 92, 104)
    
    static let lightBlue = UIColor.rgb(129, 162, 215)
    
    static let nodeRed = UIColor.rgb(235, 77, 75)
    
    static let nodeYellow = UIColor.rgb(249, 202, 36)
    
    static let nodeGreen = UIColor.rgb(106, 176, 76)
    
    static let nodeLightPurple = UIColor.rgb(104, 109, 224)
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        let maxRGBValue: CGFloat = 255.0
        return UIColor(red: r/maxRGBValue, green: g/maxRGBValue, blue: b/maxRGBValue, alpha: alpha)
    }
}
