import Foundation
import UIKit.UIColor

final class ComplexNumbersList {
    public private(set)var list: [AttributedPoint] = []
    
    var numberOfPoints: Int {
        return list.count
    }
    
    var reachedMaxNumberOfElements: Bool {
        return UIColor.nodesColors.count == numberOfPoints
    }
    
    private var uniqueNumber = 0
    
    private lazy var nodesColors: [UIColor] = {
        let colors: [UIColor] = UIColor.nodesColors.shuffled()
        
        return colors
    }()
    
    @discardableResult
    func add() -> AttributedPoint? {
        guard !nodesColors.isEmpty else {
            return nil
        }
        
        let index = uniqueNumber
        uniqueNumber += 1
        let indexToBeRemoved = Int.random(in: 0..<nodesColors.count)
        guard indexToBeRemoved <= nodesColors.count - 1 else {
            return nil
        }
        let pickedColor = nodesColors.remove(at: indexToBeRemoved)
        let attributedPoint = AttributedPoint(index: index, nodeColor: pickedColor)
        list.append(attributedPoint)
        
        sortSet()
        return attributedPoint
    }
    
    func remove(at index: Int) -> [String] {
        guard !list.isEmpty,
            index <= list.count - 1 else {
                return []
        }
        
        let element = list.remove(at: index)
        nodesColors.append(element.nodeColor)
        
        return [element.complexNumberNodeName, element.vectorNumberNodeName]
    }
    
    func vectorNameForPoint(_ name: String) -> String? {
        return list.first(where: { $0.complexNumberNodeName == name })?.vectorNumberNodeName
    }
    
    func colorForPoint(_ name: String) -> UIColor? {
        return list.first(where: { $0.complexNumberNodeName == name})?.nodeColor
    }
    
    func attributedPoint(for index: Int) -> AttributedPoint? {
        return list.first(where: { $0.complexNumberNodeName.contains("\(index)") })
    }
    
    func indexForPoint(_ name: String) -> Int {
        guard let attributedPoint = list.first(where: { $0.complexNumberNodeName == name }) else {
            return 0
        }
        
        return list.firstIndex(of: attributedPoint) ?? 0
    }
    
    private func sortSet() {
        guard list.count > 1 else {
            if let firstComplexNumber = list.first {
                list = [firstComplexNumber]
            }
            return
        }
        
        list = list.sorted(by: { $0.index < $1.index })
    }
}
