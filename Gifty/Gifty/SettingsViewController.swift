//
//  SettingsViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge
import StoreKit

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
    
    var containerBottomConstraint: NSLayoutConstraint!

    var datasource: [SettingData] = SettingData.getSettingDatasource()
    
    var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    var editingTextField: TFSettingsCellID?

    private var customTransitionDelegate = CustomTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.tableView.register(SegueSettingsTableViewCell.self, forCellReuseIdentifier: "segueSettingsCell")
        self.tableView.register(TextfieldSettingsTableViewCell.self, forCellReuseIdentifier: "textfieldSettingsCell")
        self.tableView.register(ScrollSettingsTableViewCell.self, forCellReuseIdentifier: "scrollSettingsCell")
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "scrollSettingsCell") as? ScrollSettingsTableViewCell
            cell?.args = cellType.args
            cell?.delegate = self
            return cell!
        case .textfield:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfieldSettingsCell") as? TextfieldSettingsTableViewCell
            cell?.delegate = self
            cell?.args = cellType.args
            return cell!
        case .popOver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "segueSettingsCell") as? SegueSettingsTableViewCell
            cell?.args = cellType.args
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let segueCell = cell as? SegueSettingsTableViewCell {
            let args = segueCell.args!
            if (args.contains("makePurchase")) {
                popOverInAppPurchase()
            } else if args.contains("restorePurchases"){
                IAPService.shared.restorePurchases()
            } else {
                let destination = CustomTableViewController()
                if segueCell.identifier == "Groups" {
                    destination.useCase = CustomTableViewController.UseCase.group
                } else if segueCell.identifier == "Events" {
                    destination.useCase = CustomTableViewController.UseCase.celebration
                }
                self.navigationController?.pushViewController(destination, animated: true)
            }
        } else if let tfCell = cell as? TextfieldSettingsTableViewCell {
            tfCell.textfield.becomeFirstResponder()
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
    
    private func popOverInAppPurchase() {
        let overlayVC = OverlayIAPViewController()
        self.transitioningDelegate = self.customTransitionDelegate
        overlayVC.transitioningDelegate = self.customTransitionDelegate
        overlayVC.delegate = self
        overlayVC.modalPresentationStyle = .custom

        self.present(overlayVC, animated: true, completion: nil)
        PopUpManager.popUpShowing = true
    }
}

//MARK: ReturnContainerViewDelegate Methods
extension SettingsViewController: ReturnContainerViewDelegate {
    func buttonTouched(save: Bool) {
        print("Save textfield input: \(save)")
        guard let textfieldID = self.editingTextField else { return }
        let cell = tableView.cellForRow(at: textfieldID.indexPath) as? TextfieldSettingsTableViewCell
        cell?.endEditing(save: save)
    }
}

//MARK: TextFieldSettingsCellDelegate Methods
extension SettingsViewController: TextFieldSettingsCellDelegate {
    func beganEditingCell(with id: TFSettingsCellID) {
        self.editingTextField = id
    }
}

//MARK: ScrollingSettingsCellDelegate Methods
extension SettingsViewController: ScrollingSettingsCellDelegate {
    func optionChanged(to option: String) {
        var temp = option
        guard temp.count > 0 else { return }
        
        if String(temp.first!) == "\(currencySymbol)" {
            _ = temp.removeFirst()
        }
        SettingsHandler.shared.rounding = Float(temp)!
    }
}

//MARK: OverlayIAPViewControllerDelegate
extension SettingsViewController: OverlayIAPViewControllerDelegate {
   
    func makePurchase() {
        InterstitialService.shared.isSuspended = true
        do {
            try IAPService.shared.purchaseProduct(SKProduct.product.nonConsumable)
        } catch {
            print(error.localizedDescription)
        }
    }
        
}

