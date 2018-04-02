//
//  TemporaryMessageService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-22.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class AlertService {
    
    static func temporaryMessage(_ message: String, in vc: UIViewController, completion: @escaping() -> ()) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        vc.present(alert, animated: true) {

            let fire = Date(timeInterval: 2.0, since: Date())

            let timer = Timer(fire: fire, interval: 0, repeats: false, block: { (timer) in
                vc.dismiss(animated: true, completion: {
                    completion()
                    timer.invalidate()
                })
            })
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    typealias completionHandler = () -> Void
    static func okAlert(title: String?, message: String?, in vc: UIViewController, completion: completionHandler? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: completion)
    }
}
