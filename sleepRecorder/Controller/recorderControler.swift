//
//  ViewController.swift
//  sleepRecorder
//
//  Created by donezio on 2/12/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreAudio

class recorderControler: UIViewController {

    var recorder : AVAudioRecorder?
    var levelTimer = Timer()
    var button : UIButton?
    
    let threshold : Float = -10.0
    let timeInterval : Double = 0.5
    
    
    @IBAction func press(_ sender: Any) {
        button = sender as? UIButton
        button?.setTitle("i am pressed", for: .normal)
        startRecording()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // unique tmp file for storing
        let directory = NSTemporaryDirectory()
        let fileName = NSUUID().uuidString
        // This returns a URL? even though it is an NSURL class method
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:fullURL!, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startRecording(){
        recorder?.record()
        levelTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkAudioForInterval), userInfo: nil, repeats: true)
    }
    
    func stopRecording(){
        recorder?.stop()
        levelTimer.invalidate()
        button?.setTitle("stop recording", for: .normal)
    }
    
    @objc func checkAudioForInterval(){
        debugPrint("checking audio now")
        recorder?.updateMeters()
        let level = recorder?.averagePower(forChannel: 0)
        print("level is " + String(describing: level))
    }
}

