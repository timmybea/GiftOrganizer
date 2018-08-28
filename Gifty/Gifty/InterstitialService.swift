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
    
    var failedToShowInterval: TimeInterval = 10.0
    var initialFireInterval: TimeInterval = 60.0
    var fireInterval: TimeInterval = 60.0 * 4
    
    var isSuspended = false
    
    var showInterstitials: Bool {
        get {
            return SettingsHandler.shared.showInterstitials
        }
    }

    private override init() {}
    
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
        if SKReviewHandler.isAbleToRequestReview() {
            SKReviewHandler.requestReview(in: vc)
        } else {
            self.adService.showInterstitial(in: vc)
        }
    }
    
    
    func dispose() {
        self.timer.removeTimerFromRunLoop()
        self.adService.interstitialAd = nil
    }
    
    private func resetWith(timeInterval: TimeInterval) {
        self.timer.removeTimerFromRunLoop()
        self.timer.setupInterstitialTimer(timeInterval: timeInterval)
    }
}

extension InterstitialService: InterstitialTimerDelegate {
    
    func interstitialTimerExecuted() {
        if showInterstitials && !isSuspended {
            self.delegate?.interstitialTimerExecuted()
        }
    }
}

extension InterstitialService: GoogleAdServiceDelegate {
    
    func unableToShow() {
        resetWith(timeInterval: failedToShowInterval)
    }
    
    func adWasDismissed() {
        resetWith(timeInterval: fireInterval)
    }
}
