//
//  DropDownTextField.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol DropDownTextFieldDelegate {
    func dropDownWillAnimate(down: Bool)
    func optionSelected(option: String)
}

class DropDownTextField: UIView {

    var options: [String]
    var isDroppedDown = false
    
    var delegate: DropDownTextFieldDelegate?

    let whiteUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.fonts.mediumText.font
        label.textColor = UIColor.white
        return label
    }()
    
    let triangleIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.dropdownTriangle.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tapView: UIView = {
        let view = UIView()
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DropDownCell.self, forCellReuseIdentifier: "option")
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        return tableView
    }()
    
    let animatedView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.colors.lightToneTwo.color
        return view
    }()
    

    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        textField.keyboardType = .alphabet
        return textField
    }()
    
    
    init(frame: CGRect, title: String, options: [String]) {
        
        self.titleLabel.text = title
        self.options = options
        
        super.init(frame: frame)
        calculateHeight()
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    private var originalHeight: CGFloat = 0
    private let rowHeight: CGFloat = 40
    
    private func calculateHeight() {
        self.originalHeight = self.bounds.height
        let rowCount = self.options.count + 1 //Add one so that you can include 'other'
        let newHeight = self.originalHeight + (CGFloat(rowCount) * rowHeight)
        self.frame.size = CGSize(width: self.frame.width, height: newHeight)
    }
    
    private func setupViews() {
        addSubview(whiteUnderline)
        whiteUnderline.frame = CGRect(x: 0, y: self.originalHeight - 1, width: self.bounds.width, height: 2)
        
        addSubview(triangleIndicator)
        let triSize: CGFloat = 8
        let triX = self.bounds.width - triSize
        let triY = self.originalHeight - whiteUnderline.frame.height - triSize - 10
        triangleIndicator.frame = CGRect(x: triX, y: triY, width: triSize, height: triSize)
        
        addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 0, y: self.originalHeight - 26, width: self.bounds.width - triangleIndicator.frame.width, height: 16)
        
        addSubview(tapView)
        tapView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.originalHeight)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuDropDown))
        self.tapView.addGestureRecognizer(tapGesture)
        
        //MARK: setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: self.originalHeight, width: self.bounds.width, height: self.bounds.height - originalHeight)
        tableView.isHidden = true

        self.addSubview(animatedView)
        animatedView.frame = tableView.frame
        self.sendSubview(toBack: animatedView)
        animatedView.isHidden = true
        
        self.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: whiteUnderline.bottomAnchor, constant: -10).isActive = true
        textField.font = Theme.fonts.mediumText.font
        textField.delegate = self
        textField.isHidden = true
    }
    
    @objc func menuDropDown() {
    
        let downFrame = animatedView.frame
        let upFrame = CGRect(x: 0, y: self.originalHeight, width: self.bounds.width, height: 0)
        
        if isDroppedDown {
            //bring up
            self.tableView.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.animatedView.frame = upFrame
            }, completion: { (bool) in
                self.isDroppedDown = false
                self.animatedView.isHidden = true
                self.animatedView.frame = downFrame
                if self.delegate != nil {
                    self.delegate?.dropDownWillAnimate(down: false)
                }
            })
        } else {
            //bring down
            if self.delegate != nil {
                self.delegate?.dropDownWillAnimate(down: true)
            }
            
            animatedView.isHidden = false
            animatedView.frame = upFrame
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { 
                self.animatedView.frame = downFrame
            }, completion: { (bool) in
                self.tableView.isHidden = false
                self.isDroppedDown = true
            })
        }
    }
    
    func otherChosen() {
        menuDropDown()
        titleLabel.isHidden = true
        textField.text = ""
        textField.isHidden = false
        textField.becomeFirstResponder()
    }
    
    func finishEditingTextField() {
        textField.resignFirstResponder()
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
}

extension DropDownTextField: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        let text = textField.text
        let capitalized = text?.capitalized
        titleLabel.text = capitalized
        textField.isHidden = true
        titleLabel.isHidden = false
        textField.resignFirstResponder()
        
        if self.delegate != nil {
            delegate?.optionSelected(option: textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension DropDownTextField: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "option") as? DropDownCell
        
        if indexPath.row < options.count {
            cell?.configureCellWith(title: options[indexPath.row])
        } else {
            cell?.configureCellWith(title: "Other")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(options.count + 1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == options.count {
            otherChosen()
        } else {
            let chosen = options[indexPath.row]
            titleLabel.text = chosen
            if self.delegate != nil {
                self.delegate?.optionSelected(option: chosen)
            }
            menuDropDown()
        }
    }
}


class DropDownCell: UITableViewCell {
    
    let whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightText
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCellWith(title: String) {
        self.selectionStyle = .none
        self.textLabel?.font = Theme.fonts.mediumText.font
        self.textLabel?.textColor = Theme.colors.lightToneOne.color
        self.backgroundColor = UIColor.clear

        self.textLabel?.text = title
        
        addSubview(whiteView)
        
        whiteView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        whiteView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
