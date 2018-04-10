//
//  CustomTableViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-11.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CustomTableViewController: CustomViewController {

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = Theme.colors.offWhite.color
        tv.allowsSelection = false
        tv.separatorStyle = .singleLine
        tv.separatorColor = Theme.colors.lightToneTwo.color
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.colors.buttonPurple.color
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        return tf
    }()
    
    var datasource: [String]?
    
    var bottomConstraint: NSLayoutConstraint?
    
    var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    var useCase: UseCase! {
        didSet {
            self.inputTextField.placeholder = self.useCase.placeholderText
            self.title = self.useCase.title
            getDatasource()
        }
    }
    
    func getDatasource() {
        switch useCase {
        case .celebration: datasource = SettingsHandler.shared.celebrations
        case .group: datasource = SettingsHandler.shared.groups
        default: print("reached end of switch")
        }
    }
    
    enum UseCase {
        case group
        case celebration
        
        var title: String {
            switch self {
            case .group: return "Group"
            case .celebration: return "Event"
            }
        }
        
        var placeholderText: String {
            switch self {
            case .celebration: return "Please enter event"
            case .group: return "Please enter group"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.useCase = .celebration

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //temporary
        self.backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTouchView))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
        setupNavigationBar()
        setupSubviews()
        
        
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue)
            , style: .plain, target: self, action: #selector(backButtonTouched))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupSubviews() {
        
        view.addSubview(inputContainerView)
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bottomConstraint = NSLayoutConstraint(item: inputContainerView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: -tabBarHeight)
        bottomConstraint?.isActive = true
        
        inputContainerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: pad).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -pad).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        
        backgroundView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
    }

    
    @objc
    func handleKeyboardNotification(sender: NSNotification) {
        print("Keyboard will show")
        
        if let userInfo = sender.userInfo {
            guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            let showBottomConst = CGFloat(keyboardFrame.height)
            
            let showKeyboard = sender.name == Notification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = showKeyboard ? -showBottomConst : -tabBarHeight
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                
            })
        }
    }
    
    @objc
    func didTouchView() {
        
        print("Detected touches")

        self.inputTextField.endEditing(true)
        
    }
    
    @objc
    func backButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
}

extension CustomTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = nil
        resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleText:
        if textField.text != "", let newInput = textField.text?.capitalized {
            guard var tempDatasource = self.datasource else { break handleText }
            tempDatasource.append(newInput)
            guard let index = tempDatasource.sorted().index(of: newInput) else { break handleText }
            self.datasource?.insert(newInput, at: index)
            
            switch useCase {
            case .celebration: SettingsHandler.shared.celebrations = datasource!
            case .group: SettingsHandler.shared.groups = datasource!
            default: print("reached end of switch")
            }
            
            DispatchQueue.main.async {
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        textField.endEditing(true)
        return true
    }
}

extension CustomTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = datasource?[indexPath.row]
        cell.textLabel?.font = Theme.fonts.subtitleText.font
        cell.textLabel?.textColor = Theme.colors.charcoal.color
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.datasource?.remove(at: indexPath.row)
            switch self.useCase {
            case .celebration: SettingsHandler.shared.celebrations = self.datasource!
            case .group: SettingsHandler.shared.groups = self.datasource!
            default: print("reached end of switch")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
        return [deleteAction]
    }
}
