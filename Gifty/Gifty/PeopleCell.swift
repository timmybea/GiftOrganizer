//
//  PeopleCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-27.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PeopleCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
