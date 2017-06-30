//
//  MonitorViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/6/29.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import GoogleMaps

class MonitorViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

//    預設未監控狀態
    private var isStart : Bool = false
    var isMapInit : Bool = false
    var isDescribeViewShow : Bool = false
    var DescribeView : UITextView?
    // commentView
    var btn_smile : UIButton!
    var btn_sad : UIButton!
    var commentView : UIView!
    
    let locationManager = CLLocationManager()
    var mapView:GMSMapView!

    
    @IBOutlet weak var btn_start : UIButton!
    @IBOutlet weak var uiview_mapView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDescirbeView()
        initMap(location: CLLocationCoordinate2D.init(latitude: 24.178846, longitude: 120.645111))
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
    
    // MARK: - MAP
    
    func initMap(location:CLLocationCoordinate2D) {
        
        let locValue:CLLocationCoordinate2D = location
        print("initMaps Locations = \(locValue.latitude) \(locValue.longitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: 16)
        
        
        self.mapView = GMSMapView.map(withFrame: uiview_mapView.frame, camera: camera)
        mapView.delegate = self
//        mapView.settings.myLocationButton = true
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.snippet = "Hello World"
        //        marker.appearAnimation = GMSMarkerAnimationPop
        marker.map = mapView
        
        
        //        view.addSubview(mapView)
        
        uiview_mapView = mapView
        self.view.addSubview(uiview_mapView)
//        view = mapView
        //        view.bringSubview(toFront: btn_next)
        isMapInit = true
    }
    
    // MARK: - LocationManager

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        if !isMapInit{
//            initMap(location: locValue)
//        }
//    }


    // MARK: - Button
    
    @IBAction func btn_StopStart(_ sender: Any){
        //
        if isStart{
//            btn_start.setImage(UIImage(named:"START"), for: .normal)
            btn_start.setTitle("START",for: .normal)
            showComment()
            isStart = false
        }else{
//            btn_start.setImage(UIImage(named:"STOP"), for: .normal)
            btn_start.setTitle("STOP", for: .normal)
            uiview_mapView?.removeFromSuperview()
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
    
    func btn_Comment_sad(sender: UIButton!){
        NSLog("btn_Comment_sad press")
        commentView.removeFromSuperview()
        btn_smile = nil
        btn_sad = nil
        self.view.addSubview(uiview_mapView)

    }
    
    func btn_Comment_smile(sender: UIButton!){
        NSLog("btn_Comment_smile press")
        commentView.removeFromSuperview()
        btn_smile = nil
        btn_sad = nil
        self.view.addSubview(uiview_mapView)

    }
    
    // MARK: - Comment
    
    func showComment(){
        btn_smile = UIButton.init(frame: CGRect(x: 0, y: (uiview_mapView.bounds.width - UIScreen.main.bounds.size.width/2)/2 + uiview_mapView.frame.origin.y, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.width/2))
        btn_smile.setImage(UIImage(named: "smile"), for: .normal)
        btn_smile.addTarget(self, action: #selector(btn_Comment_smile(sender:)), for: .touchUpInside)
        
        btn_sad = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: (uiview_mapView.bounds.width - UIScreen.main.bounds.size.width/2)/2 + uiview_mapView.frame.origin.y, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.width/2))
        btn_sad.setImage(UIImage(named: "sad"), for: .normal)
        btn_sad.addTarget(self, action: #selector(btn_Comment_sad(sender:)), for: .touchUpInside)

        commentView = UIView.init(frame: self.view.bounds)
        commentView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        commentView.addSubview(btn_smile)
        commentView.addSubview(btn_sad)
        
        
        self.view.addSubview(commentView)
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
