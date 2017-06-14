//
//  TestViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/5/11.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

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
        let alert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n注意您的愛車！", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
