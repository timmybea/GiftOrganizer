//
//  SelectGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-20.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class SelectGiftViewController: CustomViewController {

    var person: Person? = nil {
        didSet {
            printAllGifts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Gift"
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTouched(sender:)))
        
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    private func printAllGifts() {
        guard let p = self.person else { return }
        guard let gifts = p.gift?.allObjects as? [Gift] else { return }
        
        for gift in gifts {
            print(gift.name!)
        }
    }
    
    @objc
    func backButtonTouched(sender: UIButton) {
        
        print("Back button touched")
        navigationController?.popViewController(animated: true)
    }

}
