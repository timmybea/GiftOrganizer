//
//  SettingsViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SettingsViewController: CustomViewController {
    
    @IBOutlet var budgetTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        view.sendSubview(toBack: self.backgroundView)
        
        budgetTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTouched(sender:)))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func scrollViewTouched(sender: UITapGestureRecognizer) {
        if budgetTextField.isEditing {
            //budgetTextField.resignFirstResponder()
            budgetTextField.endEditing(true)
        }
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            //budgetTextfield
            textField.text = "$"
        }
        return true
    }
    
}

