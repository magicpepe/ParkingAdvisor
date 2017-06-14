//
//  HistoryViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/17.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

//    @IBOutlet weak var TbV_mainTable: UITableView!
    
    var info = [
        ["ID":"1" , "HisV_Lat":"155" ,"HisV_Long":"133" , "HisV_Time":"120"] ,
        ["ID":"2" , "HisV_Lat":"23" ,"HisV_Long":"130" , "HisV_Time":"144"] ,
        ["ID":"3" , "HisV_Lat":"15" ,"HisV_Long":"131" , "HisV_Time":"1245"] ,
        ["ID":"4" , "HisV_Lat":"155" ,"HisV_Long":"134" , "HisV_Time":"121"]

    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "history"
        addSlideMenuButton()
        
//        TbV_mainTable.separatorStyle = .singleLine
//        TbV_mainTable.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
//        TbV_mainTable.allowsSelection = true
//        TbV_mainTable.allowsMultipleSelection = false
        for x in info{
            print(x)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    
//    // MARK: - TableViewDelegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return info.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 取得 tableView 目前使用的 cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")!
//        
//        // 顯示的內容
//
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        cell.layoutMargins = UIEdgeInsets.zero
//        cell.preservesSuperviewLayoutMargins = false
//        cell.backgroundColor = UIColor.clear
//        
//        let HisV_ID : UILabel = cell.contentView.viewWithTag(201) as! UILabel
//        let HisV_Lat : UILabel = cell.contentView.viewWithTag(202) as! UILabel
//        let HisV_Lon : UILabel = cell.contentView.viewWithTag(203) as! UILabel
//        let HisV_Time : UILabel = cell.contentView.viewWithTag(204) as! UILabel
//        
//        HisV_ID.text = info[indexPath.row]["ID"]!
//        HisV_Lat.text = info[indexPath.row]["HisV_Lat"]!
//        HisV_Lon.text = info[indexPath.row]["HisV_Lon"]!
//        HisV_Time.text = info[indexPath.row]["HisV_Time"]!
//
//        return cell
//
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1;
//    }

}
