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
    func getTimer() -> Int
}

class CommentViewController: UIViewController {
    
    var delegate: closeCommentVCProtocol?
    @IBOutlet weak var uiview_circle: UIView!
    @IBOutlet weak var lbl_timer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background_2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        let timer = self.delegate?.getTimer()
        self.lbl_timer?.text = String(format: "%.2d:%.2d", timer! / 60, timer! % 60)
        
        // 設定圓角
        uiview_circle.layer.cornerRadius = self.uiview_circle.frame.width / 2
        // 設定邊框
            // uiview shadow
        uiview_circle.layer.shadowColor = UIColor.lightGray.cgColor
        uiview_circle.layer.shadowOpacity = 0.8
        uiview_circle.layer.shadowOffset = CGSize.zero
        uiview_circle.layer.shadowRadius = 5
        
        
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
