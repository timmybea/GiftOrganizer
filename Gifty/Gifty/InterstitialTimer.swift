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
    
    var delegate: InterstitialTimerDelegate?
    
    var showInterstitials: Bool = SettingsHandler.shared.showInterstitials
    
    private var timer: Timer?
    
    func setupInterstitialTimer(timeInterval: TimeInterval) {
            self.timer = Timer(fireAt: Date(timeInterval: timeInterval, since: Date()), interval: 0.0, target: self, selector: #selector(execute), userInfo: nil, repeats: false)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func removeTimerFromRunLoop() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc
    func execute() {
        print("Scheduled Timer: Execute")
        
        if showInterstitials {
            self.delegate?.interstitialTimerExecuted()
        }
    }
}
