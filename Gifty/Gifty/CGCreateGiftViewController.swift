//
//  CGCreateGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class CGCreateGiftViewController: CustomViewController {
    
    private var person: Person?
    

    //constants
    private var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    private var navHeight: CGFloat! {
        return navigationController?.navigationBar.frame.height
    }
    
    private let statusHeight = UIApplication.shared.statusBarFrame.height
    
    private var saveButton: ButtonTemplate!
    
    private var scrollViewFrame: CGRect!
    
    //UI Components
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.layer.masksToBounds = false
        sv.backgroundColor = UIColor.blue
        sv.isPagingEnabled = false
        return sv
    }()
    
    lazy var giftNameTF: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.green
        tf.delegate = self
        return tf
    }()
    
    var autoCompletePerson: AutoCompletePerson?
    
    private var budgetView: BudgetView!
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor.gray
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        navigationItem.title = "Create Gift"
        setupSubviews()
    }
    
    private func setupSubviews() {

        //saveButton
        let buttonframe = CGRect(x: pad,
                                 y: view.bounds.height - tabBarHeight - pad - 35,
                                 width: view.bounds.width - pad - pad,
                                 height: 35)
        saveButton = ButtonTemplate(frame: buttonframe)
        saveButton.setTitle("SAVE")
        saveButton.addBorder(with: UIColor.white)
        saveButton.addTarget(self, action: #selector(addGiftToPersonTouched), for: .touchUpInside)
        view.addSubview(saveButton)
        
        //scrollView
        scrollViewFrame = CGRect(x: pad,
                                 y: navHeight + statusHeight + pad,
                                 width: view.bounds.width - pad - pad,
                                 height: view.bounds.height - navHeight - statusHeight - pad - tabBarHeight - pad - 35)
        
        scrollView.frame = scrollViewFrame
        view.addSubview(scrollView)
        
        var contentHeight: CGFloat = 0
        
        //imageView
        let width = (scrollView.frame.width / 3) * 2
        imageView.frame = CGRect(x: scrollView.frame.width / 6, y: 0, width: width, height: width / 2)
        scrollView.addSubview(imageView)
        
        contentHeight += imageView.frame.height
        
        giftNameTF.frame = CGRect(x: 0, y: imageView.frame.maxY + pad, width: scrollView.frame.width, height: 30)
        scrollView.addSubview(giftNameTF)
        
        let tfUnderline = UIView()
        tfUnderline.backgroundColor = UIColor.white
        tfUnderline.frame = CGRect(x: 0, y: giftNameTF.frame.maxY, width: scrollView.frame.width, height: 2)
        scrollView.addSubview(tfUnderline)
        
        contentHeight += giftNameTF.frame.height + pad + 2
        
        //set budget
        let budgetLabel = Theme.createMediumLabel()
        budgetLabel.frame = CGRect(x: 0,
                                   y: tfUnderline.frame.maxY + pad,
                                   width: scrollView.bounds.width,
                                   height: 25)
        budgetLabel.text = "Set Budget"
        scrollView.addSubview(budgetLabel)
        
        //budgetView
        budgetView = BudgetView(frame: CGRect(x: 0,
                                              y: budgetLabel.frame.maxY + pad,
                                              width: scrollView.bounds.width,
                                              height: 60))
        scrollView.addSubview(budgetView)
        
        contentHeight = budgetView.frame.maxY + pad

            //autoCompletePerson
            let personLabel = Theme.createMediumLabel()
            personLabel.frame = CGRect(x: 0,
                                       y: budgetView.frame.maxY + pad,
                                       width: scrollView.bounds.width,
                                       height: 25)
            personLabel.text = "Set Person"
            scrollView.addSubview(personLabel)

            autoCompletePerson = AutoCompletePerson(frame: CGRect(x: 0,
                                                                  y: personLabel.frame.maxY + pad,
                                                                  width: scrollView.bounds.width,
                                                                  height: 100))
            self.autoCompletePerson?.autoCompleteTF.autocompleteDelegate = self
            scrollView.addSubview(autoCompletePerson!)
            contentHeight = autoCompletePerson!.frame.maxY + pad
    }
    
    
    
    @objc
    func handleKeyboardNotification(sender: Notification) {
        
    }
    
    @objc
    func addGiftToPersonTouched() {
        
    }
}


extension CGCreateGiftViewController: AutoCompleteTextFieldDelegate {
   
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

extension CGCreateGiftViewController: UITextFieldDelegate {
    
    
    
    
}
