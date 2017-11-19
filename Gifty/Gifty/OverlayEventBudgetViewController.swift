//
//  OverlayViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-09-11.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class OverlayEventBudgetViewController: UIViewController {
    
    var event: Event? {
        didSet {
            setText()
        }
    }
    
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
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = Theme.fonts.subtitleText.font
        label.text = "Actual Amount Spent"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = Theme.colors.lightToneOne.color
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let budgetView: BudgetView = {
        let budgetView = BudgetView()
        budgetView.translatesAutoresizingMaskIntoConstraints = false
        return budgetView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 200)
        self.view.layer.cornerRadius = 8.0
        self.view.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSubviews() {
        
        view.addSubview(bgView)
        bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        view.addSubview(headingLabel)
        headingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: pad).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: smallPad).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(budgetView)
        budgetView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: pad).isActive = true
        budgetView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -pad).isActive = true
        budgetView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: smallPad).isActive = true
        budgetView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        if event?.actualAmt != nil {
            budgetView.setTo(amount: (event?.actualAmt)!)
        }
        
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.blue
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        
        view.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        okButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2).isActive = true
        
        stackView.addArrangedSubview(okButton)
        stackView.addArrangedSubview(cancelButton)
    }
    
    func setText() {
        if let currentEvent = self.event {
            let budget = CurrencyHandler.formattedString(for: currentEvent.budgetAmt)
            textView.text = "You have set a budget of $\(budget) for the event, \(currentEvent.type!)"
        }
    }
    
    
    @objc private func closeButtonTouched(sender: UIButton) {
        print("close button touched")
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc private func okButtonTouched(sender: UIButton) {
        print("ok button touched")
        event?.actualAmt = self.budgetView.getBudgetAmount()
        ManagedObjectBuilder.saveChanges { (success) in
            print("Saving spent amount success: \(success)")
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
