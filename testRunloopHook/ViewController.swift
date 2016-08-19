//
//  ViewController.swift
//  testRunloopHook
//
//  Created by Jason Yu on 8/5/16.
//  Copyright © 2016 Ruguo. All rights reserved.
//

import UIKit
import Foundation
import YYWebImage

let jasonRunloopMode = "JasonMode"

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addGif()

//        RGMainRunloopProfiler.sharedInstance.measureThreshold = 10
//        RGMainRunloopProfiler.sharedInstance.start()
    }
    
    func addGif() {
        let imageView = YYAnimatedImageView()
        imageView.yy_imageURL = NSURL(string: "http://cdn.ruguoapp.com/o_1aq8lscm6s3m1tfjkfiloruhi2.gif")
        
        imageView.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        scrollView.addSubview(imageView)
        
        //        imageView.runloopMode = NSDefaultRunLoopMode
        imageView.runloopMode = NSRunLoopCommonModes
    }
    
    @IBAction func tappedAddTimer(sender: AnyObject) {
        self.addTimer()
    }
    
    func addTimer() {
        let timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.timerFired), userInfo: nil, repeats: true)
        
        // set which mode this timer is related to, so callback would be invoked only under that mode.
//        let mode = NSDefaultRunLoopMode
//        let mode = UITrackingRunLoopMode
//        let mode = NSRunLoopCommonModes
        let mode = jasonRunloopMode
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: mode)
        
        // switch mode
        NSRunLoop.currentRunLoop().runMode(jasonRunloopMode, beforeDate: NSDate(timeIntervalSinceNow: 10))
    }
    
    var fakeCounter = 0
    func doNothing() {
        fakeCounter += 1
    }
    
    func timerFired() {
        self.counter += 1
        let mode = NSRunLoop.currentRunLoop().currentMode ?? ""
        print("current runloop mode: \(mode) counter: \(self.counter)")
    }

    var a: Double = 3
    @IBAction func didTap(sender: AnyObject) {
        NSLog("didTap")
        for _ in 0...100000000 {
            self.a = sin(30)
        }
        NSLog("done")
    }

}

