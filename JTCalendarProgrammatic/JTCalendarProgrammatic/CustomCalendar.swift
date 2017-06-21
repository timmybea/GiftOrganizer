//
//  CustomCalendar.swift
//  JTCalendarProgrammatic
//
//  Created by Tim Beals on 2017-06-20.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol CustomCalendarDelegate {
    func dateWasSelected(_ date: Date)
}

class CustomCalendar: UIView {

    var delegate: CustomCalendarDelegate?
    
    let dateFormatter = DateFormatter()
    
    lazy var calendarView: JTAppleCalendarView = {
        let calendarView = JTAppleCalendarView(frame: .zero)
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.backgroundColor = UIColor.clear
        calendarView.scrollDirection = .horizontal
        calendarView.showsVerticalScrollIndicator = false
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.isPagingEnabled = true
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    let monthYearLabel: UILabel = {
        let monthYearLabel = UILabel()
        monthYearLabel.textAlignment = .left
        monthYearLabel.font = UIFont.systemFont(ofSize: 24)
        monthYearLabel.textColor = UIColor.white
        monthYearLabel.text = "Something"
        return monthYearLabel
    }()
    
    
    let dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMonthYearHeader()
        setupDayHeader()
        setupCalendarView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMonthYearHeader() {
        addSubview(monthYearLabel)
        
        addConstraintsWithFormat(format: "H:|-22-[v0]|", views: monthYearLabel)
        addConstraintsWithFormat(format: "V:|[v0(26)]", views: monthYearLabel)
    }
    
    private func setupDayHeader() {
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        for (index, day) in days.enumerated() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontSizeToFitWidth = true
            label.textColor = ColorManager.lightText
            label.textAlignment = .center
            label.text = day
            dayStackView.insertArrangedSubview(label, at: index)
        }
        
        addSubview(dayStackView)
        
        dayStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dayStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dayStackView.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor, constant: 8).isActive = true
        dayStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupCalendarView() {
        addSubview(calendarView)
        
        calendarView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        calendarView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        calendarView.topAnchor.constraint(equalTo: dayStackView.bottomAnchor).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        calendarView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CustomCalendarCell")
        
        calendarView.visibleDates { (visibleDates) in
            self.setMonthYearLabel(from: visibleDates)
        }
    }
    
    fileprivate func handleTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCalendarCell else { return }
    
        if cellState.isSelected {
            validCell.dateLabel.textColor = UIColor.purple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = UIColor.white
            } else {
                validCell.dateLabel.textColor = ColorManager.lightText
            }
        }
    }
    
    fileprivate func setMonthYearLabel(from visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            dateFormatter.dateFormat = "MMMM YYYY"
            monthYearLabel.text = dateFormatter.string(from: date)
        }
    }
    
    fileprivate func showHideSelectedView(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCalendarCell else { return }
        validCell.selectedDateView.isHidden = cellState.isSelected ? false : true
    }
}

extension CustomCalendar: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "YYYY MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2017 01 01")!
        let endDate = dateFormatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CustomCalendar: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell
        cell.backgroundColor = UIColor.clear
        cell.configureCellWith(cellState)
        
        //Highlight today's date
        if Calendar.current.isDate(cellState.date, inSameDayAs:Date()) {
            cell.backgroundColor = UIColor.blue
        }
        
        showHideSelectedView(cell: cell, cellState: cellState)
        handleTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        showHideSelectedView(cell: cell, cellState: cellState)
        handleTextColor(cell: cell, cellState: cellState)
        self.delegate?.dateWasSelected(cellState.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        showHideSelectedView(cell: cell, cellState: cellState)
        handleTextColor(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setMonthYearLabel(from: visibleDates)
    }
}
