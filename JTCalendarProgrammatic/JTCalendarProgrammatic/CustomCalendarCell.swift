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
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.white
        dateLabel.alpha = 0.8
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private let selectedDateView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.selectedDateCircle.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupSelectedDateView()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelectedDateView() {
        addSubview(selectedDateView)
        selectedDateView.isHidden = true
        selectedDateView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        selectedDateView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        selectedDateView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        selectedDateView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupLabel() {
        addSubview(dateLabel)
        dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    private var wasSelected = false
    var showInfo = false
    
    func configureCellWith(_ cellState: CellState) {
        self.dateLabel.text = cellState.text
        
        var staySelected = false
        
        if cellState.isSelected {
            staySelected = self.wasSelected ? false : true
            self.wasSelected = !self.wasSelected
        } else {
            wasSelected = false
        }
        
        self.selectedDateView.isHidden = staySelected ? false : true
        
        if staySelected {
            self.dateLabel.textColor = UIColor.purple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                self.dateLabel.textColor = UIColor.white
            } else {
                self.dateLabel.textColor = ColorManager.lightText
            }
        }
        
        if Calendar.current.isDate(cellState.date, inSameDayAs:Date()) {
            self.backgroundColor = UIColor.blue
        }
        
        self.showInfo = staySelected
    }

}
