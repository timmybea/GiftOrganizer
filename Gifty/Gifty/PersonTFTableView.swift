//
//  PersonTFTableView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol PersonTFTableViewDelegate {
    func didUpdateFirstName(string: String)
    func didUpdateLastName(string: String)
}

class TextFieldCellIndexPath {
    static var firstName = IndexPath(row: 0, section: 0)
    static var lastName = IndexPath(row: 1, section: 0)
}

class PersonTFTableView: UIView {

    var delegate: PersonTFTableViewDelegate?
    var currentIdentifier: TextFieldIdentifier?
    var firstName: String = "" {
        didSet {
            if self.delegate != nil {
                self.delegate?.didUpdateFirstName(string: firstName)
            }
        }
    }
    var lastName: String = "" {
        didSet {
            if self.delegate != nil {
                self.delegate?.didUpdateLastName(string: lastName)            }
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "TextfieldCell")
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        tableView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func finishEditing() {
        let indexPath = currentIdentifier == TextFieldIdentifier.personFirstName ? TextFieldCellIndexPath.firstName : TextFieldCellIndexPath.lastName
        let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell
        cell?.textField.delegate?.textFieldDidEndEditing!((cell?.textField)!)
    }
    
    func updateWith(firstName: String?, lastName: String?) {
        
        //????? WEIRD!!!! If the print statements are left in, the cells get updated properly, otherwise they don't
        print("TableView has sections: \(tableView.numberOfSections)")
        print("Tableview has rows in section 0: \(tableView.numberOfRows(inSection: 0))")
        
        if let firstName = firstName {
            let cell = tableView.cellForRow(at: TextFieldCellIndexPath.firstName) as? TextFieldCell
            cell?.setText(string: firstName)
        }
        
        if let lastName = lastName {
            let cell = tableView.cellForRow(at: TextFieldCellIndexPath.lastName) as? TextFieldCell
            cell?.setText(string: lastName)
        }
    }
}

extension PersonTFTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldCell") as? TextFieldCell
            cell?.configureWith(placeholder: "First Name", identifier: TextFieldIdentifier.personFirstName)
            cell?.delegate = self
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldCell") as? TextFieldCell
            cell?.configureWith(placeholder: "Last Name", identifier: TextFieldIdentifier.personLastName)
            cell?.delegate = self
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height / 2
    }
}

//MARK: TextFieldCellDelegate
extension PersonTFTableView: TextFieldCellDelegate {
    
    func updateVariableFor(identifier: TextFieldIdentifier, with value: String) {
        
        if identifier == TextFieldIdentifier.personFirstName {
            self.firstName = value
        } else if identifier == TextFieldIdentifier.personLastName {
            self.lastName = value
        }
    }
    
    func selectedCell(identifier: TextFieldIdentifier) {
        self.currentIdentifier = identifier
    }
}
