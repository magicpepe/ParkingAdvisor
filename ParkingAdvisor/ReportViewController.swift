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
    
    // label
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - MAP
    
    func initMap() {
        
        // uiview init
        let uiview_radius : CGFloat = view.frame.width / 2 - 50
        let uiview_center = CGPoint(x: Int(view.frame.width / 2), y: Int(uiview_radius + 200))
        uiview_mapView.frame = CGRect(x:0, y:0, width: uiview_radius * 2, height: uiview_radius * 2)
        uiview_mapView.center = uiview_center
        uiview_mapView.layer.cornerRadius = uiview_radius
        
        // uiview shadow
//        uiview_mapView.layer.shadowColor = UIColor.black.cgColor
//        uiview_mapView.layer.shadowOpacity = 0.8
//        uiview_mapView.layer.shadowOffset = CGSize.zero
//        uiview_mapView.layer.shadowRadius = 10
        
//        let locValue:CLLocationCoordinate2D = PASingleton.sharedInstance().getLocation()
//        print("initMaps Locations = \(locValue.latitude) \(locValue.longitude)")
//
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
        mapView.layer.cornerRadius = uiview_radius
        uiview_mapView = mapView
        
        self.view.addSubview(uiview_mapView)
        //        view = mapView
        //        view.bringSubview(toFront: btn_next)
        isMapInit = true
    }
    
    // MARK - Label
    
    func initLabel(){
        lbl_location.text = "\(locationManager.location!.coordinate.latitude) ,\(locationManager.location!.coordinate.longitude)"
        
        lbl_address.alpha = 0
    }
    
    // MARK - Button
    @IBAction func btn_press_towing(_ sender: Any){
        NSLog("btn_press_towing")
        reported()
    }
    
    @IBAction func btn_press_billing(_ sender: Any){
        NSLog("btn_press_billing")
        reported()
    }
    
    func reported(){
        
        // blur effect
        let blurEffect : UIBlurEffect!
        var blurEffectView : UIVisualEffectView!
        
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = uiview_mapView.bounds
        blurEffectView.center = uiview_mapView.center
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = view.frame.width / 2 - 50
        blurEffectView.clipsToBounds = true
        view.addSubview(blurEffectView)
        
        // label report
        var lbl_report = UILabel()
        lbl_report.textColor = UIColor(rgba: 0x4A4A4AFF)
        lbl_report.text = "感謝回報"
        lbl_report.font = UIFont(name: "HelveticaNeue", size: 60)
        lbl_report.frame = CGRect(x: 0 / 2, y: 310 , width: 200, height: 180.0)
        lbl_report.sizeToFit()
        lbl_report.textAlignment = .center
        lbl_report.frame.origin.x = (view.frame.width - lbl_report.frame.width ) / 2
        lbl_report.alpha = 0
        view.addSubview(lbl_report)
        
        UIView.animate(withDuration: 1, delay: 0.3, options: .curveEaseIn, animations: {
            blurEffectView.alpha = 0.7
            lbl_report.alpha = 1
        })
            
    }
}
