//
//  PopUpManager.swift
//  Gifty
//
//  Created by Tim Beals on 2018-08-28.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

protocol PopUpIntelligent {

    static var popUpShowing: Bool { get set }
    
}

extension PopUpIntelligent {
    
    static func shouldShowPopUp(in viewController: UIViewController) -> Bool {
        return popUpShowing == false && viewController.presentedViewController == nil
    }

}

struct PopUpManager : PopUpIntelligent {
    
    static var popUpShowing = false
    
}
