import Foundation
import AVFoundation

final class SpeechSynthesizer: NSObject {
    private let synthesizer = AVSpeechSynthesizer()
    
    private var isSpeaking = false
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }
    
    func speak(text: String) {
        guard !isSpeaking else { return }
        
        let speechUtterance = AVSpeechUtterance(string: text.lowercased())
        speechUtterance.rate = 0.55
        speechUtterance.pitchMultiplier = 1.0
        synthesizer.speak(speechUtterance)
    }
    
    func speak(_ complexNumber: ComplexNumber, isSum: Bool = false) {
        guard !isSpeaking else { return }
        
        let complexNumberDescription = (isSum ? "sum of complex numbers: " : "") +  complexNumber.synthesizerDescription
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
        isSpeaking.toggle()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking.toggle()
    }
}
