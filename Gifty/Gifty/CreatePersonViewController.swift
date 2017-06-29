//
//  CreatePersonViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-27.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CreatePersonViewController: CustomViewController {

//    var Person: Person!
    
    private let profileImageView: UIView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.profileImagePlaceHolder.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var textFieldTV: PersonTFTableView!
    
    var dropDown: DropDownTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        
        var currMaxX: CGFloat = 0
        var currMaxY: CGFloat = 0
        
        if let navHeight = navigationController?.navigationBar.frame.height {
            currMaxY = navHeight + UIApplication.shared.statusBarFrame.height + pad
            profileImageView.frame = CGRect(x: pad, y: currMaxY, width: 150, height: 150)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        view.addSubview(profileImageView)
        
        currMaxX = pad + profileImageView.frame.width + pad
        
        textFieldTV = PersonTFTableView(frame: CGRect(x: currMaxX, y: currMaxY, width: view.bounds.width - currMaxX - pad, height: profileImageView.bounds.height * 0.6666))
        textFieldTV.backgroundColor = UIColor.clear
        view.addSubview(textFieldTV)
        
        currMaxY += textFieldTV.frame.height
        
        let dropDownFrame = CGRect(x: currMaxX, y: currMaxY, width: view.bounds.width - currMaxX - pad, height: profileImageView.bounds.height * 0.3333)
        dropDown = DropDownTextField(frame: dropDownFrame, title: "Group", options: ["Family", "Friends", "Colleagues"])
        view.addSubview(dropDown)
    }


    
    

}
