//
//  PeopleViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PeopleViewController: CustomViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "Another title"
        self.setTitleLabelPosition(withSize: view.bounds.size)
        
        view.addSubview(BackgroundGradient(frame: view.bounds))
    }
    
    
    //MARK: turn off autorotate
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return [.portrait, .landscape]
    }
    
    //MARK: orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
        
    
    
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//    
//        
//    }


}
