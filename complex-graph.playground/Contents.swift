/*:
 
 # Complex Numbers Grapher 🧮
 
 ###### Welcome to my 2019 WWDC Scholarship submission! 🖐
 
 ##### About playground
 
 This playground lets you discover world of complex numbers and visualize addition??? of these numbers.
 
 Complex numbers are represented by different colors and all details about numbers can be found in the top view.
 
 When you click on the number you will hear the audio description of the complex number. 🔈
 
 White vector ⚪️ represents sum of all numbers presented on the screen.
 
 ### Some theory 👨‍🏫
 
 A complex number is a number that can be written as **a + bi** where **i** is a solution of the equation  **x² - 1** *(there is no solution to this equation in the "real world")*.
 
 **a** is called real part and **b** is called imaginary part so given **z = 3 + 2i**, **Re(z) = 3** and **Im(z) = 2**.
 
 The complex numbers can be represented in a similar way as vectors using **complex plane** (also called Argand diagram) with **real axis (vertical)** and **imaginary axis (horizontal axis)**.
 
 The distance between the origin of the axes and point z is called modulus of z and is written as **|z| = √(a² + b²)**.
 
 The angle between the vector corresponding to z and the positive x axis is called **arg(z)** or **θ** (theta from the Greek alphabet). It can be computed using this equation: **θ = tan⁻¹(Im(z)/Re(z))**.
 
 ##### Reference
 * **i** - imaginary number, solution of the equation **x² - 1**, **i² = -1**, **i = √-1**
 
 * z -
 */

import PlaygroundSupport
import SpriteKit

/* LINKS
 https://www.hackmath.net/en/calculator/complex-number
 http://www.dchopkins.com/Kaul-cmplx-var.pdf
 */

var title = "Complex Grapher\n"
print(title)

// max width: 768.0, max height: 1024.0
let sceneSize = CGSize(width: 700.0, height: 1000.0)
let viewRect = CGRect(origin: CGPoint(x: 0, y: 0), size: sceneSize)

let graphScene = GraphScene(size: sceneSize)

let complexNumbers = [
    ComplexNumber(re: 2.0, im: 1.0),
    //    ComplexNumber(re: -3.5, im: 4.5)
]

complexNumbers.forEach { graphScene.plot(complexNumber: $0) }

// with arc
//let complexNumber = ComplexNumber(re: 2.0, im: 2.0)
//graphScene.plot(complexNumber: complexNumber, withArc: true)

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
