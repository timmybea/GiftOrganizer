//
//  SettingsViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SettingsViewController: CustomViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "Settings"
        self.setTitleLabelPosition(withSize: self.view.bounds.size)
        
        view.addSubview(BackgroundGradient(frame: view.bounds))
    }


}
