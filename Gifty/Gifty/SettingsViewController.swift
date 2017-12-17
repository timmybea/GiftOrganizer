//
//  SettingsViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SettingsViewController: CustomViewController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.separatorColor = UIColor.clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    let returnContainer: ReturnContainerView = {
        let container = ReturnContainerView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    var datasource: [SettingData] = SettingData.getSettingDatasource()
    
    var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    var containerBottomConstraint: NSLayoutConstraint!
    
    var editingTextField: TFSettingsCellID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.tableView.register(SegueSettingsTableViewCell.self, forCellReuseIdentifier: "segueSettingsCell")
        self.tableView.register(TextfieldSettingsTableViewCell.self, forCellReuseIdentifier: "textfieldSettingsCell")
        
//        self.returnButton.addTarget(self, action: #selector(returnKeyTouched(sender:)), for: .touchUpInside)
        
        setupSubviews()
    }
    
    
    func setupSubviews() {
        view.addSubview(returnContainer)
        returnContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        returnContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        returnContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.containerBottomConstraint = NSLayoutConstraint(item: returnContainer,
                                                            attribute: .bottom,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .bottom,
                                                            multiplier: 1,
                                                            constant: -tabBarHeight + 40)
        containerBottomConstraint.isActive = true
        returnContainer.delegate = self
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: returnContainer.topAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    }
    
    
//    @objc func scrollViewTouched(sender: UITapGestureRecognizer) {
//
//        resignFirstResponder()
//
//    }
    
    //MARK: Return Key work around
//    @objc
//    func returnKeyTouched(sender: UIButton) {
//
//
//        print("Return touched")
//
//
//    }
    
    @objc
    func handleKeyboardNotification(sender: Notification) {

        print("Keyboard will show")
        
        if let userInfo = sender.userInfo {
           guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            let keyboardUp = sender.name == Notification.Name.UIKeyboardWillShow
            containerBottomConstraint.constant = keyboardUp ? CGFloat(-keyboardFrame.height) : -tabBarHeight + 40
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                
            })
        }
    }
}

//extension SettingsViewController: UITextFieldDelegate {
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 1 {
//            if var userInput = textField.text {
//                userInput.remove(at: userInput.startIndex)
//                if let newValue = Int(userInput) {
//                    SettingsHandler.shared.maxBudget = newValue
//                }
//            }
//        }
//    }
//    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField.tag == 1 { //budgetTextfield
//            textField.text = "$"
//        }
//        return true
//    }
//}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource[section].settingCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = datasource[indexPath.section].settingCells[indexPath.row]
        switch cellType.type {
        case .segue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "segueSettingsCell") as? SegueSettingsTableViewCell
            cell?.args = cellType.args
            return cell!
        case .scrollview:
            return UITableViewCell()
        case .textfield:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfieldSettingsCell") as? TextfieldSettingsTableViewCell
            cell?.delegate = self
            cell?.args = cellType.args
            return cell!
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let segueCell = cell as? SegueSettingsTableViewCell {
            let destination = CustomTableViewController()
            if segueCell.identifier == "Groups" {
                destination.useCase = CustomTableViewController.UseCase.group
            } else if segueCell.identifier == "Celebrations" {
                destination.useCase = CustomTableViewController.UseCase.celebration
            }
            self.navigationController?.pushViewController(destination, animated: true)
            } else if let _ = tableView.cellForRow(at: indexPath) {
            print("Hells yeah!")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: pad, y: 8, width: 200, height: 20))
        label.font = Theme.fonts.boldSubtitleText.font
        label.textColor = UIColor.white
        label.text = datasource[section].section
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension SettingsViewController: ReturnContainerViewDelegate {
    
    func buttonTouched(save: Bool) {
        print("Save textfield input: \(save)")
        
        resignFirstResponder()
    }
}

extension SettingsViewController: TextFieldSettingsCellDelegate {
    
    func beganEditingCell(with id: TFSettingsCellID) {
        self.editingTextField = id
    }
}

