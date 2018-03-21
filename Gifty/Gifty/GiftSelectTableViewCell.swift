//
//  GiftSelectTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-20.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class GiftSelectTableViewCell: UITableViewCell {


    var gift: Gift?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with gift: Gift) {
        self.gift = gift
        self.textLabel?.text = gift.name
        self.detailTextLabel?.text = gift.eventId == nil ? "AVAILABLE" : "ASSIGNED"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
