//
//  slideBar.swift
//  sleepRecorder
//
//  Created by donezio on 4/12/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//


import UIKit
import SnapKit

@IBDesignable
class slideBar: UIView{
   
    @IBOutlet var slideBarContentView: UIView!
    
    @IBOutlet weak var dbSlideBar: UISlider!
    var shouldSetupConstraints = true
    override init(frame : CGRect){
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("slideBar", owner: self, options: nil)
        addSubview(slideBarContentView)
        //addSubview(dbSlideBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 394, height: 50)
    }
    
    override func updateConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        if(shouldSetupConstraints == true){
//        dbSlideBar.removeConstraints(dbSlideBar.constraints)
            slideBarContentView.snp.makeConstraints { (make) in
                make.left.equalTo(snp.left)
                make.top.equalTo(snp.top)
                make.right.equalTo(snp.right)
                make.bottom.equalTo(snp.bottom)
            }
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
