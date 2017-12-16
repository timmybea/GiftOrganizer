//
//  SegueSettingsTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-15.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SegueSettingsTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var args: [String]? {
        didSet {
            setupCell()
        }
    }
    
    var identifier: String?
    
    func setupCell() {
        guard let id = args?.first else { return }
        
        self.identifier = id
        
        self.textLabel?.textColor = Theme.colors.charcoal.color
        self.textLabel!.text = id
        self.accessoryType = .disclosureIndicator
    }

}
