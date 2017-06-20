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
        
        self.backgroundView = BackgroundGradient(frame: view.bounds)
        view.addSubview(self.backgroundView)
        
        
    }


    //MARK: orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if backgroundView != nil {
            self.backgroundView.resize(size)
            self.backgroundView.frame.origin = CGPoint(x: 0, y: 0)
        }
        self.setTitleLabelPosition(withSize: size)
    }
    

    
}
