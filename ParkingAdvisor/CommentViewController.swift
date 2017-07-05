//
//  CommentViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/7/5.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit

protocol closeCommentVCProtocol {
    func closeComment()
}

class CommentViewController: UIViewController {
    
    var delegate: closeCommentVCProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_sad(_ sender: Any) {
        NSLog("btn_Comment_sad press")
        if(self.delegate != nil){
            delegate?.closeComment()
        }
        
    }
    
    @IBAction func btn_smile(_ sender: Any) {
        NSLog("btn_Comment_smile press")
        if(self.delegate != nil){
            delegate?.closeComment()
        }
        
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
