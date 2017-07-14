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
    
    private var PAlocation : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 24.123456, longitude: 120.787878)
    private var PAaddress : String = "逢甲路100號"
    private var PAscore : Int = 87
    
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
    
    func setScore(score : Int){
        self.PAscore = score
    }
    func getScore() -> Int{
        return self.PAscore
    }
    
}
