/*:
 
 # Complex Numbers Grapher 🧮
 
 ###### Welcome to my 2019 WWDC Scholarship submission! 🖐
 
 ##### About playground
 
 This playground lets you discover and visualize a world of complex numbers.
 
 Complex numbers are represented by different colors and all details about numbers can be found in the top view.
 
 When you click on the number you will hear the audio description of the complex number. 🔈
 
 White vector ⚪️ represents sum of all numbers presented on the screen.
 
 ### Some theory 👨‍🏫
 
 A complex number is a number that can be written as **a + bi** where **i** is a solution of the equation  **x² - 1** *(there is no solution to this equation in the "real world")*.
 
 **a** is called real part and **b** is called imaginary part so given **z = 3 + 2i**, **Re(z) = 3** and **Im(z) = 2**.
 
 The complex numbers can be represented in a similar way as vectors using **complex plane** (also called Argand diagram) with **real axis (vertical)** and **imaginary axis (horizontal axis)**.
 
 The distance between the origin of the axes and point z is called modulus of z and is written as **|z| = √(a² + b²)**.
 
 The angle between the vector corresponding to z and the positive x axis is called **arg(z)** or **θ** (theta from the Greek alphabet). It can be computed using this equation: **θ = tan⁻¹(Im(z)/Re(z))**.
 
 ##### Glossary
 There is a small glossary available within the playground where you can see definitions of the most popular complex numbers symbols.
 */

import PlaygroundSupport
import SpriteKit
/*:
 You can set initial complex numbers programatically by adding them to the **_complexNumbers_** array or add them in the playground:
 */
let complexNumbers: [ComplexNumber] = [
    ComplexNumber(re: 5.0, im: 2.5),
    ComplexNumber(re: -3.0, im: 2.0)
]
/*:
 Scene setup:
 */
let graphScene = GraphScene()
complexNumbers
    .forEach { graphScene.plot(complexNumber: $0) }

let viewRect = CGRect(origin: .zero,
                      size: graphScene.sceneSize)
let view = SKView(frame: viewRect)

view.presentScene(graphScene)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
