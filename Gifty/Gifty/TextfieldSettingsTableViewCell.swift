//
//  TextfieldSettingsTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-15.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol TextFieldSettingsCellDelegate {
    func beganEditingCell(with id: TFSettingsCellID)
}

class TextfieldSettingsTableViewCell: UITableViewCell {

    let textfield: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.clear
        tf.textColor = Theme.colors.charcoal.color
        tf.keyboardType = .numberPad
        return tf
    }()
    
    var delegate: TextFieldSettingsCellDelegate?
    
    var args: [String]? {
        didSet {
            setupCellLogic()
        }
    }
    
    private var save: Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.textfield.delegate = self
    
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        self.addSubview(textfield)
        textfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        textfield.widthAnchor.constraint(equalToConstant: 100).isActive = true
        textfield.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupCellLogic() {
        
        guard let use = args?.first else { return }
        
        if use == TFSettingsCellID.budgetAmt.rawValue {
            
            self.textLabel?.text = "Max budget amount"
            self.textLabel?.textColor = Theme.colors.charcoal.color
            self.textfield.text = "$\(SettingsHandler.shared.maxBudget).00"
        }
    }
    
    func endEditing(save: Bool) {
        self.save = save
        self.textfield.endEditing(true)
    }
}


extension TextfieldSettingsTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let use = args?.first else { return }
        guard let tfText = textField.text else { return }
        
        if use == TFSettingsCellID.budgetAmt.rawValue {
            if save {
                let userInput = tfText.hasPrefix("$") ? String(tfText.dropFirst()) : tfText
                if let newValue = Int(userInput) {
                    SettingsHandler.shared.maxBudget = newValue
                    
                }
            }
            self.textfield.text = "$\(SettingsHandler.shared.maxBudget).00"
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let use = args?.first else { return true }
        if let id = TFSettingsCellID.init(rawValue: use) {
            self.delegate?.beganEditingCell(with: id)
        }
        if use == TFSettingsCellID.budgetAmt.rawValue {
            
            textField.text = "$"
        }
        return true
    }
}

enum TFSettingsCellID: String {
    case budgetAmt
    
    var indexPath: IndexPath {
        switch self {
        case .budgetAmt: return IndexPath(row: 0, section: 1)
        }
    }
}

