//
//  CalendarViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit



class CalendarViewController: CustomViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "Calendar"
        self.setTitleLabelPosition(withSize: view.bounds.size)

        
    }
    
    
    
    

    

    //MARK: orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.setTitleLabelPosition(withSize: size)
        
    }
    
}

