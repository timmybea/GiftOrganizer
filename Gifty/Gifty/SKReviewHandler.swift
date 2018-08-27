//
//  SKReviewHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2018-08-27.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import StoreKit

//MARK: SK Review Handler Delegate
protocol SKReviewHandlerDelegate {
    func reviewUnableToShow()
    func reviewShowed()
}


//MARK: SK Review Handler Protocol
protocol SKReview {
    var delegate: SKReviewHandlerDelegate? { get set }
}


//MARK: SK Review Handler Protocol Extension
extension SKReview {

    func requestReview(in vc: UIViewController) {
        
        guard !CustomPresentationController.isPresenting else {
            self.delegate?.reviewUnableToShow()
            return
        }
        guard  #available(iOS 10.3, *) else {
            self.delegate?.reviewUnableToShow()
            return
        }
        
        SKStoreReviewController.requestReview()
        SettingsHandler.shared.launchCount = 0
        self.delegate?.reviewShowed()
    }
    
    
}

//MARK: STRUCT SK Review Handler Properties
struct SKReviewHandler : SKReview {
    
    var delegate: SKReviewHandlerDelegate?
    
}
