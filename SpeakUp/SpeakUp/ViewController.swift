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
    
    var audioEngine: AVAudioEngine!
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBAction func tapButtonDidTap(_ sender: UIButton) {
        
        
        var isButtonEnabled = false
        
        SFSpeechRecognizer.requestAuthorization { (authorizationStatus) in
            switch authorizationStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("Permission denied")
            case .restricted:
                isButtonEnabled = false
                print("Permission restricted")
            case .notDetermined:
                isButtonEnabled = false
                print("Permission not determined")
            }
        }
        
        OperationQueue.main.addOperation {
            self.microPhoneButton.isEnabled = isButtonEnabled
        }
    }
    
    func recordAndRecognizeSpeech() {
      
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

