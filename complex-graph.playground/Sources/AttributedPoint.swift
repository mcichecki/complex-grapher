import Foundation
import UIKit

struct AttributedPoint {
    enum NodeNames: String {
        case complexNumberNodeName
        
        case vectorNumberNodeName
    }
    
    let index: Int
    
    let complexNumberNodeName: String
    
    let vectorNumberNodeName: String
    
    let nodeColor: UIColor
}

extension AttributedPoint {
    init(index: Int, nodeColor: UIColor) {
        self.index = index
        self.complexNumberNodeName = NodeNames.complexNumberNodeName.rawValue + "_\(index)"
        self.vectorNumberNodeName = NodeNames.vectorNumberNodeName.rawValue + "_\(index)"
        self.nodeColor = nodeColor
    }
}

extension AttributedPoint: Hashable { }
