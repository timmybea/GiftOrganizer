//
//  returnContainerView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-16.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol ReturnContainerViewDelegate {
    func buttonTouched(save: Bool)
}

class ReturnContainerView: UIView {
    
    var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Return", for: .normal)
        button.setTitleColor(Theme.colors.lightToneTwo.color, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()

    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.colors.lightToneTwo.color, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        return button
    }()
    
    var delegate: ReturnContainerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        returnButton.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
        
        self.backgroundColor = Theme.colors.offWhite.color
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let separatorView = UIView()
        separatorView.backgroundColor = Theme.colors.lightToneOne.color
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.addSubview(returnButton)
        returnButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        returnButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        returnButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.33).isActive = true
        
        self.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.33).isActive = true
    }
    
    @objc
    func buttonTouched(sender: UIButton) {
        if sender.tag == 1 {
            //print("return button touched")
            self.delegate?.buttonTouched(save: true)
            
        } else if sender.tag == 2 {
            //print("cancel button touched")
            self.delegate?.buttonTouched(save: false)
        
        }
    }
}
