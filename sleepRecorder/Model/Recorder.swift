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
    
    init(){
        
    }
}
