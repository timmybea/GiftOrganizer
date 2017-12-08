//
//  PieChartCellTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-07.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PieChartCell: UITableViewCell {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.green
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
