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

    var checkSound : Recorder?
    var audioSession = AVAudioSession.sharedInstance()
    var recording = 0
    
    var levelTimer = Timer()
    var button : UIButton?
    var player : AVAudioPlayer?
    
    let threshold : Float = -10.0
    let timeInterval : Double = 0.5
    
    var mainView : MainView!
    
    @IBAction func press(_ sender: Any) {
        button = sender as? UIButton
        button?.setTitle("i am pressed", for: .normal)
        startListening()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(String(describing: mainView.bounds.size.width) + "and" + String(describing : mainView.bounds.size.height))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //playBack()
        // create main view in here
        mainView = MainView()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width : 200, height : 200))
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            
        }
        mainView.backgroundColor = UIColor.yellow
        checkSound = Recorder("tmp")
        mainView.recordButton?.addTarget(self, action: #selector(stopListening), for: .touchUpInside)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func startListening(){
        //recorder?.record()
        print("listening")
        checkSound?.start()
        levelTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkAudioForInterval), userInfo: nil, repeats: true)
    }
    @objc func stopListening(){
        checkSound?.stop()
        levelTimer.invalidate()
        button?.setTitle("stop recording", for: .normal)
    }
    @objc func checkAudioForInterval(){
        print("I am checking")
        let level = checkSound?.getLoundness()
        if level! > Float(-30.0){
            button?.setTitle("listen", for: .normal)
            if recording == 0{
                debugPrint("start recording")
                startRecording()
                recording = 1  }
        }
    }
    
    func startRecording(){
        let saveRec = Recorder("save")
        saveRec.start()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopRecording(_:)),userInfo: saveRec, repeats: false)
        
    }
    
    @objc func stopRecording(_ timer : Timer){
        //recorder?.s
        button?.setTitle("nolisten", for: .normal)
        let tmp = timer.userInfo as! Recorder
        tmp.stop()
        recording = 0
        playBack()
    }
    
    func playBack(){
        let audioSession = AVAudioSession.sharedInstance()
        do{
            //try audioSession.setActive(false)
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

