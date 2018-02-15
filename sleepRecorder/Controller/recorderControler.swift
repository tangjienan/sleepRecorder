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

class recorderControler: UIViewController,AVAudioPlayerDelegate{

    var checkSound : Recorder?
    var player : AVAudioPlayer?
    var recording = 0
    
    var levelTimer = Timer()
    var button : UIButton?
    
    
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
        
        let level = checkSound?.getLoundness()
        if level! > Float(-50.0){
            debugPrint("start recording")
            if recording == 0{
                startRecording()
                recording = 1
            }
        }
    }
    
    func startRecording(){
        let saveRec = Recorder("save")
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(stopRecording(_:)),userInfo: saveRec, repeats: false)
        
    }
    
    @objc func stopRecording(_ timer : Timer){
        //recorder?.s
        let tmp = timer.userInfo as! Recorder
        tmp.stop()
        print("it is stop")
        playBack()
    }
    
    func playBack(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let fileURL = docsDirect.appendingPathComponent("recording.m4a")
        print("hey hey hey")
        
        do {
            let resources = try fileURL.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            print ("\(fileSize)")
        } catch {
            print("Error: \(error)")
        }
        
        do{
            let sound = try AVAudioPlayer(contentsOf: fileURL)
            self.player = sound
            sound.delegate = self
            sound.prepareToPlay()
            sound.play()
        }
        catch{
            print("error play back")
            return
        }
       
    }
}

