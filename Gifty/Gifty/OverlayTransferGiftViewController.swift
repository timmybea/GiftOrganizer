//
//  OverlayTransferGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class OverlayTransferGiftViewController: UIViewController {

    var person: Person?
    var gift: Gift?
    
    let bgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageNames.horizontalBGGradient.rawValue))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.addTarget(self, action: #selector(okButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = Theme.fonts.subtitleText.font
        label.text = "Copy Gift To"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var autoCompletePerson: AutoCompletePerson!
    
    var sameNameWarning = false
    
    var normalOriginX: CGFloat = 0.0
    let raisedOriginX: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 220)
        self.normalOriginX = self.view.frame.origin.x
        print(normalOriginX)
        self.view.layer.cornerRadius = 8.0
        self.view.layer.masksToBounds = true
        
        layoutSubviews()
    }
    
    private func layoutSubviews() {
     
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        view.addSubview(headingLabel)
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: pad),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 0
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        
        view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackview.heightAnchor.constraint(equalToConstant: 30.0),
            stackview.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackview.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        stackview.addArrangedSubview(cancelButton)
        stackview.addArrangedSubview(okButton)
        
        autoCompletePerson = AutoCompletePerson(frame: CGRect(x: pad,
                                                              y: view.bounds.size.height / 2.0 - 50.0,
                                                              width: view.bounds.size.width - pad - pad,
                                                              height: 100))
        autoCompletePerson.autoCompleteTF.autocompleteDelegate = self
        view.addSubview(autoCompletePerson)
        
    }
    
    @objc
    func okButtonTouched(sender: UIButton) {
        print("ok button touched")
        
        guard let p = self.person else {
            AlertService.okAlert(title: "No person selected",
                                message: "please type a name into the field",
                                in: self)
            return
        }
        
        if p.fullName == self.gift?.person?.fullName {
            if sameNameWarning == false {
                AlertService.okAlert(title: "Are you sure?",
                                     message: "Would you really like to get this person the same gift twice?",
                                     in: self)
                sameNameWarning = true
                return
            }
        }
        
        if let g = self.gift {
            let gb = GiftBuilder.copyGift(g, to: p)
            gb.saveGiftToCoreData(DataPersistenceService.shared)
            AlertService.temporaryMessage("Copied gift", in: self, completion: {
                //do nothing
            })
        }
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    
    }
    
    @objc
    func cancelButtonTouched(sender: UIButton) {
        print("Cancel button touched")
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc
    func handleKeyboardNotification(sender: NSNotification) {
        
        print("Keyboard will show")
        
        if let userInfo = sender.userInfo {
            guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
//            let showBottomConst = CGFloat(keyboardFrame.height)
//
//            let showKeyboard = sender.name == Notification.Name.UIKeyboardWillShow
//
//            bottomConstraint?.constant = showKeyboard ? -showBottomConst : -tabBarHeight
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                
            })
        }
    }
    
}

extension OverlayTransferGiftViewController : AutoCompleteTextFieldDelegate {
    
    func provideDatasource() {
        //provide complete list of person names
        guard let allPeople = PersonFRC.frc(byGroup: false)?.fetchedObjects else { return }
        
        var nameArray = [String]()
        for person in allPeople {
            nameArray.append(person.fullName!)
        }
        autoCompletePerson?.autoCompleteTF.datasource = nameArray
    }
    
    
    func returned(with selection: String) {
        print("SELECTED: \(selection)")
        self.person = PersonFRC.person(with: selection)
        if self.person != nil {
            autoCompletePerson?.updateImage(with: person!.profileImage)
        }
    }
    
    func textFieldCleared() {
        autoCompletePerson?.resetProfileImage()
        person = nil
    }
    
}
