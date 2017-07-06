//
//  CircleView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-06.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
