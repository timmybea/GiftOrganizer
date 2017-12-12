//
//  CustomTableViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-11.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CustomTableViewController: CustomViewController {

//    var tableView: UITableView = {
//        let tv = UITableView()
//        return tv
//    }()
    
    var inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.colors.buttonPurple.color
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        tf.placeholder = "Enter gift idea"
        return tf
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTouchView))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
        setupSubviews()
        
        
    }
    
    func setupSubviews() {
        
        view.addSubview(inputContainerView)
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bottomConstraint = NSLayoutConstraint(item: inputContainerView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: -tabBarHeight)
        bottomConstraint?.isActive = true
        
        inputContainerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: pad).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -pad).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        
        

        
        
    }

    
    @objc
    func handleKeyboardNotification(sender: NSNotification) {
        print("Keyboard will show")
        
        if let userInfo = sender.userInfo {
            guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            let showBottomConst = CGFloat(keyboardFrame.height)
            
            let showKeyboard = sender.name == Notification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = showKeyboard ? -showBottomConst : -tabBarHeight
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                
            })
        }
    }
    
    @objc
    func didTouchView() {
        
        print("Detected touches")

        self.inputTextField.endEditing(true)
        
    }
}

extension CustomTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
    
    
}
