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
    
    var datasource: [SettingData] = SettingData.getSettingDatasource()
    
    var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        
        self.tableView.register(SegueSettingsTableViewCell.self, forCellReuseIdentifier: "segueSettingsCell")
        
        
//        view.sendSubview(toBack: self.backgroundView)
//        budgetTextField.delegate = self
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTouched(sender:)))
//        scrollView.addGestureRecognizer(tapGesture)
        setupSubviews()
        addSavedSettings()
    }
    
    
    func setupSubviews() {
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        
        
        
    }
    
    private func addSavedSettings() {
//        budgetTextField.text = "$\(SettingsHandler.shared.maxBudget)"
    }
    
    
    @objc func scrollViewTouched(sender: UITapGestureRecognizer) {
//        if budgetTextField.isEditing {
//            budgetTextField.endEditing(true)
//        }
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if var userInput = textField.text {
                userInput.remove(at: userInput.startIndex)
                if let newValue = Int(userInput) {
                    SettingsHandler.shared.maxBudget = newValue
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 { //budgetTextfield
            textField.text = "$"
        }
        return true
    }
}

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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "segueSettingsCell") as? SegueSettingsTableViewCell else { return UITableViewCell() }
            cell.args = cellType.args
            return cell
        case .scrollview:
            return UITableViewCell()
        case .textfield:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SegueSettingsTableViewCell {
            let destination = CustomTableViewController()
            if cell.identifier == "Groups" {
                destination.useCase = CustomTableViewController.UseCase.group
            } else if cell.identifier == "Celebrations" {
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

