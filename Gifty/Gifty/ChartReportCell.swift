//
//  ChartReportCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-10.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class ChartReportCell: UITableViewCell {

    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let spendingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let giftCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func configureLabel(_ label: UILabel) {
        label.font = Theme.fonts.mediumText.font
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = Theme.colors.charcoal.color
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let cellPad: CGFloat = 3
        
        self.addSubview(colorView)
        self.colorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.colorView.topAnchor.constraint(equalTo: self.topAnchor, constant: cellPad).isActive = true
        self.colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -cellPad).isActive = true
        self.colorView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -(2 * cellPad)).isActive = true

        configureLabel(groupLabel)
        self.addSubview(groupLabel)
        self.groupLabel.leftAnchor.constraint(equalTo: colorView.rightAnchor, constant: pad).isActive = true
        self.groupLabel.widthAnchor.constraint(equalToConstant: 84).isActive = true
        self.groupLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        configureLabel(spendingLabel)
        self.addSubview(spendingLabel)
        self.spendingLabel.leftAnchor.constraint(equalTo: groupLabel.rightAnchor, constant: pad).isActive = true
        self.spendingLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.spendingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        configureLabel(giftCountLabel)
        self.addSubview(giftCountLabel)
        self.giftCountLabel.leftAnchor.constraint(equalTo: spendingLabel.rightAnchor, constant: pad).isActive = true
        self.giftCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.giftCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
    
    func configureWith(chartReportItem: ChartReportItem) {
        
        self.colorView.backgroundColor = chartReportItem.color
        
        self.groupLabel.text = chartReportItem.group
        let amount = String(format: "%.2f", chartReportItem.totalSpent)
        self.spendingLabel.text = "Spent: $\(amount)"
        self.giftCountLabel.text = "Gifts: \(chartReportItem.numberGifts)"
    }
    
}
