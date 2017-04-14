//
//  ViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/10.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: BaseViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var btn_next: UIButton!

    let locationManager = CLLocationManager()
    
    override func loadView() {

        super.loadView()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
//        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")

//        if CLLocationManager.authorizationStatus() == .notDetermined{
//            locationManager.requestAlwaysAuthorization()
//        }
//            // 2. 用戶不同意
//        else if CLLocationManager.authorizationStatus() == .denied {
//            let alert = UIAlertController(title: "Alert", message: "未提供GPS資訊", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "瞭解", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//        }
//            // 3. 用戶已經同意
//        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
//            locationManager.startUpdatingLocation()
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MyMap"
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")

        
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude,
                                              longitude: locValue.longitude,
                                              zoom: 14)
//        let mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:90 , width:view.frame.width,height : view.frame.height/2), camera: camera)
        let mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:0 , width:view.frame.width,height : view.frame.height), camera: camera)
        mapView.settings.myLocationButton = true
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView

//        view = mapView
//        ui_mapView.view=mapView
        view.addSubview(mapView)
        view.bringSubview(toFront: btn_next)
        // Do any additional setup after loading the view, typically from a nib.
        
        addSlideMenuButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button

    @IBAction func btn_goNext(_ sender: UIButton) {
        performSegue(withIdentifier:"goDashBoard" , sender:nil)
    }

//    func btn_goDashboard(){
//        self.navigationController?.pushViewController(
//            dashboardViewController(), animated: true)
//
//    }
    
    
    }

