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
        AVFormatIDKey:              kAudioFormatAppleIMA4,
        AVSampleRateKey:            44100.0,
        AVNumberOfChannelsKey:      2,
        AVEncoderBitRateKey:        12800,
        AVLinearPCMBitDepthKey:     16,
        AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
    ]
    
    var fileURL : URL?
    
    init(_ kind : String){
        
        if kind == "save"{
            let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
            fileURL =  dir.appendingPathComponent("log.txt")
        }
        else{
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
            return
        }
        
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
    }
    
    func start(){
        recorder?.record()
    }
    
    func stop(){
        recorder?.stop()
    }
    
    func getLoundness() -> Float {
        recorder?.updateMeters()
        return (recorder?.averagePower(forChannel: 0))!
    }
}
