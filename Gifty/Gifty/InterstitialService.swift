//
//  InterstitialService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-08.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

protocol InterstitialServiceDelegate {
    func interstitialTimerExecuted()
}

class InterstitialService: NSObject {

    var delegate: InterstitialServiceDelegate?
    
    var initialFireInterval: TimeInterval = 30.0
    var fireInterval: TimeInterval = 60.0 * 3
    
    var showInterstitials: Bool {
        return SettingsHandler.shared.showInterstitials
    }

    private override init() {
    }
    
    private struct Static {
        fileprivate static var instance: InterstitialService?
    }
    
    static var shared: InterstitialService {
        if Static.instance == nil {
            Static.instance = InterstitialService()
        }
        return Static.instance!
    }
    
    private lazy var adService: GoogleAdService = {
        let gAd = GoogleAdService()
        gAd.delegate = self
        return gAd
    }()
    
    private lazy var timer: InterstitialTimer = {
        let t = InterstitialTimer()
        t.delegate = self
        return t
    }()
    
    
    func createAndLoadInterstitial() {
        self.adService.createAndLoadInterstitial()
    }
    
    func setupTimer() {
        self.timer.setupInterstitialTimer(timeInterval: initialFireInterval)
    }
    
    func showInterstitial(in vc: UIViewController) {
        self.adService.showInterstitial(in: vc)
    }
    
    
    func dispose() {
        self.timer.removeTimerFromRunLoop()
        self.adService.interstitialAd = nil
    }
}

extension InterstitialService: InterstitialTimerDelegate {
    
    func interstitialTimerExecuted() {
        if showInterstitials {
            self.delegate?.interstitialTimerExecuted()
        }
    }
}

extension InterstitialService: GoogleAdServiceDelegate {
    
    func adWasDismissed() {
        self.timer.removeTimerFromRunLoop()
        self.timer.setupInterstitialTimer(timeInterval: initialFireInterval)
    }
}
