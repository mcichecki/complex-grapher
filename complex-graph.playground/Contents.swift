import UIKit
import PlaygroundSupport
import SpriteKit

var title = "Complex Grapher\n"
print(title)

let num1 = ComplexNumber(-2.0, -2.0)
let modulus = num1.modulus
let theta = num1.thetaDegrees

print(modulus)
print(theta)

// scene properties
let sceneSize = CGSize(width: 700.0, height: 700.0)
let viewRect = CGRect(origin: CGPoint(x: 0, y: 0), size: sceneSize)

// scene initialization
let graphScene = GraphScene(size: sceneSize)

// scene view
let view = SKView(frame: viewRect)
view.presentScene(graphScene)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

/*
 // TESTS:
 let numbers: [ComplexNumber] = [
 ComplexNumber(5, 2), // |z| = 5.38516, θ = 21.801°/0.121π
 ComplexNumber(2.1, nil), // |z| = 2.1, θ = 0.0°/0π
 ComplexNumber(-3.4, nil), // |z| = 2.1, θ = 0.0°/0π
 ComplexNumber(nil, 4.2), // |z| = 4.2i, θ = 90.0°/0.5π
 ComplexNumber(nil, -5.6), // |z| = -5.6i, θ = 270.0°/1.5π
 ComplexNumber(-3.5, 4), // II |z| = 5.31507, θ = 131,185°/0.728π
 ComplexNumber(-6.0, -3), // III |z| = 6.708, θ = 206,57°/1.148π rad
 ComplexNumber(4, -5) // IV |z| = 6,403, θ = 308.66°/1.715π rad
 ]
 
 numbers.forEach {
 print($0.descriptionWithDegrees)
 print($0.descriptionWithRadiansPi)
 print("\n")
 }
 
 let number1 = ComplexNumber(2.0, 3.0)
 let number2 = ComplexNumber(nil, 1.5)
 print(number1 + number2)
 */
