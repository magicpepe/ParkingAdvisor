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
        let uiview_center = CGPoint(x: Int(view.frame.width / 2), y: Int(uiview_radius + 50))
        uiview_mapView.frame = CGRect(x:0, y:0, width: uiview_radius * 2, height: uiview_radius * 2)
        uiview_mapView.center = uiview_center
        uiview_mapView.layer.cornerRadius = uiview_radius
        
        // uiview shadow
        uiview_mapView.layer.shadowColor = UIColor.black.cgColor
        uiview_mapView.layer.shadowOpacity = 0.8
        uiview_mapView.layer.shadowOffset = CGSize.zero
        uiview_mapView.layer.shadowRadius = 10
        
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
    }
    
    @IBAction func btn_press_billing(_ sender: Any){
        NSLog("btn_press_billing")
        
    }
    
    
}
