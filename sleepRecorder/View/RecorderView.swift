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
    var status       : UILabel?
    let screeSize  = UIScreen.main.bounds
    override init(frame: CGRect) {
        super.init(frame: frame)
        //button
        recordButton = UIButton(frame: CGRect.zero)
        recordButton?.setTitle("start", for: .normal)
        recordButton?.setTitleColor(UIColor.black, for: .normal)
        //title
        viewTitle = UILabel(frame : CGRect.zero)
        viewTitle?.text = "status:  "
        viewTitle?.textColor = UIColor.blue
        //status
        status = UILabel(frame : CGRect.zero)
        status?.text = "waiting...."
        status?.textColor = UIColor.blue
        //add view
        self.addSubview(recordButton!)
        self.addSubview(viewTitle!)
        self.addSubview(status!)
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
                make.size.equalTo(CGSize(width: 55, height: 100))
            }
            status?.snp.makeConstraints { (make) in
                make.left.equalTo((viewTitle?.snp.right)!)
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
