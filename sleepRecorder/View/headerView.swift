//
//  headerView.swift
//  sleepRecorder
//
//  Created by donezio on 4/15/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class headerView: UIView{

    
    var shouldSetupConstraints = true
    var clearButton : UIButton?
    
    override init(frame : CGRect){
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        clearButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        clearButton?.setTitle("Clear All", for: .normal)
        clearButton?.backgroundColor = .purple
        self.addSubview((clearButton)!)
        self.clearButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.width.equalTo(100)
            make.height.equalTo(50)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 394, height: 50)
    }
    
    override func updateConstraints() {
        print("hey i am called")
        self.clearButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.width.equalTo(100)
            make.height.equalTo(50)
        })
        super.updateConstraints()
    }
}
