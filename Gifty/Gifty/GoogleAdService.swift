//
//  GoogleAdService.swift
//  InterstitialAdTest
//
//  Created by Tim Beals on 2018-02-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GoogleMobileAds

protocol GoogleAdServiceDelegate {
    func adWasDismissed()
}

class GoogleAdService: NSObject {
    
    var delegate: GoogleAdServiceDelegate?
    
    var interstitialAd: GADInterstitial?
    
    private var isShowing = false
    
    override init() {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")
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
}

extension GoogleAdService: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        isShowing = false
        self.createAndLoadInterstitial()
        self.delegate?.adWasDismissed()
    }
    
}
