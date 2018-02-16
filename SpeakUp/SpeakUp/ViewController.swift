//
//  ViewController.swift
//  SpeakUp
//
//  Created by Salman Qureshi on 2/9/18.
//  Copyright © 2018 Salman Qureshi. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var microPhoneButton: UIButton!
    
    let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var isRecording = false
    
    @IBAction func tapButtonDidTap(_ sender: UIButton) {
    
        if isRecording == true {
            audioEngine.stop()
            recognitionTask?.cancel()
            isRecording = false
            microPhoneButton.backgroundColor = UIColor.gray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            microPhoneButton.backgroundColor = UIColor.red
        }
    }
    
    func cancelRecording() {
        audioEngine.stop()
        let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
    
    func recordAndRecognizeSpeech() {
         let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
             self.showAlert(message: "There has been an audio engine error.")
            print("Error")
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.showAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        
        if !myRecognizer.isAvailable {
            self.showAlert(message: "Speech recognition is not currently available.")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.textField.text = bestString
            } else if let error = error{
                self.showAlert(message: "There has been a speech recognition error.")
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestSpeechAuthorization()
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.microPhoneButton.isEnabled = true
                case .denied:
                    self.microPhoneButton.isEnabled = false
                   // self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.microPhoneButton.isEnabled = false
                   // self.detectedTextLabel.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.microPhoneButton.isEnabled = false
                   // self.detectedTextLabel.text = "Speech recognition not yet authorized"
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

