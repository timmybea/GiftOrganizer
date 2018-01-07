//
//  WhiteDisplayView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventDisplayViewCalendarDelegate: EventTableViewDelegate {
    func eventDisplayPosition(up: Bool)
    func stackViewPan(panRecognizer: UIPanGestureRecognizer)
    func segControllerChanged(to title: String)
}

class EventDisplayViewCalendar: EventTableView {

    private var eventDisplayViewDelegate: EventDisplayViewCalendarDelegate?
    override var delegate: EventTableViewDelegate? {
        set { self.eventDisplayViewDelegate = newValue as! EventDisplayViewCalendarDelegate? }
        get { return self.eventDisplayViewDelegate }
    }
    
    var isSnapped = false
    
    private var upcomingEvents = [TableSectionEvent]()
    private var overdueEvents = [TableSectionEvent]()
    private var tempEventHolder: [TableSectionEvent]?
    
    var showingIndex = 0
    
    let swipeIcon: UIImageView = {
        let swipeIcon = UIImage(named: ImageNames.swipeIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: swipeIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Theme.colors.lightToneTwo.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.colors.lightToneOne.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let panGestureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var header: EventDisplayHeader = {
        let view = EventDisplayHeader(with: self.frame.width - pad)
        view.delegate = self
        return view
    }()
    
    init(frame: CGRect, in superView: UIView) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.colors.offWhite.color
        setupSubviews(in: superView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(in superView: UIView) {
        
        self.addSubview(swipeIcon)
        swipeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        swipeIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        swipeIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        swipeIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        swipeIcon.transform = swipeIcon.transform.rotated(by: CGFloat.pi)
        
        self.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.addSubview(panGestureView)
        panGestureView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        panGestureView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        panGestureView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        panGestureView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panRecognizer:)))
        panGestureView.addGestureRecognizer(panGesture)

    }
    //MARK: Set datasource
    func setOverviewDatasource(for segment: Int) {
        print("SET DATASOURCE FOR OVERVIEW")
        guard let allEvents = EventFRC.frc()?.fetchedObjects else { return }
        EventFRC.sortEventsIntoUpcomingAndOverdue(events: allEvents, sectionHeaders: true) { (upcoming, overdue) in
            self.upcomingEvents = upcoming
            self.overdueEvents = overdue
            var overdueCount = overdueEvents.first?.events.count ?? 0
            header.updateOverdue(count: overdueCount)
            self.displayMode = .sectionHeader
            switch segment {
            case 0: self.datasource = upcoming
            case 1: self.datasource = overdue
            default: print("You entered an invalid section")
            }
        }
    }
    
    func dataSourceDidChange() {
        guard let datasource = datasource else { return }
        //datasource changed so update upcoming or overdue
        if showingIndex == 0 {
            upcomingEvents = datasource
        } else if showingIndex == 1 {
            overdueEvents = datasource
            self.header.updateOverdue(count: overdueEvents.count)
        }
    }
    
    
    //MARK: setup pan
    @objc func handlePan(panRecognizer: UIPanGestureRecognizer) {
            self.eventDisplayViewDelegate?.stackViewPan(panRecognizer: panRecognizer)
    }
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    var tableViewHeightDown: CGFloat = 0.0
    var tableViewHeightUp: CGFloat = 0.0
    
    func setTableViewFrame(with tabHeight: CGFloat, navHeight: CGFloat) {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewHeightDown = self.frame.height - self.frame.minY - 34 - tabHeight
        self.tableViewHeightUp = self.frame.height - smallPad - 34 - tabHeight - pad - navHeight
            
        addSubview(tableView)
        tableView.frame = CGRect(x: pad, y: 34, width: self.frame.width - pad, height: tableViewHeightDown)
        header.setFrame(appear: false)
        tableView.tableHeaderView = header

    }
    
    func eventDisplaySnapped() {
        
        isSnapped = true
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
            
            self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
            self.tableView.frame = CGRect(x: pad, y: 34, width: self.frame.width - pad, height: self.tableViewHeightUp)
            self.header.setFrame(appear: true)
            self.tableView.tableHeaderView = self.header
            self.selectedIndexPath = nil

        }, completion: { (success) in
            self.header.headerAppearAnimation()
        })
        self.eventDisplayViewDelegate?.eventDisplayPosition(up: true)
        self.header.resetSegControl()
        self.setOverviewDatasource(for: 0)
    }
    
    func eventDisplayTouchedBoundary() {
        if isSnapped == true {
            isSnapped = false
            eventDisplayDown()
        }
    }
    
    func currentlyShowingSegment() -> Int {
        return header.showingTableViewForSegment()
    }
    
    private func eventDisplayDown() {
        
        header.headerDisappearAnimation { (success) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
                self.tableView.frame = CGRect(x: pad, y: 34, width: self.frame.width - pad, height: self.tableViewHeightDown)
            }, completion: { (success) in
                self.header.setFrame(appear: false)
                self.displayMode = .normal
                self.selectedIndexPath = nil
                self.tableView.reloadData()
            })
        }
        self.eventDisplayViewDelegate?.eventDisplayPosition(up: false)
    }
    
    
}

//MARK: EVENT DISPLAY HEADER DELEGATE
extension EventDisplayViewCalendar: EventDisplayViewHeaderDelegate {
   
    func segControlChanged(to index: Int) {
        
        var navTitle: String = ""
        if index == 0 {
            self.displayMode = .sectionHeader
            self.datasource = self.upcomingEvents
            self.showingIndex = 0
            navTitle = "Upcoming Events"
        } else if index == 1 {
            self.displayMode = .normal
            self.datasource = self.overdueEvents
            self.showingIndex = 1
            navTitle = "Overdue Events"
        } else if index == 2 {
            self.displayMode = .pieChart
            self.showingIndex = 2
            navTitle = "Spending \(DateHandler.stringYear())"
        } else if index == 3 {
            self.displayMode = .pieChart
            self.showingIndex = 3
            navTitle = "Budget \(DateHandler.stringYear())"
        }
        self.eventDisplayViewDelegate?.segControllerChanged(to: navTitle)
    }
}
