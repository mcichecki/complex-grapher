import UIKit

extension UIColor {
    static let pointGray = UIColor.rgb(126, 139, 158)
    
    static let darkBlue = UIColor.rgb(25, 39, 62)
    
    static let mainGray = UIColor.rgb(83, 92, 104)
    
    static let lightBlue = UIColor.rgb(129, 162, 215)
    
    static let nodesColors: [UIColor] = [
        .rgb(235, 77, 75), // red
        .rgb(240, 195, 48), // yellow
        //        .rgb(246, 229, 141), // light yellow
        .rgb(106, 176, 76), // green
        .rgb(104, 109, 224), // lightPurple
        .rgb(240, 147, 43), // orange
        .rgb(126, 214, 223), // turqoise
        //        .rgb(19, 15, 64), // navy
        .rgb(52, 152, 219), // blue
        .rgb(190, 46, 221), // pink
    ]
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        let maxRGBValue: CGFloat = 255.0
        return UIColor(red: r/maxRGBValue, green: g/maxRGBValue, blue: b/maxRGBValue, alpha: alpha)
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) ) ?? self
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return UIColor(red: min(red + percentage / 100, 1.0),
                       green: min(green + percentage / 100, 1.0),
                       blue: min(blue + percentage / 100, 1.0),
                       alpha: alpha)
    }
}
