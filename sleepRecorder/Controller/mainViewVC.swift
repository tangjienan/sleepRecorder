//
//  mainViewVC.swift
//  sleepRecorder
//
//  Created by donezio on 2/23/18.
//  Copyright © 2018 macbook pro. All rights reserved.
//

//table view https://www.youtube.com/watch?v=VFtsSEYDNRU

//segmented view  https://www.richardhsu.me/posts/2015/01/26/segmented-control.html

//switch controller https://ahmedabdurrahman.com/2015/08/31/how-to-switch-view-controllers-using-segmented-control-swift/

import UIKit
import SnapKit

class mainViewVC: UIViewController {

    let items = ["recor","recording"]
    var customSC : UISegmentedControl?
    var contentView : UIView?
    
// Initialize the children viewController
    var currentViewController: UIViewController?
    
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC  = recorderControler()
        return firstChildTabVC
    }()
    
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = recordingListVC()
        return secondChildTabVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "SleepRecorder"
        //navigationController?.navigationBar.prefersLargeTitles = true
        let tmp = initSC()
        self.view.addSubview(tmp)
        view.backgroundColor = UIColor.white
        initContainerView()
        displayCurrentTab(0)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Initialize the Segmented Controller
    func initSC() -> UISegmentedControl{
        customSC = UISegmentedControl(items : items)
        customSC?.selectedSegmentIndex = 0
        let frame = UIScreen.main.bounds
        customSC?.frame = CGRect(x : frame.minX + 10, y : frame.minY + 50,
                                width : frame.width - 20, height : frame.height*0.1)
        print(customSC?.frame)
        customSC?.addTarget(self, action: #selector(mainViewVC.switchTab(_:)), for: .valueChanged)
        return customSC!
    }
    
    //select VC when tab press
    @objc func switchTab(_ sender: UISegmentedControl){
        if currentViewController != nil{
            self.currentViewController!.view.removeFromSuperview()
            self.currentViewController!.removeFromParentViewController()
        }
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    
    // Initialize the view for the child viewController
    func initContainerView(){
        let frame = UIScreen.main.bounds
        let view = UIView(frame: CGRect.zero)
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo((self.customSC?.snp.bottom)!).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.size.equalTo(CGSize(width:  frame.width - 20, height : frame.height * 0.8))
        }
        view.backgroundColor = UIColor.yellow
        self.contentView = view
    }
    // Display the child VC
    func displayCurrentTab(_ index : Int){
        switch index{
        case 0 :
                currentViewController = firstChildTabVC
        case 1 :
                currentViewController = secondChildTabVC
        default:
                currentViewController = firstChildTabVC
        }
        self.addChildViewController(currentViewController!)
        currentViewController?.didMove(toParentViewController: self)
        currentViewController?.view.frame = (self.contentView?.bounds)!
        self.contentView?.addSubview((currentViewController?.view)!)
    }
}
