//
//  RestingViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/10.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import CircleProgressView

class RestingViewController: UIViewController {
    
    @IBOutlet weak var restTimeLabel: UILabel!
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var circleProgressView: CircleProgressView!
    
    
    var timer = Timer()
    
    var totalTime = 10
    var secondsPassed = 0
    
    var miliSecond = 0.0
    let updateUnit = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundView.layer.cornerRadius = 10
        restTimeLabel.text = getTimeText(second: totalTime)
        timer = Timer.scheduledTimer(timeInterval: updateUnit, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if secondsPassed >= totalTime {
            timer.invalidate()
            self.view.removeFromSuperview()
            return
        }
        let progress = 1.0 - ((Double(secondsPassed) + miliSecond) / Double(totalTime))
        circleProgressView.progress = progress
        if miliSecond >= 1.0 {
            if secondsPassed < totalTime {
                secondsPassed += 1
                restTimeLabel.text = getTimeText(second: totalTime - secondsPassed)
            }
            miliSecond = 0
        }
        miliSecond += updateUnit
    }
    
    
    func getTimeText(second: Int) -> String{
        if second > 60 {
            let min = Int(second / 60)
            let sec = second % 60
            return String(format: "%d:%02d", min , sec)
        }
        
        return String(second)
    }
    
    
    @IBAction func skipRestButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        // self.view.isHidden = true
        self.view.removeFromSuperview()
    }
    
    @IBAction func restingTimeModifyButtonPressed(_ sender: UIButton) {
        if let id = sender.restorationIdentifier {
            if id == "minus" {
                totalTime -= 10
            }else if id == "plus"{
                totalTime += 10
            }
        }
    }
    
}
