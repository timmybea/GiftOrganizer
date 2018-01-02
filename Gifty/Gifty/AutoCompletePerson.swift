//
//  AutoCompletePerson.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class AutoCompletePerson: UIView {

    let profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.defaultProfileBlock.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let autoCompleteTF: AutoCompleteTextField = {
        let textfield = AutoCompleteTextField()
        textfield.font = Theme.fonts.mediumText.font
        textfield.placeholderWith(string: "Person's name", color: UIColor.white)
        textfield.boldTextColor = UIColor.white
        textfield.highlightTextColor = Theme.colors.lightToneOne.color
        return textfield
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupViews() {
        
        addSubview(profileImage)
        profileImage.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2

        addSubview(autoCompleteTF)
        autoCompleteTF.frame = CGRect(x: profileImage.frame.width + pad, y: self.bounds.height / 2 - 11, width: self.bounds.width - profileImage.frame.width - pad, height: 22)
        
        addSubview(whiteView)
        whiteView.frame = CGRect(x: autoCompleteTF.frame.origin.x, y: autoCompleteTF.frame.maxY + 4, width: autoCompleteTF.frame.width, height: 2)
    }
    
    func updateImage(with data: Data?) {
        guard let data = data else { return }
        profileImage.image = UIImage(data: data)
    }
    
    func resetProfileImage() {
        profileImage.image = UIImage(named: ImageNames.defaultProfileBlock.rawValue)
    }
    
}



