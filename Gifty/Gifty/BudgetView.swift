//
//  BudgetView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class BudgetView: UIView {


    private let budgetLabel: UILabel = {
        let label = Theme.createMediumLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.00"
        label.textAlignment = .center
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = Theme.colors.lightToneOne.color
        slider.maximumTrackTintColor = UIColor.white
        slider.maximumValue = 100.00
        slider.addTarget(self, action: #selector(sliderChangedValue(sender:)), for: .valueChanged)
        return slider
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
     
        addSubview(slider)
        slider.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        addSubview(budgetLabel)
        budgetLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: smallPad).isActive = true
        budgetLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc private func sliderChangedValue(sender: UISlider) {
        
        let amount = sender.value
        let roundedAmount = CurrencyHandler.round(amount, toNearest: 0.25)
        let formattedString = CurrencyHandler.formattedString(for: roundedAmount)
        self.budgetLabel.text = "$\(formattedString)"
    }
    
    public func getBudgetAmount() -> Float {
        
        let amount = slider.value
        let roundedAmount = CurrencyHandler.round(amount, toNearest: 0.25)
        return roundedAmount

    }
    

    
}



