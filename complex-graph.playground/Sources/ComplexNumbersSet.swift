import Foundation
import UIKit.UIColor

final class ComplexNumbersSet {
    public private(set)var sortedSet: [AttributedPoint] = []
    
    var numberOfPoints: Int {
        return sortedSet.count
    }
    
    var reachedMaxNumberOfElements: Bool {
        return UIColor.nodesColors.count == numberOfPoints
    }
    
    private var uniqueNumber = 0
    
    private lazy var nodesColors: [UIColor] = {
        let colors: [UIColor] = UIColor.nodesColors.shuffled()
        
        return colors
    }()
    
    //    private var complexNumbersSet: Set<AttributedPoint> = []
    
    @discardableResult
    func add() -> AttributedPoint? {
        guard !nodesColors.isEmpty else {
            return nil
        }
        
        //        let index = sortedSet.count
        let index = uniqueNumber
        uniqueNumber += 1
        let indexToBeRemoved = Int.random(in: 0..<nodesColors.count)
        guard indexToBeRemoved <= nodesColors.count - 1 else {
            return nil
        }
        let pickedColor = nodesColors.remove(at: indexToBeRemoved)
        let attributedPoint = AttributedPoint(index: index, nodeColor: pickedColor)
        //        sortedSet.insert(attributedPoint)
        sortedSet.append(attributedPoint)
        
        sortSet()
        return attributedPoint
    }
    
    func remove(at index: Int) -> [String] {
        print("index remove: \(index), \(sortedSet)")
        guard !sortedSet.isEmpty,
            index <= sortedSet.count - 1 else {
                return []
        }
        
        let element = sortedSet.remove(at: index)
        nodesColors.append(element.nodeColor)
        //        sortedSet.remove(element)
        //        sortedSet.remove(at: index)
        
        return [element.complexNumberNodeName, element.vectorNumberNodeName]
    }
    
    func vectorNameForPoint(_ name: String) -> String? {
        return sortedSet.first(where: { $0.complexNumberNodeName == name })?.vectorNumberNodeName
    }
    
    func colorForPoint(_ name: String) -> UIColor? {
        return sortedSet.first(where: { $0.complexNumberNodeName == name})?.nodeColor
    }
    
    func attributedPoint(for index: Int) -> AttributedPoint? {
        return sortedSet.first(where: { $0.complexNumberNodeName.contains("\(index)") })
    }
    
    func indexForPoint(_ name: String) -> Int {
        guard let attributedPoint = sortedSet.first(where: { $0.complexNumberNodeName == name }) else {
            return 0
        }
        
        return sortedSet.firstIndex(of: attributedPoint) ?? 0
    }
    
    private func sortSet() {
        guard sortedSet.count > 1 else {
            if let firstComplexNumber = sortedSet.first {
                sortedSet = [firstComplexNumber]
            }
            return
        }
        
        sortedSet = sortedSet.sorted(by: { $0.index < $1.index })
    }
    
    //    private func updateNames() {
    //        sortedSet
    //            .enumerated()
    //            .forEach { (offset, element) in
    //                <#code#>
    //        }
    //    }
}
