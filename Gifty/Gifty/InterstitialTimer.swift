//
//  ScheduledTimer.swift
//  InterstitialAdTest
//
//  Created by Tim Beals on 2018-02-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation


protocol InterstitialTimerDelegate {
    func interstitialTimerExecuted()
}

class InterstitialTimer: NSObject {
    
    private override init() { }
    
    private struct Static {
        static var instance: InterstitialTimer?
    }
    
    static var shared: InterstitialTimer {
        if Static.instance == nil {
            Static.instance = InterstitialTimer()
        }
        return Static.instance!
    }

    
    var delegate: InterstitialTimerDelegate?
    
    var initialFireInterval: TimeInterval = 30.0
    var fireInterval: TimeInterval = 60.0 * 3
    
    var showInterstitials: Bool = SettingsHandler.shared.showInterstitials
    
    private var timer: Timer?
    
    func setupInterstitialTimer() {
        
            self.timer = Timer(fireAt: Date(timeInterval: initialFireInterval, since: Date()), interval: 30.0, target: self, selector: #selector(execute), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc
    func execute() {
        print("Scheduled Timer: Execute")
        
        if showInterstitials {
            self.delegate?.interstitialTimerExecuted()
        } else {
            self.dispose()
            InterstitialService.shared.dispose()
        }
        
    }
    
    
    func dispose() {
        self.timer?.invalidate()
        InterstitialTimer.Static.instance = nil
    }
    
}
