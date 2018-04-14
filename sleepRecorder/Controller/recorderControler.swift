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

class recorderControler: UIViewController,AVAudioRecorderDelegate{

    
    var currentRecorder : Recorder?
    var checkSound : Recorder?
    var audioSession = AVAudioSession.sharedInstance()
    var listeningColor = UIColor.brown
    var waitingColor   = UIColor.green
    var recordingColor = UIColor.red
    var levelTimer = Timer()
    var player : AVAudioPlayer?
    let threshold : Float = -10.0
    let timeInterval : Double = 0.5
    var mainView : RecorderView!
    var onOffSwitch : UISwitch?
    let defaults = UserDefaults.standard
    var count = 0
    var dbValue : Int?
    
    // var to store
    var recording = 0 {
        didSet{
            if recording == 0{
                if listening == 1{
//                    mainView.status?.text = "listening..."
                    mainView.backgroundColor = listeningColor
                }
                else if listening == 0{
//                    mainView.status?.text = "waiting"
                    mainView.backgroundColor = waitingColor
                }
            }
            else if recording == 1{
//                mainView.status?.text = "recording"
                mainView.backgroundColor = recordingColor
            }
        }
    }
    
    var listening = 0 {
        didSet{
            if listening == 0{
                mainView.backgroundColor = waitingColor
                mainView.status?.text = "waiting"
            }
            else if listening == 1 {
                mainView.backgroundColor = listeningColor
                mainView.status?.text = "listening..."
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCountNumber()
    }
    
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
            print(mainView.frame)
            mainView.backgroundColor = UIColor.yellow
        }
        
        checkSound = Recorder("tmp",0)
        onOffSwitch = mainView.onOffSwitch
        mainView.onOffSwitch?.addTarget(self, action: #selector(reccordButtonPress), for: .touchUpInside)
        mainView.slideBarView?.dbSlideBar?.addTarget(self, action: #selector(getDisplaySlideBarValue), for: .valueChanged)
    }
    
    @objc func getDisplaySlideBarValue(){
        
        self.dbValue = Int((mainView.slideBarView?.dbSlideBar.value)!)
        mainView.dbText?.text = "\(self.dbValue!)db"
    }
    
   
    
    // button pressed handler
    @objc func reccordButtonPress(){
        
        if (onOffSwitch?.isOn)! {
            startListening()
        }
        else{
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
        listening = 1
        levelTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkAudioForInterval), userInfo: nil, repeats: true)
    }
    
    func stopListening(){
        print("listening is stopped")
        checkSound?.stop()
        levelTimer.invalidate()
        listening = 0
//        button?.setTitle("stop recording", for: .normal)
    }
    
    @objc func checkAudioForInterval(){
        let level = checkSound?.getLoundness()
        if level! > Float(-40.0){
//            button?.setTitle("listen", for: .normal)
            if recording == 0 {
                count = count + 1
                defaults.set(count, forKey: "count")
                debugPrint("start recording")
                startRecording()
                recording = 1
            }
        }
    }
    
    func startRecording(){
        let timestamp = NSDate().timeIntervalSince1970
        let saveRec = Recorder("save",timestamp)
        currentRecorder = saveRec
        recording = 1
        saveRec.start()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopRecording(_:)),userInfo: saveRec, repeats: false)
    }
    @objc func stopRecording(_ timer : Timer){
        //recorder?.s
//        button?.setTitle("nolisten", for: .normal)
        recording = 0
        let tmp = timer.userInfo as! Recorder
        tmp.stop()
        recording = 0
        //playBack()
    }
    
    // geting count number
    func getCountNumber(){
        
        // Receive
        if let count = defaults.string(forKey: "count")
        {
            print("this is the count \(count)")
        }
        else{
            defaults.set(0, forKey: "count")
            let tmp = defaults.string(forKey: "count")
            print("this is the count \(String(describing: tmp))")
        }
    }

}

