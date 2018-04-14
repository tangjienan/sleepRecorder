//
//  MainView.swift
//  sleepRecorder
//
//  Created by donezio on 2/12/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import UIKit
import SnapKit
/**
    view for recording sound
*/

class RecorderView: UIView {
    var fontName = "Apple SD Gothic Neo"
    
    var dbText : UILabel?
    var shouldSetupConstraints = true
    var viewTitle    : UILabel?
    var status       : UILabel?
    let screeSize  = UIScreen.main.bounds
    var slideBarView    : slideBar?
    var onOffSwitch  : UISwitch?
    var bottomView : UIView?
    var mindBValue = Float(50)
    var maxdBValue = Float(100)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSubview()
        //add view
        addAllSubview()
        
    }
    
    func addAllSubview(){
        self.addSubview(dbText!)
        self.addSubview(bottomView!)
        self.addSubview(onOffSwitch!)
        self.addSubview(slideBarView!)
        self.addSubview(status!)
        self.bringSubview(toFront: slideBarView!)
    }
    
    func initialSubview(){
        //db text
        dbText = UILabel()
        dbText?.font = UIFont(name: fontName, size: 16)
        dbText?.font = UIFont.boldSystemFont(ofSize: 56)
        dbText?.text = "89db"
        //bottomView
        bottomView = UIView()
        bottomView?.layer.borderWidth = 2
        bottomView?.layer.borderColor = UIColor.black.cgColor
        bottomView?.backgroundColor = .blue
        //switch
        onOffSwitch = UISwitch()
        onOffSwitch?.onTintColor = .red
        onOffSwitch?.thumbTintColor = .purple
        // slideView
        slideBarView = slideBar()
        slideBarView?.layer.borderWidth = 2
        slideBarView?.layer.borderColor = UIColor.black.cgColor
        slideBarView?.dbSlideBar.minimumValue = mindBValue
        slideBarView?.dbSlideBar.maximumValue = maxdBValue
        //staus
        status = UILabel()
        status?.font = UIFont(name: fontName, size: 16)
        status?.font = UIFont.boldSystemFont(ofSize: 56)
        status?.text = "Stop"
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func updateConstraints() {
        let frame = UIScreen.main.bounds
        slideBarView?.dbSlideBar?.translatesAutoresizingMaskIntoConstraints = false;
        if(shouldSetupConstraints) {
    
            status?.snp.makeConstraints({ (make) in
                //make.bottom.equalTo((self.bottomView?.snp.bottom)!).offset(-50)
                make.center.equalTo(bottomView!)
            })
        
            slideBarView?.snp.makeConstraints({ (make) in
                make.top.equalTo((dbText?.snp.bottom)!).offset(10)
                make.left.equalTo(self.snp.left)
            })
            
            onOffSwitch?.snp.makeConstraints({ (make) in
                make.right.equalTo(self.snp.right)
                make.top.equalTo((slideBarView?.snp.bottom)!).offset(30)
            })
            bottomView?.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo((slideBarView?.snp.bottom)!).offset(30)
                make.bottom.equalTo(self.snp.bottom)
            })
            dbText?.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(self.snp.top).offset(50)
            })
            
            shouldSetupConstraints = false
        }
        print(slideBarView?.frame)
        super.updateConstraints()
    }
}
