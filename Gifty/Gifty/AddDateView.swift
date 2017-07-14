//
//  addDate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol AddDateViewDelegate {
    func addDateViewWasTouched()
    func switchChanged(recurring: Bool)
}

class AddDateView: UIView {

    let touchView: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select date"
        label.textColor = UIColor.white
        label.font = FontManager.mediumText
        label.textAlignment = .left
        return label
    }()
    
    let calendarImage: UIImageView = {
        let image = UIImage(named: ImageNames.calendarIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let recurringEventSwitch: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.setOn(false, animated: false)
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        newSwitch.onTintColor = ColorManager.lightText
        newSwitch.tintColor = UIColor.white
        return newSwitch
    }()
    
    let recurringLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = FontManager.mediumText
        label.textAlignment = .right
        label.text = "Recurring"
        return label
    }()
    
    var delegate: AddDateViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews()
        
        touchView.addTarget(self, action: #selector(didTouchDownSelf), for: .touchDown)
        touchView.addTarget(self, action: #selector(didTouchUpSelf), for: .touchUpInside)
        recurringEventSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
    }
    
    func layoutViews() {
        
        self.addSubview(calendarImage)
        calendarImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        calendarImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        calendarImage.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        calendarImage.widthAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        
        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: calendarImage.rightAnchor, constant: pad).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(recurringEventSwitch)
        recurringEventSwitch.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        recurringEventSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(recurringLabel)
        recurringLabel.rightAnchor.constraint(equalTo: recurringEventSwitch.leftAnchor, constant: -pad).isActive = true
        recurringLabel.centerYAnchor.constraint(equalTo: recurringEventSwitch.centerYAnchor).isActive = true
        
        self.addSubview(touchView)
        bringSubview(toFront: touchView)
        touchView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        touchView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        touchView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        touchView.rightAnchor.constraint(equalTo: recurringLabel.leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel(with date: Date?) {
        
        if date != nil {
            self.label.text = DateHandler.stringFromDate(date!)
        } else {
            self.label.text = "Select date"
        }
    }
}

//MARK: switch changed value (protocol method called)
extension AddDateView {
    
    func switchDidChange(_ sender: UISwitch) {
        
        if let delegate = self.delegate {
            if sender.isOn {
                delegate.switchChanged(recurring: true)
                
            } else {
                delegate.switchChanged(recurring: false)
            }
        }
    }    
}

//MARK: touchViewtouched (protocol method called)
extension AddDateView {
    
    func didTouchDownSelf() {
        
        self.calendarImage.tintColor = ColorManager.lightText
        self.label.textColor = ColorManager.lightText
    }
    
    func didTouchUpSelf() {
        self.calendarImage.tintColor = UIColor.white
        self.label.textColor = UIColor.white
        
        if self.delegate != nil {
            self.delegate?.addDateViewWasTouched()
        }
    }
}
