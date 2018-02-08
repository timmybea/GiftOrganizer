//
//  InterstitialService.swift
//  InterstitialAdTest
//
//  Created by Tim Beals on 2018-02-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GoogleMobileAds

class InterstitialService: NSObject {
    
    var interstitialAd: GADInterstitial?
    var isShowing = false
    
    private override init() {}
    
    struct Static {
        fileprivate static var instance: InterstitialService?
    }
    
    static var shared: InterstitialService {
        if Static.instance == nil {
            Static.instance = InterstitialService()
        }
        return Static.instance!
    }
    
    func createAndLoadInterstitial() {
        
        let request = GADRequest()
        //test device - window/devices/identifier
        request.testDevices = [kGADSimulatorID]
        
        //you need to create an adMob account and register the app
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(request)
        self.interstitialAd = interstitial
    }
    
    func showInterstitial(in vc: UIViewController) {
        if let interstitial = self.interstitialAd {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: vc)
                isShowing = true
            }
        }
    }
    
    func dispose() {
        Static.instance = nil
    }
}

extension InterstitialService: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        isShowing = false
        createAndLoadInterstitial()
    }
    
}
