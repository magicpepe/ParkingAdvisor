//
//  ViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/10.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var btn_next: UIButton!

//    override func loadView() {
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MyMap"
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                              longitude: 151.2086,
                                              zoom: 14)
//        let mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:90 , width:view.frame.width,height : view.frame.height/2), camera: camera)
        let mapView = GMSMapView.map(withFrame: CGRect(x:0 ,y:0 , width:view.frame.width,height : view.frame.height), camera: camera)

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
        
//        let myButton = UIButton(
//            title:"Next",
//            style:.plain,
//            target:self,
//            action:#selector(ViewController.btn_goDashboard)
//        )
//        self.navigationItem.rightBarButtonItem = rightButton

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

