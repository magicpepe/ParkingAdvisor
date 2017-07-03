//
//  dashboardViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/11.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
class dashboardViewController: UIViewController {
    
    private var myCircleProgress: KYCircularProgress!
    private var progress: UInt8 = 0
    private var animationTimer = Timer()
    
    // 為了讓Timer到達指定等級停止 , 需要是小數
    private var dangerousLevel = 0.93
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMyCircleProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        progress = 0
        animationTimer = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(dashboardViewController.updateProgress), userInfo: nil, repeats: true)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        animationTimer.invalidate()
    }
    
    private func configureMyCircleProgress(){
        
        myCircleProgress = KYCircularProgress(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), showGuide: true)
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let radius = CGFloat(view.frame.width/3) + 20.0
        let lineWidth = 15.0
        myCircleProgress.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(Double.pi)*1.5, endAngle: CGFloat(Double.pi)*3.5, clockwise: true)
        myCircleProgress.lineWidth = lineWidth
        myCircleProgress.guideLineWidth = lineWidth
        myCircleProgress.guideColor = UIColor(rgba: 0xF6F6F6FF)
        
//        myCircleProgress.colors = [UIColor(rgba: 0xFF3B30AA), UIColor(rgba: 0xFFCC00AA), UIColor(rgba: 0x4CD964AA), UIColor(rgba: 0x5AC8FAFF)]
        myCircleProgress.colors = [UIColor(rgba: 0x28FF28AA), UIColor(rgba: 0x0080FFAA), UIColor(rgba: 0xFF77FFAA), UIColor(rgba: 0xFF5151AA)]
//        myCircleProgress.colors = [UIColor(rgba: 0x5AC8FAFF)]
        
        let background_circle = UIView.init(frame: CGRect( x:0, y:0, width: radius * 2, height: radius * 2 ))
        background_circle.center = center
        background_circle.backgroundColor = UIColor(rgba: 0xF6F6F6FF)
        background_circle.layer.cornerRadius = radius
        myCircleProgress.addSubview(background_circle)
        
        let labelWidth = CGFloat(180.0)
        let textLabel = UILabel(frame: CGRect(x: (view.frame.width - labelWidth) / 2, y: (view.frame.height - 180) / 2 , width: labelWidth, height: 180.0))
        textLabel.font = UIFont(name: "HelveticaNeue", size: 135)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor(rgba: 0x5AC8FAFF)
        myCircleProgress.addSubview(textLabel)
        
        myCircleProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            print("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))"
//            textLabel.textColor = myCircleProgress.colors
        }
        view.addSubview(myCircleProgress)

    }

    
    @objc private func updateProgress() {
        
        if Double(progress) / Double(UInt8.max) < dangerousLevel  {
            progress = progress &+ 1
            let normalizedProgress = Double(progress) / Double(UInt8.max)
//            halfCircularProgress.progress = normalizedProgress
            myCircleProgress.progress = normalizedProgress

        }
    }
    


    
    
}

