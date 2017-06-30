//
//  ButtonTemplate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ButtonTemplate: UIButton {
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(ColorManager.lightText, for: .highlighted)
        self.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        
        self.addTarget(self, action: #selector(buttonWasTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonWasTouchUpInside), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buttonWasTouchDown() {
        self.layer.borderColor = ColorManager.lightText.cgColor
    }
    
    func buttonWasTouchUpInside() {
        self.layer.borderColor = UIColor.white.cgColor
    }
}
