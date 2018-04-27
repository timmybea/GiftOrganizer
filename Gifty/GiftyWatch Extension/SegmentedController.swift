//
//  class SegmentedController {.swift
//  GiftyWatch Extension
//
//  Created by Tim Beals on 2018-04-24.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

protocol SegmentedControllerDelegate {
    func indexChanged(_ index: Int)
}


class SegmentedController {
    
    var delegate: SegmentedControllerDelegate?
    
    private var index: Int = 0 {
        didSet {
            self.delegate?.indexChanged(index)
        }
    }
    
    func buttonWasTouched(index: Int) {
        self.index = index
    }
    
}
