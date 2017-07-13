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
    
    private var PAlocation : CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    private var PAaddress : String = "逢甲路100號"
    
    public var hi = 50
    
    func returnTrue() -> String {
        return "Love <3"
    }
    
    func setLocation(location: CLLocationCoordinate2D){
        self.PAlocation = location
    }
    
    func getLocation() -> CLLocationCoordinate2D{
        return self.PAlocation
    }
    
    func setAddress(address: CLLocationCoordinate2D){
        self.PAlocation = address
    }
    
    func getAddress() -> String{
        return self.PAaddress
    }
    
}
