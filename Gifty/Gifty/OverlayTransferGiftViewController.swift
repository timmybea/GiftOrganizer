//
//  OverlayTransferGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class OverlayTransferGiftViewController: UIViewController {

    let bgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageNames.horizontalBGGradient.rawValue))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.addTarget(self, action: #selector(okButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = Theme.fonts.subtitleText.font
        label.text = "Copy Gift To"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var autoCompletePerson: AutoCompletePerson!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 220)
        self.view.layer.cornerRadius = 8.0
        self.view.layer.masksToBounds = true
        
        layoutSubviews()
    }
    
    private func layoutSubviews() {
     
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        
        view.addSubview(headingLabel)
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: pad),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 0
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        
        view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackview.heightAnchor.constraint(equalToConstant: 30.0),
            stackview.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackview.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        stackview.addArrangedSubview(cancelButton)
        stackview.addArrangedSubview(okButton)
        
        autoCompletePerson = AutoCompletePerson(frame: CGRect(x: pad,
                                                              y: view.bounds.size.height / 2.0 - 50.0,
                                                              width: view.bounds.size.width - pad - pad,
                                                              height: 100))
        autoCompletePerson.autoCompleteTF.autocompleteDelegate = self
        view.addSubview(autoCompletePerson)
        
    }
    
    @objc
    func okButtonTouched(sender: UIButton) {
        
        print("ok button touched")
    
    
    }
    
    @objc
    func cancelButtonTouched(sender: UIButton) {
        
        print("Cancel button touched")
    }

    
}

extension OverlayTransferGiftViewController : AutoCompleteTextFieldDelegate {
    
    func provideDatasource() {
        //
    }
    
    func returned(with selection: String) {
        //
    }
    
    func textFieldCleared() {
        //
    }
    
    
}
