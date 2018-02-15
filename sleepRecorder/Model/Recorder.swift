//
//  Recorder.swift
//  sleepRecorder
//
//  Created by donezio on 2/14/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import Foundation
import AVFoundation
import CoreAudio

class Recorder {
    
    var recorder : AVAudioRecorder?
    
    var timer    = Timer()
    
    let recordSettings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey:12000,
        AVNumberOfChannelsKey:1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    var fileURL : URL?
    
    init(_ kind : String){
        
        if kind == "save"{
           
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            fileURL = docsDirect.appendingPathComponent("recording.m4a")
        }
        else{
            print("hey")
            let directory = NSTemporaryDirectory()
            let fileName = NSUUID().uuidString
            
            fileURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        }
        
        // set up
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:fileURL!, settings: recordSettings)
            
        } catch {
            print("errir \(error)")
            return
        }
        
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
    }
    
    func start(){
        print("start2")
        recorder?.record()
        print("start3")
    }
    
    func stop(){
        recorder?.stop()
    }
    
    func getLoundness() -> Float {
        recorder?.updateMeters()
        return (recorder?.averagePower(forChannel: 0))!
    }
}
