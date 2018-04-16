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
    
    var fontName = "Apple SD Gothic Neo"
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
    var statusLabel : UILabel?
    var saveRec : Recorder?
    
    
    
    // var to store
    var recording = 0 {
        didSet{
            if recording == 0{
                if listening == 1{
                    if self.statusLabel != nil{
                        self.statusLabel?.text = "Listening..."
                    }
                    mainView.backgroundColor = listeningColor
                }
                else if listening == 0{
                    self.statusLabel?.text = "Stop"
                    mainView.backgroundColor = waitingColor
                }
            }
            else if recording == 1{
                self.statusLabel?.text = "Recording..."
                mainView.backgroundColor = recordingColor
            }
        }
    }
    
    var listening = 0 {
        didSet{
            if listening == 0{
                mainView.backgroundColor = waitingColor
                //                mainView.status?.text = "waiting"
            }
            else if listening == 1 {
                mainView.backgroundColor = listeningColor
                //                mainView.status?.text = "listening..."
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
        self.statusLabel = mainView.status
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
            statusLabel?.text = "Listening..."
        }
        else{
            if currentRecorder != nil{
                currentRecorder?.stop()
            }
            statusLabel?.text = "Stop"
            stopListening()
        }
    }
    
    func startListening(){
        //recorder?.record()
        print("start listening")
        checkSound?.start()
        listening = 1
        let userInfo = ["id" : "1"]
        levelTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkAudioForInterval(_ : )), userInfo: userInfo, repeats: true)
    }
    
    func stopListening(){
        print("listening is stopped")
        checkSound?.stop()
        levelTimer.invalidate()
        listening = 0
        saveRec = nil
    }
    
    @objc func checkAudioForInterval(_ timer : Timer){
        let tmp = timer.userInfo as! [String : String]
        if tmp["id"] == "1" && recording == 1{
            return
        }
        let level = checkSound?.getLoundness()
        //debugPrint("checking sound level \(String(describing: level))")
        if level! > Float(-20.0){
            if recording == 0 {
                count = count + 1
                defaults.set(count, forKey: "count")
                if(recording != 1){
                    debugPrint("start recording \(String(describing: level))")
                    startRecording()
                    recording = 1
                }
            }
        }
        else{
            if(recording == 1){
                recording = 0;
                //stopRecording
                print("stop the recording \(String(describing: level))")
                saveRec?.stop()
            }
        }
    }
    
    func startRecording(){
        let timestamp = NSDate().timeIntervalSince1970
        saveRec = Recorder("save",timestamp)
        currentRecorder = saveRec
        recording = 1
        saveRec?.start()
        let userInfo = ["id" : "2"]
        //TODO : stopRecording when the loundness is less than threshold
        Timer.scheduledTimer(timeInterval: timeInterval * 5, target: self, selector: #selector(checkAudioForInterval(_:)),userInfo : userInfo, repeats: true)
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

