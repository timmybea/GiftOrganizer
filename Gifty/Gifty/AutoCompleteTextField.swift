//
//  AutoCompleteTextField.swift
//  AutoCompleteTFDemo
//
//  Created by Tim Beals on 2017-12-31.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol AutoCompleteTextFieldDelegate {
    func provideDatasource()
    func returned(with selection: String)
    func textFieldCleared()
}

class AutoCompleteTextField: UITextField {
    var datasource: [String]?
    var currInput: String = ""
    var autocompleteDelegate: AutoCompleteTextFieldDelegate?
    var isReturned: Bool = false
    
    var highlightTextColor: UIColor = UIColor.gray {
        didSet {
            self.textColor = highlightTextColor
        }
    }

    var boldTextColor: UIColor = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.textColor = highlightTextColor
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.text = ""
    }
}

extension AutoCompleteTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.autocompleteDelegate?.provideDatasource()
        self.currInput = ""
        self.isReturned = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        textField.textColor = highlightTextColor
        self.currInput += string
        textField.text = self.currInput
        
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(char, "\u{8}"))
        if isBackSpace == -8 {
            print("Backspace was pressed")
            self.currInput = String(self.currInput.dropLast())
            if self.currInput == "" {
                textField.text = ""
                autocompleteDelegate?.textFieldCleared()
            }
        }
        
        //select option from datasource and color the text
        if let allOptions = datasource?.filter({ $0.hasPrefix(self.currInput) }) {
            let exactMatch = allOptions.filter() { $0 == self.currInput }
            let fullName = exactMatch.count > 0 ? exactMatch.first! : allOptions.first ?? self.currInput
            if let range = fullName.range(of: self.currInput) {
                let nsRange = fullName.nsRange(from: range)
                let attribute = NSMutableAttributedString.init(string: fullName as String)
                attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: self.boldTextColor, range: nsRange)
                textField.attributedText = attribute
            }
        }
        
        //cursor position
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: self.currInput.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignFirstResponder()
        if !isReturned {
            textField.text = ""
            self.currInput = ""
        } else {
            textField.textColor = boldTextColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.autocompleteDelegate?.returned(with: textField.text!)
        self.isReturned = true
        self.endEditing(true)
        return true
    }
}

extension String {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
