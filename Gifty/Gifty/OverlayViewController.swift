//
//  OverlayViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-09-11.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.colors.buttonPurple.color
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 200)
        self.view.layer.cornerRadius = 8.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSubviews() {
        
        view.addSubview(closeButton)
        closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        
    }
    
    @objc private func closeButtonTouched(sender: UIButton) {
        print("close button touched")
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
