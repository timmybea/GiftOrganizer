//
//  CustomCalendarCell.swift
//  JTCalendarProgrammatic
//
//  Created by Tim Beals on 2017-06-20.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCalendarCell: JTAppleCell {

    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blue
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        addSubview(dateLabel)
        bringSubview(toFront: dateLabel)
        dateLabel.backgroundColor = UIColor.red
        dateLabel.textColor = UIColor.black
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .center
        dateLabel.center.x = self.center.x
        dateLabel.center.y = self.center.y
    }

    func configureCellWith(_ cellState: CellState) {
        self.dateLabel.text = cellState.text
    }
    
    
    
    

}
