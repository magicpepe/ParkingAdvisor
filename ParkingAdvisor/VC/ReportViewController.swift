//
//  ReportViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/6/29.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import GoogleMaps

class ReportViewController: UIViewController ,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // map view
    var isMapInit : Bool = false
    var mapView : GMSMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var uiview_mapView: UIView!
    
    // report button
    @IBOutlet weak var btn_towing : UIButton!
    @IBOutlet weak var btn_billing : UIButton!
    var blurEffectView : UIVisualEffectView!
    
    // label
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_thanks: UILabel!
    
    // 參數
    var isReported : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 取得定位要求
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Alert", message: "未提供GPS資訊", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "瞭解", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
        // set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background_2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initMap()
        initLabel()
        isReported = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        mapView = nil
        blurEffectView = nil
    }
    // MARK: - MAP
    
    func initMap() {
        
        
        uiview_mapView.layer.cornerRadius = uiview_mapView.frame.width / 2
        
        // uiview shadow
//        uiview_mapView.layer.shadowColor = UIColor.black.cgColor
//        uiview_mapView.layer.shadowOpacity = 0.8
//        uiview_mapView.layer.shadowOffset = CGSize.zero
//        uiview_mapView.layer.shadowRadius = 10
        
//        let locValue:CLLocationCoordinate2D = PASingleton.sharedInstance().getLocation()
//        print("initMaps Locations = \(locValue.latitude) \(locValue.longitude)")
//
        let camera = GMSCameraPosition.camera(withLatitude: PASingleton.sharedInstance().getLocation().latitude,
                                              longitude: PASingleton.sharedInstance().getLocation().longitude,
                                              zoom: 16)
        
        let m_frame = CGRect.init(origin: CGPoint.zero, size: uiview_mapView.frame.size)
        self.mapView = GMSMapView.map(withFrame: m_frame, camera: camera)
        
        mapView.delegate = self
        //        mapView.settings.myLocationButton = true
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.snippet = "Hello World"
        //        marker.appearAnimation = GMSMarkerAnimationPop
        marker.map = mapView
        
        mapView.layer.cornerRadius = uiview_mapView.frame.width / 2
//        uiview_mapView = mapView
        
        uiview_mapView.insertSubview(mapView, belowSubview: lbl_thanks)
        isMapInit = true
    }
    
    // MARK - Label
    
    func initLabel(){
        lbl_location.text = String(format: "%6f, %6f", PASingleton.sharedInstance().getLocation().latitude, PASingleton.sharedInstance().getLocation().longitude)
        
        lbl_address.text = "福星路100號"
        lbl_thanks.alpha = 0
    }
    
    // MARK - Button
    @IBAction func btn_press_towing(_ sender: Any){
        NSLog("btn_press_towing")
        if (isReported == false){
            reported()
            btn_towing.isHighlighted = true
            isReported = true
        }
    }
    
    @IBAction func btn_press_billing(_ sender: Any){
        NSLog("btn_press_billing")
        if (isReported == false){
            reported()
            btn_billing.isHighlighted = true
            isReported = true
        }
    }
    
    func reported(){
        
        // blur effect
        let blurEffect : UIBlurEffect!
        
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame.size = uiview_mapView.frame.size
        blurEffectView.frame.origin = CGPoint.zero
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = uiview_mapView.frame.width / 2
        blurEffectView.clipsToBounds = true
        uiview_mapView.insertSubview(blurEffectView, belowSubview: lbl_thanks)
        
        UIView.animate(withDuration: 1, delay: 0.3, options: .curveEaseIn, animations: {
            self.blurEffectView.alpha = 0.7
            self.lbl_thanks.alpha = 1
        })
    }
}
