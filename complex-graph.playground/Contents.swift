import UIKit
import PlaygroundSupport
import SpriteKit

var title = "Complex Grapher\n"
print(title)

let num1 = ComplexNumber(re: -2.0, im: -2.0)
let modulus = num1.modulus
let theta = num1.thetaDegrees

print(modulus)
print(theta)

// scene properties
let sceneSize = CGSize(width: 700.0, height: 500.0)
let viewRect = CGRect(origin: CGPoint(x: 0, y: 0), size: sceneSize)

// scene initialization
let graphScene = GraphScene(size: sceneSize)

// scene view
let view = SKView(frame: viewRect)
view.presentScene(graphScene)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
