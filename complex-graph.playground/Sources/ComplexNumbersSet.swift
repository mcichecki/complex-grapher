import Foundation
import UIKit.UIColor

final class ComplexNumbersSet {
    public private(set)var sortedSet: [AttributedPoint] = []
    
    var numberOfPoints: Int {
        return complexNumbersSet.count
    }
    
    private lazy var nodesColors: [UIColor] = {
        let colors: [UIColor] = [.nodeYellow,
                                 .nodeRed,
                                 .nodeLightPurple,
                                 .nodeGreen].shuffled()
        
        return colors
    }()
    
    private var complexNumbersSet: Set<AttributedPoint> = []
    
    @discardableResult
    func add() -> AttributedPoint? {
        let index = complexNumbersSet.count
        let indexToBeRemoved = Int.random(in: 0..<nodesColors.count)
        guard indexToBeRemoved <= nodesColors.count - 1 else {
            return nil
        }
        
        let pickedColor = nodesColors.remove(at: indexToBeRemoved)
        let attributedPoint = AttributedPoint(index: index, nodeColor: pickedColor)
        complexNumbersSet.insert(attributedPoint)
        
        sortSet()
        return attributedPoint
    }
    
    func vectorNameForPoint(_ name: String) -> String? {
        return complexNumbersSet.first(where: { $0.complexNumberNodeName == name })?.vectorNumberNodeName
    }
    
    func colorForPoint(_ name: String) -> UIColor? {
        return complexNumbersSet.first(where: { $0.complexNumberNodeName == name})?.nodeColor
    }
    
    func attributedPoint(for index: Int) -> AttributedPoint? {
        return complexNumbersSet.first(where: { $0.complexNumberNodeName.contains("\(index)") })
    }
    
    private func sortSet() {
        guard complexNumbersSet.count > 1 else {
            if let firstComplexNumber = complexNumbersSet.first {
                sortedSet = [firstComplexNumber]
            }
            return
        }
        
        sortedSet = complexNumbersSet.sorted(by: { $0.index < $1.index })
    }
}
