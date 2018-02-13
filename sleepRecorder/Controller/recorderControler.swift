//
//  ViewController.swift
//  sleepRecorder
//
//  Created by donezio on 2/12/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import UIKit
import AVFoundation

class recorderController: UIViewController {

    @IBAction func press(_ sender: Any) {
        let button = sender as! UIButton
        button.setTitle("i am pressed", for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startRecording(){
        
    }
}

