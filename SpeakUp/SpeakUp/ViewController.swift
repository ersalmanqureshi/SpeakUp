//
//  ViewController.swift
//  SpeakUp
//
//  Created by Salman Qureshi on 2/9/18.
//  Copyright © 2018 Salman Qureshi. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var microPhoneButton: UIButton!
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBAction func tapButtonDidTap(_ sender: UIButton) {
        
        recordAndRecognizeSpeech()
//        var isButtonEnabled = false
//
//        SFSpeechRecognizer.requestAuthorization { (authorizationStatus) in
//            switch authorizationStatus {
//            case .authorized:
//                isButtonEnabled = true
//                self.recordAndRecognizeSpeech()
//            case .denied:
//                isButtonEnabled = false
//                print("Permission denied")
//            case .restricted:
//                isButtonEnabled = false
//                print("Permission restricted")
//            case .notDetermined:
//                isButtonEnabled = false
//                print("Permission not determined")
//            }
//        }
//
//        OperationQueue.main.addOperation {
//            self.microPhoneButton.isEnabled = isButtonEnabled
//        }
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
            print("Error")
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.textField.text = bestString
            } else if let error = error{
                print(error)
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordAndRecognizeSpeech()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

