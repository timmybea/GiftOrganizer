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
        let imageView = UIImageView(image: UIImage(named: ImageNames.profileImagePlaceHolder.rawValue))
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
        
        autoCompleteTF.autocompleteDelegate = self
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
        autoCompleteTF.frame = CGRect(x: profileImage.frame.width + pad, y: self.bounds.height - 20, width: self.bounds.width - profileImage.frame.width - pad, height: 22)
        
        addSubview(whiteView)
        whiteView.frame = CGRect(x: autoCompleteTF.frame.origin.x, y: self.bounds.height - 2, width: autoCompleteTF.frame.width, height: 2)
    }
}

extension AutoCompletePerson: AutoCompleteTextFieldDelegate {
    
    func provideDatasource() {
        //provide complete list of person names
        guard let allPeople = PersonFRC.frc(byGroup: false)?.fetchedObjects else { return }
        var nameArray = [String]()
        for person in allPeople {
            nameArray.append(person.fullName!)
        }
        autoCompleteTF.datasource = nameArray
    }
    
    
    func returned(with selection: String) {

        print("SELECTED: \(selection)")
        
    }
    
}




