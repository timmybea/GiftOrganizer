//
//  ButtonTemplate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol ButtonTemplateDelegate {
    func buttonWasTouched()
}
class ButtonTemplate: UIButton {
    
    let defaultHeight: CGFloat = 35
    
    var delegate: ButtonTemplateDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        self.backgroundColor = Theme.colors.buttonPurple.color
        
        self.layer.cornerRadius = 5
        
        self.addTarget(self, action: #selector(buttonWasTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonWasTouchUpInside), for: .touchUpInside)
    }
    
    func setTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonWasTouchDown() {
//        self.backgroundColor = Theme.colors.lightToneOne.color.cgColor
//        self.layer.borderColor = Theme.colors.lightToneOne.color.cgColor
    }
    
    func addBorder(with color: UIColor) {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }
    
    @objc func buttonWasTouchUpInside() {
        
        //self.layer.borderColor = UIColor.white.cgColor
        if self.delegate != nil {
            self.delegate?.buttonWasTouched()
        }
    }
}
