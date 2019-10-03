//
//  ViewController.swift
//  TimerApp
//
//  Created by Arun on 5/2/17.
//  Copyright © 2017 Arun. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stopWatchLbl: UILabel!
    var timer = Timer()
    var hrs = 0
    var min = 0
    var sec = 0
    var milliSecs = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var diffMilliSecs = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        print(sec)
    }
    
    @IBAction func startBtnPressed(_ sender: UIButton) {
        self.resetContent()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(ViewController.updateLabels(t:))), userInfo: nil, repeats: true)
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        self.resetContent()
    }
    
    @IBAction func pauseBtnPressed(_ sender: UIButton) {
        self.timer.invalidate()
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: savedDate)
            
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
        }
    }
    
    func resetContent() {
        self.removeSavedDate()
        timer.invalidate()
        self.stopWatchLbl.text = "00 : 00 : 00 : 00"
        self.milliSecs = 0
        self.sec = 0
        self.min = 0
        self.hrs = 0
    }
    
    @objc func updateLabels(t: Timer) {
        if(self.milliSecs >= 59) {
            self.sec += 1
            self.milliSecs = 0
            if (self.sec >= 60) {
                self.min += self.sec/60
                self.sec = self.sec % 60
                if (self.min >= 60) {
                    self.hrs += self.min/60
                    self.min = self.min % 60
                }
            }
        } else {
            self.milliSecs += 1
        }
        self.stopWatchLbl.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
        
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        //self.hrs += hours
        //self.min += mins
        //self.sec += secs
        var minutes = self.min
        
        if (secs >= 60) {
            minutes += mins + secs/60
            self.sec = secs % 60
        } else {
            self.sec = secs
            minutes += mins
        }
        
        if (minutes >= 60) {
            self.hrs = hours + minutes/60
            self.min = minutes % 60
        } else {
            self.min = minutes
        }
        self.stopWatchLbl.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
        print("sec",self.sec)
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(ViewController.updateLabels(t:))), userInfo: nil, repeats: true)
        
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
