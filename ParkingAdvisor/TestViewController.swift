//
//  TestViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/5/11.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit


class TestViewController: UIViewController ,closeDetailVCProtocol{

    var detailVCIsOn : Bool = false
    var DetailVC : DetailViewController! = nil
    
    func closeVC() {
        if(detailVCIsOn == true){
            let viewMenuBack : UIView = view.subviews.last!
    //        self.willMove(toParentViewController: nil)
            viewMenuBack.removeFromSuperview()
    //        self.removeFromParentViewController()
            detailVCIsOn = false
        }
        NSLog("closeVC")
    }

    
    @IBAction func close_detalVC(_ sender: AnyObject) {
//        DetailVC.didMove(toParentViewController: self)
        NSLog("hi button pressed")
        self.closeVC()
//        delegate?.closeVC()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let alert = UIAlertController(title: " ", message: "注意您的愛車！", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        NSLog("hello")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {
        
        // create the alert
//        let alert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n注意您的愛車！", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
//        self.present(alert, animated: true, completion: nil)
        detailVCIsOn = true
        let DetailVC : DetailViewController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DetailVC.delegate = self
        
        self.view.addSubview(DetailVC.view)
        self.addChildViewController(DetailVC)
        DetailVC.view.layoutIfNeeded()
        
        DetailVC.view.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-300)
        
//        self.didMove(toParentViewController: self)
    }
    
}
