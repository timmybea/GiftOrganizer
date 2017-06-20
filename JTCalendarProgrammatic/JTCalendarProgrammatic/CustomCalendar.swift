//
//  CustomCalendar.swift
//  JTCalendarProgrammatic
//
//  Created by Tim Beals on 2017-06-20.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCalendar: UIView {

    let dateFormatter = DateFormatter()
    
    lazy var calendarView: JTAppleCalendarView = {
        let layout = UICollectionViewFlowLayout()
        let calendarView = JTAppleCalendarView(frame: .zero, collectionViewLayout: layout)
        //let calendarView = JTAppleCalendarView(frame: .zero)
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.backgroundColor = UIColor.gray
        calendarView.scrollDirection = .horizontal
        calendarView.showsVerticalScrollIndicator = false
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.isPagingEnabled = true
        return calendarView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        calendarView.frame = self.bounds
        addSubview(calendarView)
        calendarView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CustomCalendarCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCalendar: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "YYYY MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2017 01 01")!
        let endDate = dateFormatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell
        
        cell.configureCellWith(cellState)
        if cell.dateLabel.text != "" {
            print(cell.dateLabel.text)
        }
        return cell
    }
    
}
