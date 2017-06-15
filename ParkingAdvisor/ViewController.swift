//
//  ViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/10.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class ViewController: BaseViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var btn_next: UIButton!

    let locationManager = CLLocationManager()
    var isMapInit : Bool = false
    override func loadView() {

        super.loadView()
        
        
//        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "暫停一下"
        
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
        // Do any additional setup after loading the view, typically from a nib.
        
        addSlideMenuButton()
        getPointFromAPI(location: locationManager.location!.coordinate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button

    @IBAction func btn_goNext(_ sender: UIButton) {
        performSegue(withIdentifier:"goDashBoard" , sender:nil)
    }

    func initMap(location:CLLocationCoordinate2D) {
        
        let locValue:CLLocationCoordinate2D = location
        print("initMaps Locations = \(locValue.latitude) \(locValue.longitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: 18)
        
        
        //        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude,
        //                                              longitude: locValue.longitude,
        //                                              zoom: 14)
        
        //        let mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:90 , width:view.frame.width,height : view.frame.height/2), camera: camera)
        let mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:0 , width:view.frame.width,height : view.frame.height), camera: camera)
        mapView.settings.myLocationButton = true
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.snippet = "Hello World"
        //        marker.appearAnimation = GMSMarkerAnimationPop
        marker.map = mapView
        
        //        view = mapView
        //        ui_mapView.view=mapView
        view.addSubview(mapView)
        view.bringSubview(toFront: btn_next)
        isMapInit = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if !isMapInit{
            initMap(location: locValue)
        }
    }
    
    
    
    
    // MARK: - MAP POINT
    
    func getPointFromAPI(location:CLLocationCoordinate2D){
//        let json = JSON(jsonObject)
        let data : String = "[" +
            "{" +
            "\"green\": {" +
                "\"number\": 3," +
                "\"location\": [" +
                "\"123.123,24.123\"," +
                "\"122.122,21.111\"," +
                "\"123.111,79.1234\"" +
                "]" +
            "}," +
            "\"yellow\": {" +
                "\"number\": 1," +
                "\"location\": [" +
                "\"123.111,79.1234\"" +
                "]" +
            "}," +
            "\"red\": {" +
                "\"number\": 4," +
                "\"location\": [" +
                "\"123.123,24.123\"," +
                "\"122.122,21.111\"," +
                "\"123.111,79.1234\"," +
                "\"122.122,21.111\"" +
                "]" +
            "}" +
        "}" +
        "]"
//        print("origin data :\(data)")
        
        if let dataFromString = data.data(using: .utf8 , allowLossyConversion: false){
            let json = JSON(data:dataFromString)
//            print("data parsing from string :\(json)")
//            let ss = json[0]["red"]
//            print("number of green : \(ss)")
            let Garray = json[0]["green"]["location"].arrayValue
            let Yarray = json[0]["yellow"]["location"].arrayValue
            let Rarray = json[0]["red"]["location"].arrayValue
            
            showPointAtMap(green: Garray as NSArray, yellow: Yarray as NSArray , red: Rarray as NSArray)
        }
    }
    
    func showPointAtMap(green:NSArray , yellow:NSArray , red:NSArray ){
//        print("green:\n\(green)")
        
    }
   
    
}

