//
//  DetailViewController.swift
//  ParkingAdvisor
//
//  Created by WeiKang on 2017/6/26.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit

protocol closeDetailVCProtocol {
    func closeVC()
    func getLocation() -> String
    func getAddress() -> String
    func getScore() -> String
}

class DetailViewController: UIViewController {
    
    var delegate: closeDetailVCProtocol?
    
    @IBOutlet weak var lbl_detail_location: UILabel!
    @IBOutlet weak var lbl_detail_address: UILabel!
    @IBOutlet weak var lbl_detail_score: UILabel!
    
    
    @IBAction func close_detailVC(_ sender: AnyObject) {
//        closeVC()
        if(self.delegate != nil){
            delegate?.closeVC()
        }
    }
    
    @IBOutlet weak var btn_close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIGraphicsBeginImageContext(self.view.frame.size)
        // set Min & Max Zoom
        if (UIDevice.current.userInterfaceIdiom == .phone){
            UIImage(named: "map_msg_bg")?.draw(in: self.view.frame)
        }else if (UIDevice.current.userInterfaceIdiom == .pad){
            UIImage(named: "msg_bg_ipad")?.draw(in: self.view.frame)
        }
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        lbl_detail_location.text = self.delegate?.getLocation()
        lbl_detail_address.text = self.delegate?.getAddress()
        lbl_detail_score.text = self.delegate?.getScore()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
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
