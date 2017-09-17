//
//  BudgetView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class BudgetView: UIView {


    let budgetLabel: UILabel = {
        let label = Theme.createMediumLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.00"
        label.textAlignment = .center
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = Theme.colors.lightToneOne.color
        slider.maximumTrackTintColor = UIColor.white
        slider.maximumValue = 100.00
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blue
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
     
        addSubview(slider)
        slider.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        addSubview(budgetLabel)
        budgetLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: smallPad).isActive = true
        budgetLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}



