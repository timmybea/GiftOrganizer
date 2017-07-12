//
//  EventCollectionViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-10.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = FontManager.subtitleText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.red
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupSubviews() {
    
        addSubview(eventTypeLabel)
        eventTypeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        eventTypeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
