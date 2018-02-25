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

class recorderControler: UIViewController,AVAudioPlayerDelegate,AVAudioRecorderDelegate{

    
    var currentRecorder : Recorder?
    var checkSound : Recorder?
    var audioSession = AVAudioSession.sharedInstance()
    var recording = 0
    var levelTimer = Timer()
    var button : UIButton?
    var player : AVAudioPlayer?
    let threshold : Float = -10.0
    let timeInterval : Double = 0.5
    var mainView : RecorderView!
    var recordButton : UIButton?
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //playBack()
        // create main view in here
        let frame = UIScreen.main.bounds
        mainView = RecorderView()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width : frame.width - 20, height : frame.height*0.8))
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
        }
        mainView.backgroundColor = UIColor.yellow
        checkSound = Recorder("tmp",0)
        recordButton = mainView.recordButton
        mainView.recordButton?.addTarget(self, action: #selector(reccordButtonPress), for: .touchUpInside)
    }
    
    // button pressed handler
    @objc func reccordButtonPress(){
        if recordButton?.titleLabel?.text == "record"{
            recordButton?.setTitle("recording", for: .normal)
            startListening()
        }
        else{
            recordButton?.setTitle("record", for: .normal)
            if currentRecorder != nil{
                currentRecorder?.stop()
            }
            stopListening()
        }
    }
    
    func startListening(){
        //recorder?.record()
        print("start listening")
        checkSound?.start()
        levelTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkAudioForInterval), userInfo: nil, repeats: true)
    }
    
    func stopListening(){
        print("listening is stopped")
        checkSound?.stop()
        levelTimer.invalidate()
        button?.setTitle("stop recording", for: .normal)
    }
    
    @objc func checkAudioForInterval(){
        print("I am checking")
        let level = checkSound?.getLoundness()
        if level! > Float(-40.0){
            button?.setTitle("listen", for: .normal)
            if recording == 0 {
                count = count + 1
                debugPrint("start recording")
                startRecording()
                recording = 1
            }
        }
    }
    
    func startRecording(){
        let saveRec = Recorder("save",count)
        currentRecorder = saveRec
        saveRec.start()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopRecording(_:)),userInfo: saveRec, repeats: false)
    }
    @objc func stopRecording(_ timer : Timer){
        //recorder?.s
        button?.setTitle("nolisten", for: .normal)
        let tmp = timer.userInfo as! Recorder
        tmp.stop()
        recording = 0
        //playBack()
    }
    
    func playBack(){
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
        catch{
            print("errir \(error)")
            return
        }
        //
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let fileURL = docsDirect.appendingPathComponent("recording.m4a")
      
        do {
            let resources = try fileURL.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            print ("\(fileSize)")
        } catch {
            print("Error: \(error)")
        }
        do{
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            //player?.delegate = self
            player?.prepareToPlay()
            DispatchQueue.global().async {
                self.player?.play()
                print("Sound should be playing")
            }
        }
        catch{
            print("error play back")
            return
        }
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
        }
        catch{
            print("errir \(error)")
            return
        }
    }
}

