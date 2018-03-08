//
//  TitleTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-08.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class CENTitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
