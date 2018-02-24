//
//  mainViewVC.swift
//  sleepRecorder
//
//  Created by donezio on 2/23/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import UIKit

class mainViewVC: UIViewController {

    let items = ["recor","recording"]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tmp = initSC()
        self.view.addSubview(tmp)
        view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Initialize the Segmented Controller
    func initSC() -> UISegmentedControl{
        let customSC = UISegmentedControl(items : items)
        customSC.selectedSegmentIndex = 0
        let frame = UIScreen.main.bounds
        customSC.frame = CGRect(x : frame.minX + 10, y : frame.minY + 50,
                                width : frame.width - 20, height : frame.height*0.1)
        return customSC
    }
    
    // Initialize the view for the child viewController
}
