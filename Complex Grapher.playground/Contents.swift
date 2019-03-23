/*:
 
 # Complex Numbers Grapher 🧮
 
 ###### Welcome to my *2019 WWDC Scholarship* submission! 🖐
 
 ##### About playground
 
 This playground lets you discover and visualize a world of **_complex numbers_**.
 
 Complex numbers are represented by different colors and all details about numbers can be found in the top view.
 
 When you click on the number you will hear the audio description of the complex number. 🔈
 
 White vector ⚪️ represents sum of all numbers presented on the screen.
 
 ### Some theory 👨‍🏫
 
 A complex number is a number that can be written as **_a + bi_** where **_i_** is a solution of the equation  **_x² - 1_** *(there is no solution to this equation in the "real world")*.
 
 **a** is called real part and **_b_** is called imaginary part so given **_z = 3 + 2i_**, **_Re(z) = 3_** and **_Im(z) = 2_**.
 
 Complex numbers can be represented in a similar way as vectors using **_complex plane_** (also called **_Argand diagram_**) with **_real axis (vertical)_** and **_imaginary axis (horizontal axis)_**.
 
 Distance between the origin of the axes and point z is called **_modulus of z_** (**_|z|_**) and angle between the vector coreesponding to the z and the positive x axis is called **_argument of z_** (**_arg(z)_** or **_θ_**)
 
 ##### Glossary
 There is a small glossary available within the playground where you can see definitions of the most popular complex numbers symbols. Click on the definition to hear it. 🔈
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
