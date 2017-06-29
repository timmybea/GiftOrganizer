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

    var firstName = ""
    var lastName = ""
    var group = ""
    
    private let profileImageView: UIView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.profileImagePlaceHolder.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var textFieldTV: PersonTFTableView!
    
    fileprivate var dropDown: DropDownTextField!
    
    //MARK: TEST<<<<<<<<
    private var testView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(tapGesture)
        
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
        textFieldTV.delegate = self
        view.addSubview(textFieldTV)
        
        currMaxY += textFieldTV.frame.height
        
        let dropDownFrame = CGRect(x: currMaxX, y: currMaxY, width: view.bounds.width - currMaxX - pad, height: profileImageView.bounds.height * 0.3333)
        dropDown = DropDownTextField(frame: dropDownFrame, title: "Group", options: ["Family", "Friends", "Colleagues"])
        dropDown.delegate = self
        view.addSubview(dropDown)
        
        //MARK: TEST<<<<<<<<
        currMaxY += profileImageView.bounds.height * 0.3333 + pad
        testView.frame = CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: view.bounds.height - pad - currMaxY)
        let testViewtapGesture = UITapGestureRecognizer(target: self, action: #selector(testViewTapped))
        testView.addGestureRecognizer(testViewtapGesture)
        view.addSubview(testView)
    }

    func backgroundTapped() {
        textFieldTV.finishEditing()
        dropDown.finishEditingTextField()
    }
    
    func testViewTapped() {
        print("test view tapped")
        textFieldTV.finishEditing()
        dropDown.finishEditingTextField()
    }
}

extension CreatePersonViewController: DropDownTextFieldDelegate {
    func dropDownWillAnimate(down: Bool) {
        if down {
            view.bringSubview(toFront: dropDown)
        } else {
            view.insertSubview(dropDown, aboveSubview: backgroundView)
        }
    }
    
    func optionSelected(option: String) {
        self.group = option
        print("updated group in vc to \(group)")
    }
}

extension CreatePersonViewController: PersonTFTableViewDelegate {
    func didUpdateFirstName(string: String) {
        self.firstName = string
        print("updated first name in vc to \(firstName)")
    }
    
    func didUpdateLastName(string: String) {
        self.lastName = string
        print("updated last name in vc to \(lastName)")
    }
}
