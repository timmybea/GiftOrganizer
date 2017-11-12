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
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var budgetView: BudgetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 200)
        print("LAYOUT width \(self.view.bounds.width)")
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
        
        print("width \(self.view.bounds.width)")
        
        self.budgetView = BudgetView(frame: CGRect(x: pad, y: pad, width: self.view.bounds.width - 40 - pad - pad, height: 60))
        view.addSubview(budgetView)
        
        view.addSubview(closeButton)
        closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true

        
//        view.addSubview(textView)
//        textView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        textView.bottomAnchor.constraint(equalTo: closeButton.topAnchor).isActive = true
        
        
        
    }
    
    func setText() {
        
//        if let currentEvent = self.event {
//
//            let budget = CurrencyHandler.formattedString(for: currentEvent.budgetAmt)
//
//            textView.text = "You have set a budget of $\(budget) for the event \(currentEvent.type!)"
//
//        }
        
        
    }
    
    
    @objc private func closeButtonTouched(sender: UIButton) {
        print("close button touched")
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
