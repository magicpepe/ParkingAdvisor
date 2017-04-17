//
//  dashboardViewController.swift
//  ParkingAdvisor
//
//  Created by MCLAB on 2017/4/11.
//  Copyright © 2017年 MCLAB. All rights reserved.
//

import UIKit
class dashboardViewController: UIViewController {
    
    private var halfCircularProgress: KYCircularProgress!
    private var myCircleProgress: KYCircularProgress!
    
    
    private var fourColorCircularProgress: KYCircularProgress!
    private var progress: UInt8 = 0
    private var animationProgress: UInt8 = 0
    
    // 為了讓Timer到達指定等級停止 , 需要是小數
    private var dangerousLevel = 1.1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "危險指數"
//        let myButton = UIButton(frame: CGRect(
//            x: 100, y: 250, width: 120, height: 40))
//        myButton.setTitle("Back", for: .normal)
//        myButton.backgroundColor = UIColor.blue
//        myButton.addTarget(
//            self,
//            action: #selector(dashboardViewController.btn_goBack),
//            for: .touchUpInside)
//        self.view.addSubview(myButton)

        
        configureHalfCircularProgress()
        configureMyCircleProgress()
        
        Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(dashboardViewController.updateProgress), userInfo: nil, repeats: true)
//        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(dashboardViewController.updateAnimationProgress), userInfo: nil, repeats: true)
    }
    
    private func configureHalfCircularProgress() {
        halfCircularProgress = KYCircularProgress(frame: CGRect(x: 0, y: 90, width: view.frame.width, height: view.frame.height/2), showGuide: true)
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 4)
        halfCircularProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat((halfCircularProgress.frame).width/3), startAngle: CGFloat(Double.pi), endAngle: CGFloat(0.0), clockwise: true)
//        halfCircularProgress.colors = [UIColor(rgba: 0xA6E39DAA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABAA)]
        halfCircularProgress.colors = [UIColor(rgba: 0x02C874AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xFF2D2DAA)]

        halfCircularProgress.guideColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        halfCircularProgress.lineWidth = 15.0
        halfCircularProgress.guideLineWidth = 20.0
        let labelWidth = CGFloat(80.0)
        let textLabel = UILabel(frame: CGRect(x: (view.frame.width - labelWidth) / 2, y: (view.frame.height - labelWidth) / 4, width: labelWidth, height: 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue", size: 24)
        textLabel.textAlignment = .center
        textLabel.textColor = .green
        textLabel.alpha = 0.3
        halfCircularProgress.addSubview(textLabel)
        
        halfCircularProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            print("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        }
        
        view.addSubview(halfCircularProgress)
    }
    private func configureMyCircleProgress(){
        
        //fourColorCircularProgress = KYCircularProgress(frame: CGRect(x: 20.0, y: halfCircularProgress.frame.height/1.75, width: view.frame.width/3, height: view.frame.height/3))
        myCircleProgress = KYCircularProgress(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height/2), showGuide: true)
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 4)
        myCircleProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat((halfCircularProgress.frame).width/3), startAngle: CGFloat(Double.pi)*1.5, endAngle: CGFloat(Double.pi)*3.5, clockwise: true)

        myCircleProgress.colors = [UIColor(rgba: 0x28FF28AA), UIColor(rgba: 0x0080FFAA), UIColor(rgba: 0xFF77FFAA), UIColor(rgba: 0xFF5151AA)]

        let labelWidth = CGFloat(80.0)
        let textLabel = UILabel(frame: CGRect(x: (view.frame.width - labelWidth) / 2, y: view.frame.height / 4, width: labelWidth, height: 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue", size: 24)
        textLabel.textAlignment = .center
        textLabel.textColor = .green
        textLabel.alpha = 0.3
        myCircleProgress.addSubview(textLabel)
        
        myCircleProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            print("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        }
        view.addSubview(myCircleProgress)

    }

    
    @objc private func updateProgress() {
        
        if Double(progress) / Double(UInt8.max) < dangerousLevel  {
            progress = progress &+ 1
            let normalizedProgress = Double(progress) / Double(UInt8.max)
            halfCircularProgress.progress = normalizedProgress
            myCircleProgress.progress = normalizedProgress

        }

        
        

    }
    

//    @objc private func updateAnimationProgress() {
//        animationProgress = animationProgress &+ 50
//        let normalizedProgress = Double(animationProgress) / Double(UInt8.max)
//        
//        storyboardCircularProgress2.set(progress: normalizedProgress, duration: 0.75)
//        storyboardCircularProgress3.set(progress: normalizedProgress, duration: 0.25)
//    }

    
    
        // MARK: - Button
//    func btn_goBack() {
//        self.navigationController?.popViewController(animated: true)
//    }
}

//
//extension dashboardViewController: KYCircularProgressDelegate {
//    func progressChanged(progress: Double, circularProgress: KYCircularProgress) {
//        if circularProgress == storyboardCircularProgress2 {
//            progressLabel2.text = "\(Int(progress * 100.0))%"
//        }
//    }
//}

