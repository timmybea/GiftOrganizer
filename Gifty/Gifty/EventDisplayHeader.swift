//
//  EventDisplayHeader.swift
//  Gifty
//
//  Created by Tim Beals on 2017-09-07.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class EventDisplayHeader: UIView {

    private var frameWidth: CGFloat = 0.0
    private let maxHeaderHeight: CGFloat = 88
    private let minHeaderHeight: CGFloat = 0
    
    private var rectForHeaderAppear: CGRect {
        return CGRect(x: 0, y: 0, width: frameWidth, height: maxHeaderHeight)
    }
    
    private var rectForHeaderDisappear: CGRect {
        return CGRect(x: 0, y: 0, width: frameWidth, height: minHeaderHeight)
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["One", "Two", "Three"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Theme.colors.lightToneTwo.color
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    convenience init(with width: CGFloat) {
        self.init()
        setup(with: width)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(with width: CGFloat) {
        
        self.frameWidth = width
        self.frame = self.rectForHeaderAppear
        addSegmentedControl()
        self.frame = self.rectForHeaderDisappear
    }
    
    private func addSegmentedControl() {
        
        addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: smallPad).isActive = true
        segmentedControl.isHidden = true
    }
    
    func setFrame(appear: Bool) {
        if appear {
            self.frame = self.rectForHeaderAppear
        } else {
            self.frame = self.rectForHeaderDisappear
        }
    }
    
    func headerAppear() {
        
        segmentedControl.isHidden = false
    }
    
    func headerDisappear() {
        
        
        segmentedControl.isHidden = true
    }
    
}
