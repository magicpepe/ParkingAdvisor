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
