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

let sceneSize = CGSize(width: 700.0, height: 950.0)
let viewRect = CGRect(origin: CGPoint(x: 0, y: 0), size: sceneSize)

let graphScene = GraphScene(size: sceneSize)

let complexNumbers = [
    ComplexNumber(re: 2.0, im: 1.0),
    //    ComplexNumber(re: -3.5, im: 4.5)
]

complexNumbers.forEach { graphScene.plot(complexNumber: $0) }

let view = SKView(frame: viewRect)
view.presentScene(graphScene)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
