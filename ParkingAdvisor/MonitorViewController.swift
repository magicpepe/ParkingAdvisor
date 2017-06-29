//
//  MonitorViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/6/29.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit

class MonitorViewController: UIViewController {

//    預設未監控狀態
    private var isStart : Bool = false
    var isDescribeViewShow : Bool = false
    var DescribeView : UITextView?
    @IBOutlet weak var btn_start : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDescirbeView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initDescirbeView(){
        DescribeView = UITextView(frame:CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/3, width: 150, height: 200))
        DescribeView?.backgroundColor = UIColor.gray
        DescribeView?.textColor = UIColor.blue
        DescribeView?.text = "使用愛車即時監控，當警察來臨檢並且有熱心民眾回報的時候，系統將會推播訊息給你唷！"
        DescribeView?.layer.cornerRadius = 20
        DescribeView?.isSelectable = false
        
    }
    
    
    // MARK: - Button
    
    @IBAction func btn_StopStart(_ sender: Any){
        if isStart{
//            btn_start.setImage(UIImage(named:"START"), for: .normal)
            btn_start.setTitle("START",for: .normal)
            isStart = false
        }else{
//            btn_start.setImage(UIImage(named:"STOP"), for: .normal)
            btn_start.setTitle("STOP", for: .normal)
            isStart = true
            
        }

    }
    
    @IBAction func btn_ShowDescribe(_ sender: Any) {
        if(!isDescribeViewShow){
            self.view.addSubview(DescribeView!)
            isDescribeViewShow = true
        }else{
            DescribeView?.removeFromSuperview()
            isDescribeViewShow = false

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
