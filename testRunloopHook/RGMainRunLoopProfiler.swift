//
//  RGMainRunLoopProfiler.swift
//  testRunloopHook
//
//  Created by Jason Yu on 8/6/16.
//  Copyright © 2016 Ruguo. All rights reserved.
//

import Foundation
import UIKit

class RGMainRunloopProfiler {
    static let sharedInstance = RGMainRunloopProfiler()
    var measureThreshold: CFTimeInterval = 1 // ms
    var afterWaitingTimeStamp: CFTimeInterval?
    
    var beforeWaitingObserver: CFRunLoopObserver?
    var afterWaitingObserver: CFRunLoopObserver?
    
    func start() {
        beforeWaitingObserver = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.BeforeWaiting.rawValue, true, 0, {
            observer, activity in
            if let afterWaitingTS = self.afterWaitingTimeStamp {
                let eTime = (CACurrentMediaTime() - afterWaitingTS) * 1000
                let timeString: String
                if eTime >= self.measureThreshold {
                    timeString = String(format: "%.1fms", eTime)
                    NSLog("elapsed: \(timeString)")
                }
                
                self.afterWaitingTimeStamp = nil
                NSLog("before Waiting")
            }
        })
        
        afterWaitingObserver = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.AfterWaiting.rawValue, true, 0, {
            observer, activity in
            self.afterWaitingTimeStamp = CACurrentMediaTime()
            NSLog("after Waiting")
        })
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), beforeWaitingObserver, kCFRunLoopCommonModes)
        CFRunLoopAddObserver(CFRunLoopGetMain(), afterWaitingObserver, kCFRunLoopCommonModes)
    }
    
    func stop() {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), beforeWaitingObserver, kCFRunLoopCommonModes)
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), afterWaitingObserver, kCFRunLoopCommonModes)
    }
}
