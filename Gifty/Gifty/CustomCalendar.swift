//
//  CustomCalendarOne.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-24.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

protocol CustomCalendarDelegate {
    func hideShowInfoForSelectedDate(_ date: Date, show: Bool)
    func monthYearLabelWasUpdated(_ string: String)
}

typealias CalendarEventData = (eventCount: Int, eventsCompleted: Bool)

class CustomCalendar: UIView {
    
    fileprivate let gregorianCalendar: Calendar = Calendar(identifier: .gregorian)
    
    var delegate: CustomCalendarDelegate?
    
    fileprivate var dataSource: Dictionary<String, CalendarEventData>?
    
    var previouslySelectedDate: Date?
    
    private let dateFormatter = DateFormatter()
    
    fileprivate lazy var calendarView: JTAppleCalendarView = {
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
    
    private let monthYearLabel: UILabel = {
        let monthYearLabel = UILabel()
        monthYearLabel.textAlignment = .left
        monthYearLabel.font = Theme.fonts.titleText.font
        monthYearLabel.textColor = UIColor.white
        return monthYearLabel
    }()
    
    
    private let dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDayHeader()
        self.calendarView.isHidden = true
        setupCalendarView()
        scrollToThisMonth()
        self.calendarView.isHidden = false
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
            label.textColor = Theme.colors.lightToneOne.color
            label.textAlignment = .center
            label.text = day
            dayStackView.insertArrangedSubview(label, at: index)
        }
        
        addSubview(dayStackView)
        
        dayStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dayStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dayStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dayStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupCalendarView() {
        
        addSubview(calendarView)
        
        calendarView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        calendarView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        calendarView.topAnchor.constraint(equalTo: dayStackView.bottomAnchor, constant: 6).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        calendarView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CustomCalendarCell")
        
        calendarView.visibleDates { (visibleDates) in
            self.setMonthYearLabel(from: visibleDates)
        }
    }
    
    private func scrollToThisMonth() {
        let today = DateHandler.localTimeFromUTC(Date())
        
        let value = (Calendar.current.component(.weekday, from: today) - 1) * -1
        var scrollDate = gregorianCalendar.date(byAdding: .weekday, value: value, to: today)!
        
        let todayMonth = DateHandler.stringMonth(from: today)
        let scrollMonth = DateHandler.stringMonth(from: scrollDate)
        
        
        if todayMonth != scrollMonth {
            scrollDate = gregorianCalendar.date(byAdding: .weekOfYear, value: 1, to: scrollDate)!
        }

        self.calendarView.scrollToDate(scrollDate, animateScroll: false)
            
    }
    
    fileprivate func setMonthYearLabel(from visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            dateFormatter.dateFormat = "MMMM YYYY"
            monthYearLabel.text = dateFormatter.string(from: date)
            self.delegate?.monthYearLabelWasUpdated(monthYearLabel.text!)
        }
    }
    

    //MARK: changes to datasource and refreshing calendar view
    
    func setDataSource(stringDateCompleteDict: Dictionary<String, CalendarEventData>) {
        
        self.dataSource = stringDateCompleteDict
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
        
    }
    
    func deleteDateFromDataSource(_ dateString: String) {
        
        self.dataSource?.removeValue(forKey: dateString)
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
        
    }
    
    func updateDataSource(dateString: String, count: Int, completed: Bool) {
        
        var data = self.dataSource?[dateString]
        
        if data != nil {
            data?.eventsCompleted = completed
            data?.eventCount = count
            self.dataSource?[dateString] = data
        } else {
            
            //UNUSED! THIS IS FOR NEW EVENT NOT UPDATE
            self.dataSource?[dateString] = CalendarEventData(eventCount: count, eventsCompleted: completed)        
        }
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
    }
}

extension CustomCalendar: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let start = gregorianCalendar.date(byAdding: .year, value: -1, to: Date())!
        let end = gregorianCalendar.date(byAdding: .year, value: 1, to: Date())!
        
        let parameters = ConfigurationParameters(startDate: start, endDate: end)
            
        return parameters
    }
}

extension CustomCalendar: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell
        cell.configureCellWith(cellState)
        
        let dateString = DateHandler.stringFromDate(date)
        
        if let completedAction = self.dataSource?[dateString], cellState.dateBelongsTo == .thisMonth {
            cell.action(for: dateString, complete: completedAction.eventsCompleted)
        } else {
            cell.action(for: dateString, complete: nil)
        }

        return cell
    }
    
    //handle date selection
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCalendarCell else { return }
        
        if cellState.dateBelongsTo == .thisMonth {
            validCell.configureCellWith(cellState)
            self.previouslySelectedDate = validCell.showInfo ? date : nil
            self.delegate?.hideShowInfoForSelectedDate(cellState.date, show: validCell.showInfo)
            validCell.bounceAnimation()
        } else if let prevDate = previouslySelectedDate {
                calendar.selectDates([prevDate])
        }
    }
    
    //handle date deselection
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCalendarCell else { return }
        validCell.configureCellWith(cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {        
        setMonthYearLabel(from: visibleDates)
    }
}
