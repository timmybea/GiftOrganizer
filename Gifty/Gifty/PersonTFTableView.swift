//
//  PersonTFTableView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PersonTFTableView: UIView {

    var firstName: String = ""
    var lastName: String = ""
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "TextfieldCell")
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
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


extension PersonTFTableView: TextFieldCellDelegate {
    
    func updateVariableFor(identifier: TextFieldIdentifier, with value: String) {
        
        if identifier == TextFieldIdentifier.personFirstName {
            self.firstName = value
            print("first name is \(self.firstName)")
        } else if identifier == TextFieldIdentifier.personLastName {
            self.lastName = value
            print("last name is \(self.lastName)")
        }
    }
}
