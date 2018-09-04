//
//  OverlayIAPViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-08-27.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

//MARK: Protocol Declaration
protocol OverlayIAPViewControllerDelegate {
    func makePurchase()
}

//MARK: Properties
class OverlayIAPViewController: UIViewController {
    
    var delegate: OverlayIAPViewControllerDelegate?
    
    let bgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageNames.horizontalBGGradient.rawValue))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.addTarget(self, action: #selector(okButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
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
        textView.font = Theme.fonts.mediumText.font
        return textView
    }()
}

//MARK: ViewController Lifecycle
extension OverlayIAPViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let width = isPad ? UIScreen.main.bounds.width / 2 - 40 : UIScreen.main.bounds.width - 40
        self.view.bounds.size = CGSize(width: width, height: 220)
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
    
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: pad),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -pad)
            ])
        textView.text = "Remove all advertising and get every feature of future versions for $2.99"
    }
    
    
}

//MARK: Selector Methods
extension OverlayIAPViewController {
    
    @objc func okButtonTouched(sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: {
            PopUpManager.popUpShowing = false
            self.delegate?.makePurchase()
        })
    }

    @objc func cancelButtonTouched(sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true) {
            PopUpManager.popUpShowing = false
        }
    }
}
