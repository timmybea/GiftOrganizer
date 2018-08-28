//
//  SKReviewHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2018-08-27.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import StoreKit


//MARK: SK Review Handler Protocol
protocol SKReview { }


//MARK: SK Review Handler Protocol Extension
extension SKReview {

    static func isAbleToRequestReview() -> Bool {
        
        guard SettingsHandler.shared.launchCount > 4 else {
            return false
        }
        
        guard checkiOSVersionCompatible() else {
            return false
        }
        
        
        guard notPromptedForReviewThisBundleVersion() else {
            return false
        }
        return true
    }
    
    static func requestReview(in vc: UIViewController) {
        
        guard PopUpManager.shouldShowPopUp(in: vc) else {
            InterstitialService.shared.unableToShow()
            return
        }
        
        SKStoreReviewController.requestReview()
        SettingsHandler.shared.launchCount = 0
        
        //reset the timer so that no ads show while the review is showing
        InterstitialService.shared.adWasDismissed()
        return
    }   
    
    private static func checkiOSVersionCompatible() -> Bool {
        if #available(iOS 10.3, *) {
            return true
        } else {
            return false
        }
    }
    
    private static func notPromptedForReviewThisBundleVersion() -> Bool {
        
        let currentVersion = SettingsHandler.shared.getCurrentBundleVersion()
        let lastVersionPrompted = SettingsHandler.shared.lastVersionPromptedForReview
        
        return currentVersion != lastVersionPrompted
    }
}

//MARK: STRUCT SK Review Handler Properties
struct SKReviewHandler : SKReview {
    
    //var delegate: SKReviewHandlerDelegate?
    
}
