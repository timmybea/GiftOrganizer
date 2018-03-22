//
//  TabBar+PreviousIndex.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-22.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    static var previousIndex: Int = 0
    
    static var currentIndex: Int = 0 {
        didSet {
            previousIndex = oldValue
        }
    }
}
