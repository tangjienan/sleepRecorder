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

    var checkSound : Recorder?
    
    
    var levelTimer = Timer()
    var button : UIButton?
    
    
    let threshold : Float = -10.0
    let timeInterval : Double = 0.5
    
    var mainView : MainView!
    
    @IBAction func press(_ sender: Any) {
        button = sender as? UIButton
        button?.setTitle("i am pressed", for: .normal)
        startRecording()
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
        
        checkSound = Recorder("save")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startRecording(){
        //recorder?.record()
        checkSound?.start()
        levelTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkAudioForInterval), userInfo: nil, repeats: true)
    }
    
    func stopRecording(){
        checkSound?.stop()
        levelTimer.invalidate()
        button?.setTitle("stop recording", for: .normal)
    }
    
    @objc func checkAudioForInterval(){
        debugPrint("checking audio now")
        let level = checkSound?.getLoundness()
        print("level is " + String(describing: level))
    }
}

