import UIKit
import PlaygroundSupport
import SpriteKit

/* LINKS
 https://www.hackmath.net/en/calculator/complex-number
 http://www.dchopkins.com/Kaul-cmplx-var.pdf
 */

var title = "Complex Grapher"
print(title)

let sceneSize = CGSize(width: 700.0, height: 700.0)
let viewRect = CGRect(origin: CGPoint(x: 0, y: 0), size: sceneSize)
let graphScene = GraphScene(size: sceneSize)

let view = SKView(frame: viewRect)
view.presentScene(graphScene)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true










// TESTS:
//let numbers: [ComplexNumber] = [
//    ComplexNumber(re: 5, im: 2), // |z| = 5.38516, θ = 21.801°/0.121π
//    ComplexNumber(re: 2.1, im: nil), // |z| = 2.1, θ = 0.0°/0π
//    ComplexNumber(re: -3.4, im: nil), // |z| = 2.1, θ = 0.0°/0π
//    ComplexNumber(re: nil, im: 4.2), // |z| = 4.2i, θ = 90.0°/0.5π
//    ComplexNumber(re: nil, im: -5.6), // |z| = -5.6i, θ = 270.0°/1.5π
//    ComplexNumber(re: -3.5, im: 4), // II |z| = 5.31507, θ = 131,185°/0.728π
//    ComplexNumber(re: -6.0, im: -3), // III |z| = 6.708, θ = 206,57°/1.148π rad
//    ComplexNumber(re: 4, im: -5) // IV |z| = 6,403, θ = 308.66°/1.715π rad
//]
//
//numbers.forEach {
//    print($0.descriptionWithDegrees)
//    print($0.descriptionWithRadiansPi)
//    print("\n")
//}
//
//let number1 = ComplexNumber(re: 2.0, im: 3.0)
//let number2 = ComplexNumber(re: nil, im: 1.5)
//print(number1 + number2)
