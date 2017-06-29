//
//  CreatePersonViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-27.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CreatePersonViewController: CustomViewController {

//    var Person: Person!

    var firstName = ""
    var lastName = ""
    var group = ""
    var dob: DateComponents?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.profileImagePlaceHolder.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView)))
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var textFieldTV: PersonTFTableView!
    
    var dropDown: DropDownTextField!
    
    lazy var addFromContactLabel: UILabel = {
        var label = UILabel()
        label.text = "+ add from contacts"
        label.textAlignment = .center
        label.font = FontManager.mediumText
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddFromContactsLabel)))
        return label
    }()
    
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
        
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView)))
        
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

        currMaxY += profileImageView.bounds.height * 0.3333 + pad
        view.addSubview(addFromContactLabel)
        addFromContactLabel.frame = CGRect(x: pad, y: currMaxY, width: 150, height: 17)
        
        //MARK: TEST<<<<<<<<
        currMaxY += addFromContactLabel.frame.height + pad
        testView.frame = CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: view.bounds.height - pad - currMaxY)
        let testViewtapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTestView))
        testView.addGestureRecognizer(testViewtapGesture)
        view.addSubview(testView)
    }

    func didTapBackgroundView() {
        textFieldTV.finishEditing()
        dropDown.finishEditingTextField()
    }
    
    func didTapTestView() {
        textFieldTV.finishEditing()
        dropDown.finishEditingTextField()
    }
    

}

//
extension CreatePersonViewController {
    
    func didTapAddFromContactsLabel() {
        
        print("add from contacts")
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == .notDetermined {
            
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, error) in
                if success {
                    self.launchContacts()
                }
            })
        } else if authStatus == .authorized {
            self.launchContacts()
        }
    }
    
    func launchContacts() {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
}


//MARK: ContactPicker delegate methods
extension CreatePersonViewController: CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        if contact.imageDataAvailable {
            let imageData = contact.imageData
            let image = UIImage(data: imageData!)
            profileImageView.image = image
        }
        textFieldTV.updateWith(firstName: contact.givenName, lastName: contact.familyName)
        dismiss(animated: true) { 
            if let dob = contact.birthday {
                let alertController = UIAlertController(title: "Create Birthday?", message: "Your contact has a birth date stored in it. Would you like to create a birthday event for them?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    print("Create new event for birth date \(dob)")
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


//MARK: ImagePicker delegate methods
extension CreatePersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func didTapProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("did cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            self.profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: DropDown delegate methods
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

//MARK: TextFieldTableView delegate methods
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
