//
//  CustomCalendarCellOne.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-24.
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
    
    private let todayDateView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.todayBGView.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let actionSpot: UIImageView = {
        let image = UIImage(named: ImageNames.calendarSpot.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupTodayDateView()
        setupSelectedDateView()
        setupLabel()
        setupActionSpot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTodayDateView() {
        addSubview(todayDateView)
        todayDateView.isHidden = true
        
        todayDateView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        todayDateView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        todayDateView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        todayDateView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 2).isActive = true
    }
    
    private func setupSelectedDateView() {
        addSubview(selectedDateView)
        selectedDateView.isHidden = true
        selectedDateView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        selectedDateView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        selectedDateView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        selectedDateView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    private func setupLabel() {
        addSubview(dateLabel)
        dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    private func setupActionSpot() {
        
        addSubview(actionSpot)
        actionSpot.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        actionSpot.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionSpot.heightAnchor.constraint(equalToConstant: 8).isActive = true
        actionSpot.widthAnchor.constraint(equalToConstant: 8).isActive = true
        actionSpot.tintColor = Theme.colors.completedGreen.color
        actionSpot.isHidden = true
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
        
        if cellState.dateBelongsTo == .thisMonth {
            self.selectedDateView.isHidden = staySelected ? false : true
            self.dateLabel.textColor = staySelected ? Theme.colors.lightToneTwo.color : UIColor.white
        } else {
            self.dateLabel.textColor = UIColor.clear
        }
        
        actionSpot.isHidden = actionDateString == DateHandler.stringFromDate(cellState.date) ? false : true
        
        todayDateView.isHidden = true
        
        let today = DateHandler.localTimeFromUTC(Date())
        if Calendar.current.isDate(cellState.date, inSameDayAs:today) && cellState.dateBelongsTo == .thisMonth {
                self.todayDateView.isHidden = false
                self.dateLabel.textColor = Theme.colors.lightToneTwo.color
        }
        self.showInfo = staySelected
    }
    
    var actionDateString = ""
    
    func action(for dateString: String, complete: Bool?) {
        //if an event is deleted and you need to remove the action circle pass nil for complete.
        
        if complete == nil {
            self.actionSpot.isHidden = true
            actionDateString = ""
        } else {
            self.actionSpot.isHidden = false
            self.actionDateString = dateString
            self.actionSpot.tintColor = complete! ? Theme.colors.completedGreen.color : Theme.colors.lightToneOne.color
        }

    }
    
}
