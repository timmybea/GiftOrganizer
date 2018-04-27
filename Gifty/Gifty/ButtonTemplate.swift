//
//  ButtonTemplate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

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
        self.backgroundColor = Theme.colors.lightToneTwo.color
        
        self.layer.cornerRadius = 5
        
        self.addTarget(self, action: #selector(buttonWasTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonWasTouchUpInside), for: .touchUpInside)
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonWasTouchDown() {

    }
    
    func addBorder(with color: UIColor) {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }
    
    @objc func buttonWasTouchUpInside() {
    
        if self.delegate != nil {
            self.delegate?.buttonWasTouched()
        }
    }
}
