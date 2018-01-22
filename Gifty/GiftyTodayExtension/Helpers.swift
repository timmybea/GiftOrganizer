//
//  Helpers.swift
//  GiftyTodayExtension
//
//  Created by Tim Beals on 2018-01-18.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit


let pad: CGFloat = 16
let smallPad: CGFloat = 12

extension UIView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.16
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 2
    }
}

