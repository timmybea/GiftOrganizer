//
//  ActionsSelector.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-14.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol ActionsSelectorViewDelegate {
    func addGiftChanged(bool: Bool)
    func addCardChanged(bool: Bool)
    func addPhoneChanged(bool: Bool)
}

class ActionsSelectorView: UIView {
    
    var delegate: ActionsSelectorViewDelegate?
    
    let actionsLabel: UILabel = {
        let actions = UILabel()
        actions.textColor = UIColor.white
        actions.font = FontManager.subtitleText
        actions.textAlignment = .left
        actions.text = "Actions:"
        actions.translatesAutoresizingMaskIntoConstraints = false
        return actions
    }()
    
    var addGiftImageControl: CustomImageControl!
    var addCardImageControl: CustomImageControl!
    var addPhoneImageControl: CustomImageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        //self.backgroundColor = UIColor.green
        
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func addSubviews() {
        self.addSubview(actionsLabel)
        actionsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        actionsLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        let imageSize: CGFloat = 45
        let quarterView: CGFloat = self.bounds.width / 4
        
        let imageNames: [ImageNames] = [ImageNames.addGift, ImageNames.addGreetingCard, ImageNames.addPhoneCall]
        var imageControls = [CustomImageControl]()
        
        for (index, name) in imageNames.enumerated() {
            
            let imageControl = CustomImageControl()
            imageControl.translatesAutoresizingMaskIntoConstraints = false
            imageControl.imageView.image = UIImage(named: name.rawValue)?.withRenderingMode(.alwaysTemplate)
            imageControl.imageView.contentMode = .scaleAspectFit
            imageControl.imageView.tintColor = ColorManager.lightText
            
            self.addSubview(imageControl)
            imageControl.topAnchor.constraint(equalTo: actionsLabel.bottomAnchor, constant: pad).isActive = true
            
            let constant = (CGFloat(index + 1) * quarterView) - (imageSize / 2)
            imageControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constant).isActive = true
            imageControl.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
            imageControl.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
            
            imageControls.append(imageControl)
        }
        
        self.addGiftImageControl = imageControls[0]
        self.addCardImageControl = imageControls[1]
        self.addPhoneImageControl = imageControls[2]
        
        addGiftImageControl.addTarget(self, action: #selector(addGiftTouched), for: .touchUpInside)
        addCardImageControl.addTarget(self, action: #selector(addCardTouched), for: .touchUpInside)
        addPhoneImageControl.addTarget(self, action: #selector(addPhoneTouched), for: .touchUpInside)
    }
    
    //MARK: IMAGE CONTROL METHODS
    func addGiftTouched() {
        addGiftImageControl.imageView.tintColor = addGiftImageControl.isImageSelected ? ColorManager.lightText : UIColor.white
        addGiftImageControl.isImageSelected = !addGiftImageControl.isImageSelected
        if delegate != nil {
            delegate?.addGiftChanged(bool: addGiftImageControl.isImageSelected)
        }
    }
    
    func addCardTouched() {
        addCardImageControl.imageView.tintColor = addCardImageControl.isImageSelected ? ColorManager.lightText : UIColor.white
        addCardImageControl.isImageSelected = !addCardImageControl.isImageSelected
        if delegate != nil {
            delegate?.addCardChanged(bool: addCardImageControl.isImageSelected)
        }
    }
    
    func addPhoneTouched() {
        addPhoneImageControl.imageView.tintColor = addPhoneImageControl.isImageSelected ? ColorManager.lightText : UIColor.white
        addPhoneImageControl.isImageSelected = !addPhoneImageControl.isImageSelected
        if delegate != nil {
            delegate?.addPhoneChanged(bool: addPhoneImageControl.isImageSelected)
        }
    }
}
