//
//  OverlayIAPViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-08-27.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class OverlayIAPViewControllerDelegate {
    
}

class OverlayIAPViewController: UIViewController {
    
    var delegate: OverlayIAPViewController?
    
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
        label.text = "Upgrade to Full Version"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = Theme.colors.textLightTone.color
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = UIColor.blue
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 220)
        self.view.layer.cornerRadius = 8.0
        self.view.layer.masksToBounds = true
        
        bgView.removeFromSuperview()
        okButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        textView.removeFromSuperview()
        headingLabel.removeFromSuperview()
        
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    
}

//MARK: Selector Methods
extension OverlayIAPViewController {
    
    @objc func okButtonTouched(sender: UIButton) {
        
    }

    @objc func cancelButtonTouched(sender: UIButton) {
        
    }
}
