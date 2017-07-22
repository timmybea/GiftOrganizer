//
//  BudgetView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class BudgetView: UIView {


    let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Budget: $"
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = Theme.fonts.mediumText.font
        return label
    }()
    
    let budgetTF: UITextField = {
        let textField = UITextField()
       // textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        //textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        textField.keyboardType = .phonePad
        return textField
    }()
    
    let ActualCostLabel: UILabel = {
        let label = UILabel()
        label.text = "Actual Cost: $"
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = Theme.fonts.mediumText.font
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.addSubview(budgetLabel)
        budgetLabel.frame = CGRect(x: 0, y: 0, width: 70, height: self.bounds.height)
        
        self.addSubview(budgetTF)
        budgetTF.frame = CGRect(x: budgetLabel.frame.width, y: 0, width: 50, height: self.bounds.height)
        budgetTF.delegate = self
        
    }
    
//    func finishEditing() {
//        budgetTF.delegate?.textFieldDidEndEditing!(budgetTF)
//    }
}

extension BudgetView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}
