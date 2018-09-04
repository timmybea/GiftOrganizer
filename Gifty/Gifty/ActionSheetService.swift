//
//  ActionSheetService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-23.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class ActionSheetService {
    
    static func actionSheet(with options: [String], presentedIn vc: UIViewController, completion: @escaping(String) -> ()) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for o in options {
            let action = UIAlertAction(title: o, style: .default, handler: { (action) in
                completion(o)
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
}
