//
//  TextFieldCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        textField.placeholderWith(string: "Name", color: UIColor.white)
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
    
    func configureWith(placeholder: String) {
        
        addSubview(textField)
        
        textField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
                
        textField.placeholder = placeholder
        
        addSubview(whiteUnderline)
        whiteUnderline.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        whiteUnderline.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        whiteUnderline.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        whiteUnderline.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    

}
