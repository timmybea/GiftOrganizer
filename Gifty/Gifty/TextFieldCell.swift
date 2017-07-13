//
//  TextFieldCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate {
    func selectedCell(identifier: TextFieldIdentifier)
    func updateVariableFor(identifier: TextFieldIdentifier, with value: String)
}

enum TextFieldIdentifier: String {
    case personFirstName = "personFirstName"
    case personLastName = "personLastName"
}

class TextFieldCell: UITableViewCell {

    var identifier: TextFieldIdentifier = TextFieldIdentifier.personFirstName
    var delegate: TextFieldCellDelegate?
    
    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        textField.keyboardType = .alphabet
        return textField
    }()
    
    let whiteUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(placeholder: String, identifier: TextFieldIdentifier) {
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.identifier = identifier
        textField.delegate = self
        
        addSubview(textField)
        
        textField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
        textField.placeholderWith(string: placeholder, color: UIColor.white)

        addSubview(whiteUnderline)
        whiteUnderline.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        whiteUnderline.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        whiteUnderline.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        whiteUnderline.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func setText(string: String) {
        textField.text = string
        textField.delegate?.textFieldDidEndEditing!(textField)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.delegate != nil {
            self.delegate?.selectedCell(identifier: identifier)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let capitalizedText = textField.text?.capitalized, self.delegate != nil {
            if capitalizedText != textField.text {
                textField.text = capitalizedText
            }
            delegate?.updateVariableFor(identifier: identifier, with: textField.text!)
        }
        
        
        self.textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
}
