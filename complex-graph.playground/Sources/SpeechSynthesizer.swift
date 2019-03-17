import Foundation
import AVFoundation

final class SpeechSynthesizer: NSObject {
    private let synthesizer = AVSpeechSynthesizer()
    
    private var isSpeaking = false
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }
    
    func speak(_ complexNumber: ComplexNumber) {
        guard !isSpeaking else { return }
        
        let complexNumberDescription = complexNumber.synthesizerDescription
        print("complexNumber: \(complexNumberDescription)")
        let speechUtterance = AVSpeechUtterance(string: complexNumberDescription.lowercased())
        speechUtterance.rate = 0.65
        speechUtterance.pitchMultiplier = 1.0
        synthesizer.speak(speechUtterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart")
        isSpeaking.toggle()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
        isSpeaking.toggle()
    }
}
