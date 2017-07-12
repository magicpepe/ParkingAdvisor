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

let kMapStyle = "[" +
    "  {" +
    "    \"featureType\": \"poi.business\"," +
    "    \"elementType\": \"all\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"transit\"," +
    "    \"elementType\": \"labels.icon\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }" +
"]"



class ViewController: BaseViewController ,CLLocationManagerDelegate, closeDetailVCProtocol, GMSMapViewDelegate{
    
//    @IBOutlet weak var btn_next: UIButton!

    var detailVCisOn : Bool = false
    var DetailVC : DetailViewController! = nil
    
    let locationManager = CLLocationManager()
    var isMapInit : Bool = false
    var mapView:GMSMapView!
    @IBOutlet weak var btn_arrow: UIButton!
    
    
    override func loadView() {
        
        super.loadView()
        
        
//        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        addSlideMenuButton()
        
//        getPointFromAPI(location: locationManager.location!.coordinate)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MAP Init

    func initMap(location:CLLocationCoordinate2D) {
        
        
        //
        let locValue:CLLocationCoordinate2D = location
        print("initMaps Locations = \(locValue.latitude) \(locValue.longitude)")
        
//        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
//                                              longitude: (locationManager.location?.coordinate.longitude)!,
//                                              zoom: 17)
        let camera = GMSCameraPosition.camera(withLatitude: (locValue.latitude),
                                              longitude: (locValue.longitude),
                                              zoom: 17)
        
        
        self.mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:0 , width:view.frame.width,height : view.frame.height), camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.snippet = "Hello World"
        //        marker.appearAnimation = GMSMarkerAnimationPop
        
//        do {
//            // Set the map style by passing a valid JSON string.
//            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
//        } catch {
//            NSLog("One or more of the map styles failed to load. \(error)")
//        }
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "bstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        marker.map = mapView
        

//        view.addSubview(mapView)
        view = mapView
//        view.bringSubview(toFront: btn_arrow)
        view.addSubview(btn_arrow)
        isMapInit = true
    }
    
    // MARK: - LocationManager

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        /// ------ testing -------
        locValue.latitude = 24.178805
        locValue.longitude = 120.644828
        /// ------ testing -------
        
        // singleton
        PASingleton.sharedInstance().setLocation(location: locValue)
        
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
                "\"120.644034\",\"24.178699\"," +
                "\"120.643789\",\"24.178535\"," +
                "\"120.644476\",\"24.179364\"" +
                "]" +
            "}," +
            "\"yellow\": {" +
                "\"number\": 1," +
                "\"location\": [" +
                "\"120.645414\",\"24.178828\"," +
                "\"120.644656\",\"24.178802\"" +
                "]" +
            "}," +
            "\"red\": {" +
                "\"number\": 2," +
                "\"location\": [" +
                "\"120.645096\",\"24.178971\"," +
                "\"120.645096\",\"24.178479\"" +
                "]" +
            "}" +
        "}" +
        "]"
        print("origin data :\(data)")
        
        if let dataFromString = data.data(using: .utf8 , allowLossyConversion: false){
            let json = JSON(data:dataFromString)
            let Garray = json[0]["green"]["location"].arrayValue
            let Yarray = json[0]["yellow"]["location"].arrayValue
            let Rarray = json[0]["red"]["location"].arrayValue
            
            showPointAtMap(arrayToShow: Garray as NSArray,color : "green")
            showPointAtMap(arrayToShow: Yarray as NSArray,color : "yellow")
            showPointAtMap(arrayToShow: Rarray as NSArray,color : "red")

        }
    }
    
    func showPointAtMap(arrayToShow :NSArray ,color :String){
        for i in (0..<arrayToShow.count) where i % 2 == 0 {
            let position = CLLocationCoordinate2D(latitude: Double(String(describing: arrayToShow[i+1]))! , longitude: Double(String(describing: arrayToShow[i]))! )
            let point = GMSMarker(position: position)
            point.title = color
            point.icon = UIImage(named: "map_point_"+color)
            point.map = self.mapView

            //            print("\(point)")
            
        }
        
        
    }
    // MARK: - MAP Delegate
    
    func mapView(_ mapView : GMSMapView, didTapMarker marker: GMSMarker){
        
        NSLog("marker did tap")
        
        if(detailVCisOn == true){
            self.updateVC()
            return
        }
        self.showVC()
        
        
    }

    
    // MARK: - DetailView Controll
    
    func closeVC() {
        
        NSLog("closeVC")
        
        if(detailVCisOn == true){
            let viewBack : UIView = view.subviews.last!

            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                //        self.willMove(toParentViewController: nil)
                var frameMenu : CGRect = viewBack.frame
                frameMenu.origin.y = 2 * UIScreen.main.bounds.size.height
                viewBack.frame = frameMenu

                viewBack.layoutIfNeeded()
                viewBack.backgroundColor = UIColor.clear
                //        self.removeFromParentViewController()
            }, completion: { (finished) -> Void in
                viewBack.removeFromSuperview()
            })
            detailVCisOn = false
            DetailVC = nil
        }
        
    }
    
    func showVC(){
        let DetailVC : DetailViewController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DetailVC.delegate = self
        
        self.view.addSubview(DetailVC.view)
        self.addChildViewController(DetailVC)
//        DetailVC.view.layoutIfNeeded()

        DetailVC.view.frame = CGRect(x: 10, y: 480, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 540)
        
        detailVCisOn = true

    }
    
    func updateVC(){
        return
    }
    
    // MARK: - Button
    
    @IBAction func btn_detail(_ sender: Any) {
        showVC()
    }
}

