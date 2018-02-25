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
    var shouldSetupConstraints = true
    var recordButton : UIButton?
    var viewTitle    : UILabel?
    let screeSize  = UIScreen.main.bounds
    override init(frame: CGRect) {
        super.init(frame: frame)
        //button
        recordButton = UIButton(frame: CGRect.zero)
        recordButton?.setTitle("record", for: .normal)
        recordButton?.setTitleColor(UIColor.red, for: .normal)
        //title
        viewTitle = UILabel(frame : CGRect.zero)
        viewTitle?.text = "title"
        viewTitle?.textColor = UIColor.blue
        //add view
        self.addSubview(recordButton!)
        self.addSubview(viewTitle!)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            viewTitle?.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
            recordButton?.snp.makeConstraints  { (make) in
                make.size.equalTo( CGSize(width : 100, height : 100))
                make.center.equalTo(self)
            }
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
