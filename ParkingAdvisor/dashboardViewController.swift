//
//  dashboardViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/11.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import GoogleMaps
import Pulsator

class dashboardViewController: UIViewController ,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    private var myCircleProgress: KYCircularProgress!
    private var progress: UInt8 = 0
    private var animationTimer = Timer()
    var lbl_score : UILabel = UILabel()
    
    // parameter
    let offset_map : CGFloat = 150.0
    
    // label
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_prccessing : UILabel!
    @IBOutlet weak var lbl_safePoint: UILabel!
    
    // map view
    var isMapInit : Bool = false
    var mapView : GMSMapView!
    var blurEffectView : UIVisualEffectView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var uiview_mapView: UIView!
    let pulsator = Pulsator()
    
    
    // 為了讓Timer到達指定等級停止 , 需要是小數
    private var dangerousLevel = 0.93
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        // set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background_2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
//        configureMyCircleProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        progress = 0
//        animationTimer = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(dashboardViewController.updateProgress), userInfo: nil, repeats: true)
//        lbl_safePoint.alpha = 0
        lbl_safePoint.frame.origin.x = self.view.frame.width
        lbl_location.alpha = 0
        lbl_address.alpha = 0
        lbl_prccessing.alpha = 0
        
        initMap()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        animationTimer.invalidate()
    }
    
    private func configureMyCircleProgress(){
        
        let uiview_radius : CGFloat = view.frame.width / 2 - 50
        let uiview_center = CGPoint(x: Int(view.frame.width / 2), y: Int(uiview_radius + 120))
        
        myCircleProgress = KYCircularProgress(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), showGuide: true)
//        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
//        let radius = CGFloat(view.frame.width/3) + 20.0
        let radius : CGFloat = view.frame.width / 2 - 50
        let center = CGPoint(x: Int(view.frame.width / 2), y: Int(radius + 50 + self.offset_map))
        
        let lineWidth = 15.0
        myCircleProgress.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(Double.pi)*1.5, endAngle: CGFloat(Double.pi)*3.5, clockwise: true)
        myCircleProgress.lineWidth = lineWidth
        myCircleProgress.guideLineWidth = lineWidth
        myCircleProgress.guideColor = UIColor(rgba: 0xF6F6F6FF)
//        myCircleProgress.backgroundColor = UIColor.black
        
//        myCircleProgress.colors = [UIColor(rgba: 0xFF3B30AA), UIColor(rgba: 0xFFCC00AA), UIColor(rgba: 0x4CD964AA), UIColor(rgba: 0x5AC8FAFF)]
        myCircleProgress.colors = [UIColor(rgba: 0x28FF28AA), UIColor(rgba: 0x0080FFAA), UIColor(rgba: 0xFF77FFAA), UIColor(rgba: 0xFF5151AA)]
//        myCircleProgress.colors = [UIColor(rgba: 0x5AC8FAFF)]
        
        let background_circle = UIView.init(frame: CGRect( x:0, y:0, width: radius * 2, height: radius * 2 ))
        background_circle.center = center
        background_circle.backgroundColor = UIColor(rgba: 0xF6F6F6FF)
        background_circle.layer.cornerRadius = radius
        myCircleProgress.addSubview(background_circle)
        
        let labelWidth = CGFloat(200.0)
//        let textLabel = UILabel(frame: CGRect(x: (view.frame.width - labelWidth) / 2, y: (view.frame.height - 180) / 2 , width: labelWidth, height: 180.0))
        lbl_score = UILabel(frame: CGRect(x: (view.frame.width - labelWidth) / 2, y: uiview_radius - 35 + self.offset_map , width: labelWidth, height: 180.0))
        
        lbl_score.font = UIFont(name: "HelveticaNeue", size: 135)
        lbl_score.textAlignment = .center
        lbl_score.textColor = UIColor(rgba: 0x5AC8FAFF)
        view.addSubview(lbl_score)
        
        myCircleProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
//            print("progress: \(progress)")
            self.lbl_score.text = "\(Int(progress * 100.0))"
        }
        view.insertSubview(myCircleProgress, belowSubview: self.uiview_mapView)

    }

    
    @objc private func updateProgress() {
        
        if Double(progress) / Double(UInt8.max) < dangerousLevel  {
            progress = progress &+ 1
            let normalizedProgress = Double(progress) / Double(UInt8.max)
            myCircleProgress.progress = normalizedProgress

        }else{
            print("ScanView updateProgress end")
            animationTimer.invalidate()
            
            // after score animate finished
            // text score view appear
            UIView.animate(withDuration: 2 ,delay: 2, options: .curveLinear, animations:{
                self.lbl_score.alpha = 0
            } ,completion: {_ in
                self.lbl_score.font = UIFont(name: "HelveticaNeue", size: 80)
                self.lbl_score.text = "極安全"
                self.lbl_score.frame.origin.y += 45
                self.lbl_score.frame.origin.x -= 20
                self.lbl_score.textColor = UIColor(rgba: 0x88B04BFF)
                self.lbl_score.sizeToFit()
                UIView.animate(withDuration: 1.5 ,delay: 2, options: .curveEaseOut, animations:{
                    self.lbl_score.alpha = 1
                    
                } ,completion: {_ in
                    self.lbl_location.frame.origin.x = self.view.frame.width
                    self.lbl_location.frame.origin.y = 120
                    UIView.animate(withDuration: 0.5, animations:{
                        self.lbl_location.frame.origin.x = 43
                        self.lbl_safePoint.frame.origin.x = 31
                        })
                })
                
            })
            
        }
    }
    
    // MARK: - MAP
    
    func initMap() {
        lbl_prccessing.text = "定位中"
        lbl_prccessing.alpha = 1
        // uiview init
        let uiview_radius : CGFloat = view.frame.width / 2 - 50
        let uiview_center = CGPoint(x: Int(view.frame.width / 2), y: Int(uiview_radius + 50 ))
        uiview_mapView.frame = CGRect(x:0, y:0, width: uiview_radius * 2, height: uiview_radius * 2)
        uiview_mapView.center = uiview_center
        uiview_mapView.layer.cornerRadius = uiview_radius
        
        // uiview shadow
//        uiview_mapView.layer.shadowColor = UIColor.white.cgColor
//        uiview_mapView.layer.shadowOpacity = 0.8
//        uiview_mapView.layer.shadowOffset = CGSize.zero
//        uiview_mapView.layer.shadowRadius = 5
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: 10)
        
        self.mapView = GMSMapView.map(withFrame: uiview_mapView.frame, camera: camera)
        mapView.delegate = self
        
        mapView.layer.cornerRadius = uiview_radius
        uiview_mapView = mapView
        
        self.view.addSubview(uiview_mapView)
        isMapInit = true
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations:{
            self.lbl_prccessing.alpha = 0
        } , completion: {_ in
            self.lbl_prccessing.alpha = 1
            self.updateCameraByGPS()
            
        })
    }
    
    func updateCameraByGPS() {
        
        lbl_prccessing.text = "處理中"
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: 10)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        mapView.animate(toZoom: 16.0)
        CATransaction.commit()
        
        lbl_location.text = "\(locationManager.location!.coordinate.latitude) ,\(locationManager.location!.coordinate.longitude)"
        
        // blur effect
        let blurEffect : UIBlurEffect!
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        } else {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        }
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = uiview_mapView.bounds
        blurEffectView.center = uiview_mapView.center
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = view.frame.width / 2 - 50
        blurEffectView.clipsToBounds = true
        view.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.blurEffectView.alpha = 0.7
        },completion: {_ in
            self.lbl_prccessing.text = "輕觸開始分析"
            self.lbl_location.alpha = 1
            self.pulseStart()
        })
        
        //        label attribute
        //        lbl_location.textColor = UIColor(rgba: 0xFFFFFFFF)
        lbl_address.alpha = 0
        
    }
    
    // MARK: - Pulse
    func pulseStart(){
        
        pulsator.radius = 190.0
        pulsator.numPulse = 5
        pulsator.animationDuration = 10
        pulsator.pulseInterval = 1
        pulsator.backgroundColor = UIColor(red: 0/255, green: 169/255, blue: 180/255, alpha: 1).cgColor
        pulsator.position = CGPoint(x: Int(view.frame.width / 2), y: Int(view.frame.width / 2 ) )
        self.view.layer.insertSublayer(pulsator, below: uiview_mapView.layer)
        pulsator.start()
        
    }
    
    
    // MARK: - Button
    
    @IBAction func btn_startAnalyse(_ sender: Any) {
        let uiview_radius : CGFloat = view.frame.width / 2 - 50
        
        pulsator.stop()
//        uiview_mapView.layer.shadowColor = UIColor.clear.cgColor
//        uiview_mapView.backgroundColor = UIColor.white
        progress = 0
        UIView.animate(withDuration: 1.5 ,delay: 0.5, options: .curveEaseOut, animations:{
            self.uiview_mapView.frame = CGRect(x:self.uiview_mapView.frame.origin.x, y: self.uiview_mapView.frame.origin.y + self.offset_map , width: uiview_radius * 2, height: uiview_radius * 2)
            self.blurEffectView.frame = CGRect(x:self.blurEffectView.frame.origin.x, y: self.blurEffectView.frame.origin.y + self.offset_map , width: uiview_radius * 2, height: uiview_radius * 2)
            
        } ,completion: {_ in
            self.configureMyCircleProgress()
            self.animationTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(dashboardViewController.updateProgress), userInfo: nil, repeats: true)
            
        })
        
    }
    
    // MARK: - LocationManager
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//
//        // singleton
//        PASingleton.sharedInstance().setLocation(location: locValue)
//
//    }
    
    
}

