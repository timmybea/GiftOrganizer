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
    
    lazy var profileImageView: CustomImageControl = {
        let imageControl = CustomImageControl()
        imageControl.imageView.image = UIImage(named: ImageNames.profileImagePlaceHolder.rawValue)
        imageControl.imageView.contentMode = .scaleAspectFill
        imageControl.addTarget(self, action: #selector(profileImageTouchDown), for: .touchDown)
        imageControl.addTarget(self, action: #selector(profileImageTouchUpInside), for: .touchUpInside)
        imageControl.layer.masksToBounds = true
        return imageControl
    }()
    
    var textFieldTV: PersonTFTableView!
    
    var dropDown: DropDownTextField!
    
    lazy var addFromContactLabel: ButtonTemplate = {
        var button = ButtonTemplate(frame: .zero, title: "+ add from contacts")
        button.titleLabel?.font = FontManager.mediumText
        button.addTarget(self, action: #selector(didTapAddFromContactsLabel), for: .touchUpInside)
        button.layer.borderWidth = 0
        return button
    }()
    
    var saveButton: ButtonTemplate!

    var eventCollectionView: EventCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Person"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
        
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
        
        let buttonframe = CGRect(x: pad, y: view.bounds.height - tabBarHeight - pad - 35, width: view.bounds.width - pad - pad, height: 35)
        saveButton = ButtonTemplate(frame: buttonframe, title: "SAVE")
        saveButton.delegate = self
        view.addSubview(saveButton)
        
        currMaxY += addFromContactLabel.frame.height + pad
        let eventHeight = view.bounds.height - currMaxY - tabBarHeight - pad - saveButton.frame.height - pad
        eventCollectionView = EventCollectionView(frame: CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: eventHeight))
        eventCollectionView.delegate = self
        view.addSubview(eventCollectionView)
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
            profileImageView.imageView.image = image
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
    
    func profileImageTouchDown() {
        if self.profileImageView.isImageSelected == false {
            self.profileImageView.imageView.image = UIImage(named: ImageNames.profileImagePlaceHolderTouched.rawValue)
        }
    }
    
    func profileImageTouchUpInside() {
        
        if self.profileImageView.isImageSelected == false {
            self.profileImageView.imageView.image = UIImage(named: ImageNames.profileImagePlaceHolder.rawValue)
        }
        
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
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            let scaledImage = UIImage.scaleImage(image: selectedImage!, toWidth: profileImageView.frame.width, andHeight: profileImageView.frame.height)
            self.profileImageView.imageView.image = scaledImage
            self.profileImageView.isImageSelected = true
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

//MARK: EventCollectionView delegate methods
extension CreatePersonViewController: EventCollectionViewDelegate {
    
    func didTouchAddEventButton() {
        print("Add new event!")
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(CreateEventViewController(), animated: true)
        }
    }
}

//MARK: SAVE BUTTON
extension CreatePersonViewController: ButtonTemplateDelegate {
    
    func buttonWasTouched() {
        
        print("Save touched")
        
        //Create new person
        guard firstName != "" else {
            //create alert controller
            return
        }
        
        guard group != "" else {
            //create alert controller
            return
        }

        var profileImage: UIImage?
        if profileImageView.isImageSelected {
            profileImage = profileImageView.imageView.image
        }
        
        ManagedObjectBuilder.createPerson(firstName: firstName, lastName: lastName, group: group, profileImage: profileImage) { (success, person) in
            
            ManagedObjectBuilder.saveChanges(completion: { (success) in
                print("successfully saved")
                self.navigationController?.popViewController(animated: true)
//                self.navigationController?.dismiss(animated: true, completion: {
//                    //
//                })
            })
        }
        
        
        
        
        
    }
    
}
