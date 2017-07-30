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

class CustomCalendar: UIView {
    
    fileprivate let gregorianCalendar: Calendar = Calendar(identifier: .gregorian)
    
    var delegate: CustomCalendarDelegate?
    
    var eventDateCompleteDict: Dictionary<String, Bool>?
    
    var previouslySelectedDate: Date?
    
    private let dateFormatter = DateFormatter()
    
//    var initiallySelectedDate: Date? {
//        didSet {
//            if initiallySelectedDate != nil {
//                calendarView.selectDates([initiallySelectedDate!])
//            }
//            DispatchQueue.main.async {
//                self.calendarView.reloadData()
//            }
//        }
//    }
    
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
        setupCalendarView()
        scrollToThisMonth()
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
        let today = Date()
        let value = (Calendar.current.component(.weekday, from: today) - 1) * -1
        let scrollDate = gregorianCalendar.date(byAdding: .weekday, value: value, to: today)!
        
        self.calendarView.scrollToDate(scrollDate, triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) {
            
            self.calendarView.collectionViewLayout.invalidateLayout()
            
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
    }
    
    fileprivate func setMonthYearLabel(from visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            dateFormatter.dateFormat = "MMMM YYYY"
            monthYearLabel.text = dateFormatter.string(from: date)
            self.delegate?.monthYearLabelWasUpdated(monthYearLabel.text!)
        }
    }
    
    func updateDataSource(stringDateCompleteDict: Dictionary<String, Bool>) {
        
        self.eventDateCompleteDict = stringDateCompleteDict
        
        reloadAllDatesFromDataSource()
    }
    
    func reloadAllDatesFromDataSource() {

        if let keysCollection = self.eventDateCompleteDict?.keys {
            
            let keysArray = Array(keysCollection)
            
            var reloadDates = [Date]()
            
            for key in keysArray {
                
                let components = key.components(separatedBy: " ")
                
                if let date = DateHandler.dateWith(dd: components[2], MM: components[1], yyyy: components[0]) {
                    
                    print(date)
                    reloadDates.append(date)
                }
            }
            
            calendarView.reloadDates(reloadDates)
        }
    }
    
}

extension CustomCalendar: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let start = gregorianCalendar.date(byAdding: .year, value: -1, to: Date())!
        let end = gregorianCalendar.date(byAdding: .year, value: 1, to: Date())!
        
        let parameters = ConfigurationParameters(startDate: start,
                                                 endDate: end,
                                                 numberOfRows: 6,
                                                 calendar: gregorianCalendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: false)
        return parameters
    }
}

extension CustomCalendar: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell
        cell.configureCellWith(cellState)
        
        let dateString = DateHandler.stringFromDate(date)
        

        if let completedAction = self.eventDateCompleteDict![dateString], cellState.dateBelongsTo == .thisMonth {
            cell.action(for: dateString, complete: completedAction)
        }

        return cell
    }
    
    //handle date selection
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCalendarCell else { return }
        
        if cellState.dateBelongsTo == .thisMonth {
            validCell.configureCellWith(cellState)
            self.previouslySelectedDate = date
            self.delegate?.hideShowInfoForSelectedDate(cellState.date, show: validCell.showInfo)
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
