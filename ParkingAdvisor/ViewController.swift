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
    var mapView:GMSMapView!
    
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
        
//        getPointFromAPI(location: locationManager.location!.coordinate)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button

    @IBAction func btn_goNext(_ sender: UIButton) {
        performSegue(withIdentifier:"goDashBoard" , sender:nil)
    }
    
    // MARK: - MAP Init

    func initMap(location:CLLocationCoordinate2D) {
        
        let locValue:CLLocationCoordinate2D = location
        print("initMaps Locations = \(locValue.latitude) \(locValue.longitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: 17)
        
        
        self.mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:0 , width:view.frame.width,height : view.frame.height), camera: camera)
        mapView.settings.myLocationButton = true
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.snippet = "Hello World"
        //        marker.appearAnimation = GMSMarkerAnimationPop
        marker.map = mapView
        

//        view.addSubview(mapView)
        view = mapView
        view.bringSubview(toFront: btn_next)
        isMapInit = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if !isMapInit{
            initMap(location: locValue)
            getPointFromAPI(location: locationManager.location!.coordinate)

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
                "\"120.644490\",\"24.178780\"," +
                "\"120.645097\",\"24.178535\"," +
                "\"120.645456\",\"24.178824\"" +
                "]" +
            "}," +
            "\"yellow\": {" +
                "\"number\": 1," +
                "\"location\": [" +
                "\"120.645102\",\"24.179225\"" +
                "]" +
            "}," +
            "\"red\": {" +
                "\"number\": 2," +
                "\"location\": [" +
                "\"120.645102\",\"24.179225\"," +
                "\"120.644920\",\"24.178804\"" +
                "]" +
            "}" +
        "}" +
        "]"
        print("origin data :\(data)")
        
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
    
    func showPointAtMap(green:NSArray , yellow:NSArray , red:NSArray  ){
        // dirty code ....
        for i in (0..<green.count) where i % 2 == 0 {
            let position = CLLocationCoordinate2D(latitude: Double(String(describing: green[i+1]))! , longitude: Double(String(describing: green[i]))! )
            let point = GMSMarker(position: position)
            point.title = "kk"
            point.icon = UIImage(named: "map_point_green")
            point.map = self.mapView
            print("\(point)")
            
        }
        for i in (0..<yellow.count) where i % 2 == 0 {
            let position = CLLocationCoordinate2D(latitude: Double(String(describing: yellow[i+1]))! , longitude: Double(String(describing: yellow[i]))! )
            let point = GMSMarker(position: position)
            point.title = "kk"
            point.icon = UIImage(named: "map_point_yellow")
            point.map = self.mapView
            print("\(point)")
            
        }
        for i in (0..<red.count) where i % 2 == 0 {
            let position = CLLocationCoordinate2D(latitude: Double(String(describing: red[i+1]))! , longitude: Double(String(describing: red[i]))! )
            let point = GMSMarker(position: position)
            point.title = "kk"
            point.icon = UIImage(named: "map_point_red")
            point.map = self.mapView
            print("\(point)")
            
        }
        
        
    }
   
}

