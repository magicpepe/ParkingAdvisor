//
//  PASingleton.swift
//  ParkingAdvisor
//
//  Created by WeiKang on 2017/7/4.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class PASingleton {
    private static var paInstance:PASingleton?
    static func sharedInstance() -> PASingleton {
        if paInstance == nil {
            paInstance = PASingleton()
            
        }
        return paInstance!
    }
    
    private init(){
    }
    
    private var location : CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    func returnTrue() -> String {
        return "TRUE <3"
    }
    
    func setLocation(location: CLLocationCoordinate2D){
        self.location = location
    }
    func getLocation() -> CLLocationCoordinate2D{
        return self.location
    }
    
}
