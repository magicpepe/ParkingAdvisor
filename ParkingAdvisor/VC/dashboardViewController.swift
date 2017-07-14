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

class dashboardViewController: UIViewController ,CLLocationManagerDelegate, GMSMapViewDelegate, closeCommentVCProtocol{
    
    // scan view
    private var myCircleProgress: KYCircularProgress!
    private var progress: UInt8 = 0
    private var animationTimer = Timer()
    var lbl_score : UILabel = UILabel()
    @IBOutlet weak var btn_scan: UIButton!
    
    let config  = sizeConfig()
    // parameter
    let color_lightblue_lbl = UIColor(rgba : 0x388BB8FF)
    var isStartAnalyse : Bool = false
    
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
    let background_circle : UIView = UIView()
    
    // constraint
    @IBOutlet weak var constraint_mapY: NSLayoutConstraint!
    
    @IBOutlet weak var CT_lbl_location_Y: NSLayoutConstraint!
    @IBOutlet weak var CT_lbl_location_centerX: NSLayoutConstraint!
    @IBOutlet weak var CT_lbl_address_Y: NSLayoutConstraint!
    @IBOutlet weak var CT_lbl_address_centerX: NSLayoutConstraint!
    @IBOutlet weak var CT_img_linebar_centerX: NSLayoutConstraint!
    @IBOutlet weak var CT_lbl_safepoint_centerX: NSLayoutConstraint!
    
    // monitor
    @IBOutlet weak var img_linebar: UIImageView!
    @IBOutlet weak var img_moniotr: UIButton!
    @IBOutlet weak var lbl_startMonitor : UILabel!
    private var monitorTimer = Timer()
    private var monitorCounter : Int = 0
    
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
        // lbl
        CT_lbl_safepoint_centerX.constant = self.view.frame.width
        lbl_location.alpha = 0
        lbl_address.alpha = 0
        lbl_prccessing.alpha = 0
        
        // scan
        btn_scan.isHidden = true
        
        // monitor
        img_moniotr.alpha = 0
        CT_img_linebar_centerX.constant = view.frame.width
        lbl_startMonitor.alpha = 0
        monitorCounter = 0
        self.view.layoutIfNeeded()
        isStartAnalyse = false
        
        initMap()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        animationTimer.invalidate()
        monitorTimer.invalidate()
        uiview_mapView?.removeFromSuperview()
        myCircleProgress?.removeFromSuperview()
        pulsator.stop()
        background_circle.removeFromSuperview()
    }
    
    private func configureMyCircleProgress(){
        
        
        myCircleProgress = KYCircularProgress(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), showGuide: true)
        
        let lineWidth = 15.0
        myCircleProgress.path = UIBezierPath(arcCenter: self.uiview_mapView.center, radius: self.uiview_mapView.frame.width / 2, startAngle: CGFloat(Double.pi)*1.5, endAngle: CGFloat(Double.pi)*3.5, clockwise: true)
        myCircleProgress.lineWidth = lineWidth
        myCircleProgress.guideLineWidth = lineWidth
        myCircleProgress.guideColor = UIColor(rgba: 0xF6F6F6FF)
        myCircleProgress.colors = [UIColor(rgba: 0x28FF28AA), UIColor(rgba: 0x0080FFAA), UIColor(rgba: 0xFF77FFAA), UIColor(rgba: 0xFF5151AA)]
        
        background_circle.frame = CGRect( x:0, y:0, width: uiview_mapView.frame.width, height: uiview_mapView.frame.height )
        background_circle.center = uiview_mapView.center
        background_circle.backgroundColor = UIColor(rgba: 0xF6F6F6FF)
        background_circle.layer.cornerRadius = uiview_mapView.frame.width
        myCircleProgress.addSubview(background_circle)
        
        lbl_score = UILabel(frame: CGRect(x: (self.uiview_mapView.frame.width - config.getSize(key: "lbl_score_width")) / 2 , y: (uiview_mapView.frame.height - config.getSize(key: "lbl_score_height")) / 2 , width: config.getSize(key: "lbl_score_width"), height: config.getSize(key: "lbl_score_height")))
        lbl_score.font = UIFont(name: "HelveticaNeue", size: config.getSize(key: "lbl_score_size"))
        lbl_score.textAlignment = .center
        lbl_score.textColor = UIColor(rgba: 0x5AC8FAFF)
        uiview_mapView.addSubview(lbl_score)
        
        myCircleProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
//            print("progress: \(progress)")
            self.lbl_score.text = "\(Int(progress * 100.0))"
        }
        view.insertSubview(myCircleProgress, belowSubview: self.uiview_mapView)

    }

    
    @objc private func updateProgress() {
        if Double(progress) / Double(UInt8.max) < Double(PASingleton.sharedInstance().getScore()) / Double(100)  {
            progress = progress &+ 1
            let normalizedProgress = Double(progress) / Double(UInt8.max)
            myCircleProgress.progress = normalizedProgress

        }else{
            print("ScanView updateProgress end")
            animationTimer.invalidate()
            
            // after score animate finished
            // text score view appear
            UIView.animate(withDuration: 1.5 ,delay: 0.5, options: .curveLinear, animations:{
                // 分數消失
                self.lbl_score.alpha = 0
            } ,completion: {_ in
                // 分數中文評語出現
                self.lbl_score.font = UIFont(name: "HelveticaNeue", size: self.config.getSize(key: "lbl_score_chinese_size"))
                self.lbl_score.text = self.setScoreChinese()
                self.lbl_score.textColor = UIColor(rgba: 0x4A4A4AFF)
                UIView.animate(withDuration: 1.5 ,delay: 0.5, options: .curveEaseOut, animations:{
                    self.lbl_score.alpha = 1
                    
                } ,completion: {_ in
                    // 地址 經緯度 飛入動畫
                    // 先移出螢幕外 Y先到定位
                    self.CT_lbl_location_centerX.constant = self.view.frame.width / 2
                    self.CT_lbl_location_Y.constant = self.config.getSize(key: "lbl_location_after_animation_y")
                    self.CT_lbl_address_centerX.constant = self.view.frame.width / 2
                    self.CT_lbl_address_Y.constant = self.config.getSize(key: "lbl_address_after_animation_y")
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.5, animations:{
                        // 地址 經緯度 飛入動畫
                        // Y定位後 飛入 X變化
                        // lbl X位置置中
                        self.CT_lbl_address_centerX.constant = 0
                        self.CT_lbl_location_centerX.constant = 0
                        self.CT_lbl_safepoint_centerX.constant = 0
                        self.view.layoutIfNeeded()
                        
                    },completion: {_ in
                        UIView.animate(withDuration: 0.5, animations: {
                            // img_linebar 從螢幕右邊往左飛入
                            self.CT_img_linebar_centerX.constant = 0
                            self.view.layoutIfNeeded()
                        },completion: {_ in
                            UIView.animate(withDuration: 0.5, animations: {
                                // 開始監控的button圓形點顯示
                                self.img_moniotr.alpha = 1
                                self.lbl_startMonitor.alpha = 1
                            },completion: nil
                                // 開始監控
//                                self.monitorTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dashboardViewController.upgradeMonitorTimer), userInfo: nil, repeats: true)
                            )
                        })
                    })
                })
                
            })
            
        }
    }
    
    func setScoreChinese() -> String {
        let score : Int = PASingleton.sharedInstance().getScore()
        
        if (score < 20){
            return "極危險"
        }else if (score <= 40){
            return "危險"
        }else if (score <= 60){
            return "需注意"
        }else if (score <= 80){
            return "安全"
        }else if (score <= 100){
            return "極安全"
        }
        print("error -- no score --")
        return "無資料"
    }
    
    // MARK: - MAP
    
    func initMap() {
        lbl_prccessing.text = "定位中"
        lbl_prccessing.alpha = 1
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: 10)
        
        self.mapView = GMSMapView.map(withFrame: uiview_mapView.frame, camera: camera)
        self.mapView.frame.origin = CGPoint.zero
        mapView.delegate = self
        
        mapView.layer.cornerRadius = uiview_mapView.frame.width / 2
        uiview_mapView.addSubview(mapView)
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
        
//        lbl_location.text = "\(locationManager.location!.coordinate.latitude) ,\(locationManager.location!.coordinate.longitude)"
        lbl_location.text = String(format: "%6f, %6f", locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
        lbl_address.text = PASingleton.sharedInstance().getAddress()
        
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
        uiview_mapView.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.blurEffectView.alpha = 0.7
        },completion: {_ in
            self.lbl_prccessing.text = "輕觸開始分析"
            self.lbl_location.alpha = 1
            self.lbl_address.alpha = 1
            self.pulseStart()
            self.btn_scan.isHidden = false
        })
        
    }
    
    // MARK: - Pulse
    func pulseStart(){
        
        pulsator.radius = uiview_mapView.frame.width / 2 + 50
        pulsator.numPulse = 5
        pulsator.animationDuration = 10
        pulsator.pulseInterval = 1
        pulsator.backgroundColor = UIColor(red: 0/255, green: 169/255, blue: 180/255, alpha: 1).cgColor
        pulsator.position = uiview_mapView.center
        self.view.layer.insertSublayer(pulsator, below: uiview_mapView.layer)
        pulsator.start()
        
    }
    
    
    // MARK: - Button
    
    @IBAction func btn_startAnalyse(_ sender: Any) {
        if(isStartAnalyse == false){
            isStartAnalyse = true
            self.lbl_prccessing.alpha = 0
            pulsator.stop()
            progress = 0
            
            UIView.animate(withDuration: 1.5 ,delay: 0.5, options: .curveEaseOut, animations:{
                // 動畫 : 地圖 / (毛玻璃) 向下滑動
                self.constraint_mapY.constant -= self.config.getSize(key: "map_offset")
                self.view.layoutIfNeeded()
    //
            } ,completion: {_ in
                self.configureMyCircleProgress()
                self.animationTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(dashboardViewController.updateProgress), userInfo: nil, repeats: true)
                
            })
        }
    }
    
    @IBAction func btn_startMonitor(_ sender: Any) {
        NSLog("btn_startMonitor pressed")
        monitorTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dashboardViewController.upgradeMonitorTimer), userInfo: nil, repeats: true)
        
    }
    
    // MARK: Monitor
    func upgradeMonitorTimer(){
        lbl_startMonitor.text = "停止監控"
        
        monitorCounter = monitorCounter + 1
        self.lbl_score.text = String(format: "%.2d:%.2d", monitorCounter / 60, monitorCounter % 60)
        
        if (monitorCounter > 2){
            monitorTimer.invalidate()
            showComment()
        }
    }
    
    // MARK: - Comment
    
    func showComment(){
        
        let commentVC : CommentViewController = storyboard!.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        
        
        commentVC.delegate = self
        commentVC.view.alpha = 0
        self.view.addSubview(commentVC.view)
        self.addChildViewController(commentVC)
        UIView.animate(withDuration: 1 ,animations : {
            commentVC.view.alpha = 1
        })
    }
    
    func closeComment() {
        
        NSLog("closeComment")
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
        
        self.viewDidDisappear(false)
        self.loadView()
        self.viewWillAppear(true)
        self.viewDidLoad()
    }
    
    func getTimer() -> Int{
        return monitorCounter
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

class sizeConfig{
    
    let ipad_size = [
        "map_offset" : 250,
        "lbl_score_size" : 250,
        // 中文評語size
        "lbl_score_chinese_size" : 120 ,
        "lbl_score_height" : 380,
        "lbl_score_width" : 400,
        // lbl_safepoint (y + height) + offset
        "lbl_location_after_animation_y": 155 + 28,
        // lbl_location_after_animation_y (y + height) + offset
        "lbl_address_after_animation_y": 213 + 28
        
    ]
    
    let iphone_size = [
        "map_offset" : 150,
        "lbl_score_size" : 135,
        // 中文評語size
        "lbl_score_chinese_size" : 80 ,
        "lbl_score_height" : 180,
        "lbl_score_width" : 200,
        // lbl_safepoint (y + height) + offset
        "lbl_location_after_animation_y": 120,
        // lbl_location_after_animation_y (y + height) + offset
        "lbl_address_after_animation_y": 149
    ]
    init(){
        return
    }
    
    func getSize(key : String) -> CGFloat{
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return CGFloat(iphone_size[key]!)
        case .pad:
            return CGFloat(ipad_size[key]!)
        case .tv:
            print("error tv size")
        case .carPlay:
            print("error carPlay size")
        case .unspecified:
            print("error size")
            // Uh, oh! What could it be?
            
        }
            print("#ERROR No this SIZE")
            return CGFloat(0)
    }
    
}

