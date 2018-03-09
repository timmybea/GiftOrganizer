//
//  TitleTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-08.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class CENTitleTableViewCell: UITableViewCell {

    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholderWith(string: "Title", color: Theme.colors.lightToneTwo.color)
        textField.textColor = Theme.colors.charcoal.color
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        textField.keyboardType = .alphabet
        return textField
    }()
    
    let underline: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.colors.lightToneTwo.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: pad + 4),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -pad),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
            ])
        textField.delegate = self
        
        addSubview(underline)
        NSLayoutConstraint.activate([
            underline.leftAnchor.constraint(equalTo: leftAnchor, constant: pad),
            underline.rightAnchor.constraint(equalTo: textField.rightAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)
            ])
    }

}

extension CENTitleTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var input = textField.text, input.count > 0 else { return }
        
        let firstChar = input.removeFirst()
        let capitalized = String(firstChar).uppercased() + input
        textField.text = capitalized
    }

//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        guard let use = args?.first else { return true }
//        if let id = TFSettingsCellID.init(rawValue: use) {
//            self.delegate?.beganEditingCell(with: id)
//        }
//        if use == TFSettingsCellID.budgetAmt.rawValue {
//
//            textField.text = "$"
//        }
//        return true
//    }
}

