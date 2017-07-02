//
//  CreateEventViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-02.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CreateEventViewController: CustomViewController {

    var celebrationType: String = ""
    
    
    var dropDown: DropDownTextField!
    
    var addGiftImageControl: CustomImageControl!
    var addCardImageControl: CustomImageControl!
    var addPhoneImageControl: CustomImageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()
    }
    
    func layoutSubviews() {
        
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground)))
        
        var currMaxX: CGFloat = 0
        var currMaxY: CGFloat = 0
        
        if let navHeight = navigationController?.navigationBar.frame.height {
            currMaxY = navHeight + UIApplication.shared.statusBarFrame.height + pad
            let frame = CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 40)
            let options = ["Birthday", "Graduation", "Wedding", "Baby Shower"]
            dropDown = DropDownTextField(frame: frame, title: "Celebration Type", options: options)
            dropDown.delegate = self
            view.addSubview(dropDown)
        }
        
        currMaxY += 40 + pad
        let actions = UILabel(frame: CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 40))
        actions.textColor = UIColor.white
        actions.font = FontManager.subtitleText
        actions.text = "Actions"
        view.addSubview(actions)
        
        currMaxY += actions.frame.height + pad
        let oneFourthViewWidth = view.bounds.width / 4
        let size: CGFloat = 60

        addGiftImageControl = CustomImageControl(frame: CGRect(x: oneFourthViewWidth - (size / 2), y: currMaxY, width: size, height: size))
        addGiftImageControl.imageView.image = UIImage(named: ImageNames.addGift.rawValue)?.withRenderingMode(.alwaysTemplate)
        addGiftImageControl.imageView.contentMode = .scaleAspectFit
        addGiftImageControl.imageView.tintColor = ColorManager.lightText
        view.addSubview(addGiftImageControl)
        
        addCardImageControl = CustomImageControl(frame: CGRect(x: (2 * oneFourthViewWidth) - (size / 2), y: currMaxY, width: size, height: size))
        addCardImageControl.imageView.image = UIImage(named: ImageNames.addGreetingCard.rawValue)?.withRenderingMode(.alwaysTemplate)
        addCardImageControl.imageView.contentMode = .scaleAspectFit
        addCardImageControl.tintColor = ColorManager.lightText
        view.addSubview(addCardImageControl)
        
        addPhoneImageControl = CustomImageControl(frame: CGRect(x: (3 * oneFourthViewWidth) - (size / 2), y: currMaxY, width: size, height: size))
        addPhoneImageControl.imageView.image = UIImage(named: ImageNames.addPhoneCall.rawValue)?.withRenderingMode(.alwaysTemplate)
        addPhoneImageControl.imageView.contentMode = .scaleAspectFit
        addPhoneImageControl.tintColor = ColorManager.lightText
        view.addSubview(addPhoneImageControl)
        
    }
    
    func didTapBackground() {
        
    }
}


extension CreateEventViewController: DropDownTextFieldDelegate {
    
    func dropDownWillAnimate(down: Bool) {
        if down {
            view.bringSubview(toFront: dropDown)
        } else {
            view.insertSubview(dropDown, aboveSubview: backgroundView)
        }
    }
    
    func optionSelected(option: String) {
        self.celebrationType = option
        print(celebrationType)
    }
}
