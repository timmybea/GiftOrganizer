//
//  CalendarViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class CalendarViewController: CustomViewController {
    
    var frc: NSFetchedResultsController<Event>? = EventFRC.frc()

    var monthYearString = ""
    
    lazy var calendar: CustomCalendar = {
        let frame = CGRect(x: pad, y: 70, width: self.view.bounds.width - (2 * pad), height: 280)
        let calendar = CustomCalendar(frame: frame)
        calendar.delegate = self
        return calendar
    }()
    
    lazy var eventDisplayView: EventDisplayViewCalendar = {
        let view = EventDisplayViewCalendar(frame: self.view.frame, in: self.view)
        view.delegate = self
        return view
    }()
    
    //stack view properties
    var dynamicAnimator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var snap: UISnapBehavior?
    var isDragging = false
    var previousPosition: CGPoint?
    var isViewSnapped = false
    
    var customTransitionDelegate = CustomTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register to listen for NSNotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(actionStateChanged(notification:)), name: Notifications.names.actionStateChanged.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newEventCreated(notification:)), name: Notifications.names.newEventCreated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventDeleted(notification:)), name: Notifications.names.eventDeleted.name, object: nil)
        
        self.frc?.delegate = self
        setupNavigationBar()
        setupSubviews()
        passCalendarDataSource()
 
        let timer = ScheduledTimer()
        timer.delegate = self
    }
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToCreateEvent))
    }
    
    fileprivate func setupSubviews() {
        
        if !calendar.isDescendant(of: self.view) {
            self.view.addSubview(calendar)
        }
        
        if eventDisplayView.isDescendant(of: self.view) {
            self.view.bringSubview(toFront: eventDisplayView)
        } else {
            setupDynamicAnimator()
            addEventDisplayView()
        }
    }
    
    func passCalendarDataSource() {
        
        var eventDateCompleteDict = Dictionary<String, CalendarEventData>()
        
        if let sections = frc?.sections {
            for section in sections {
                
                let dateString = section.name
                
                if let eventsForDate = section.objects as? [Event] {
                    
                    let complete = checkActionsComplete(events: eventsForDate)
                    let eventCount = eventsForDate.count
                
                    let data = CalendarEventData(eventCount: eventCount, eventsCompleted: complete)
    
                    eventDateCompleteDict[dateString] = data
                }
            }
        }
        self.calendar.setDataSource(stringDateCompleteDict: eventDateCompleteDict)
    }
    
    fileprivate func checkActionsComplete(events: [Event]) -> Bool {
        for event in events {
            if event.isComplete == false {
                return false
            }
        }
        return true
    }
    
    //MARK: INTERNAL NOTIFICATION action state changed (sent by event display view cell)

    @objc private func actionStateChanged(notification: NSNotification) {
        
        guard let dateString = notification.userInfo?["dateString"] as? String else { return }
        
        updateCalendarDataSource(dateString: dateString)
    }
    
    //MARK: INTERNAL NOTIFICATION new event created. Update the display view and the calendar action view.
    @objc private func newEventCreated(notification: NSNotification) {
    
        guard let dateString = notification.userInfo?["dateString"] as? String else { return }
        
        if let date = DateHandler.dateFromDateString(dateString) {
            
            if self.eventDisplayView.displayDateString == dateString {
                self.hideShowInfoForSelectedDate(date, show: true)

            }
            
//            if self.eventDisplayView.currentlyDisplaying(dateString: dateString) {
//                
//                self.hideShowInfoForSelectedDate(date, show: true)
//            }
        }
        
        updateCalendarDataSource(dateString: dateString)
    }
    
    fileprivate func updateCalendarDataSource(dateString: String) {
        
        if let date = DateHandler.dateFromDateString(dateString) {
            self.frc = EventFRC.frc(for: date)
            
            if let currFRC = self.frc, let events = currFRC.fetchedObjects {
                let complete = checkActionsComplete(events: events)
                let count = events.count
                
                if count > 0 {
                    calendar.updateDataSource(dateString: dateString, count: count, completed: complete)
                }
            }
        }
    }
    
    //MARK: NOTIFICATION event deleted.
    @objc
    private func eventDeleted(notification:NSNotification) {

        guard let senderId = notification.userInfo?["EventDisplayViewId"] as? String,
            let dateString = notification.userInfo?["dateString"] as? String else { return }
        
        if senderId != eventDisplayView.id {
            calendar.deleteDateFromDataSource(dateString)
            self.updateCalendarDataSource(dateString: dateString)
            
            if self.eventDisplayView.displayDateString == dateString && !isViewSnapped {
                guard let date = DateHandler.dateFromDateString(dateString) else { return }
                self.hideShowInfoForSelectedDate(date, show: true)
            } else if isViewSnapped {
                let index = self.eventDisplayView.currentlyShowingSegment()
                if index == 0 || index == 1 {
                    //is showing events in table view
                    self.eventDisplayView.setOverviewDatasource(for: index)
                }
            }
        }
    }
    
    
    @objc
    func pushToCreateEvent() {
        print("push to create event")
        
        self.titleLabel.isHidden = true
        
        let destination = CreateEventViewController()
        destination.createEventState = .newEventToBeAssigned
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    //MARK: Orientation change methods
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}

//MARK: Calendar Delegate (update month label)
extension CalendarViewController: CustomCalendarDelegate {
    
    func monthYearLabelWasUpdated(_ string: String) {
        self.navigationItem.title = string
        self.monthYearString = string
    }

    
    func hideShowInfoForSelectedDate(_ date: Date, show: Bool) {
            if show {
                print(date)
                frc = EventFRC.frc(for: date)
                frc?.delegate = self
                eventDisplayView.displayDateString = DateHandler.stringFromDate(date)
                eventDisplayView.selectedIndexPath = nil
                eventDisplayView.orderedEvents = frc?.fetchedObjects
            } else {
                print("Don't show info")
                eventDisplayView.displayDateString = nil
                eventDisplayView.orderedEvents = nil
            }
    }
}


//MARK: Scheduled timer (update today view at midnight)
extension CalendarViewController: SchedultedTimerDelegate {
    
    func executeAtMidnight() {
        //SET TODAY!!
    }
}


//MARK: Dynamic Animator for White View
extension CalendarViewController {
    
    func setupDynamicAnimator() {
        
        self.dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        gravityBehavior = UIGravityBehavior()
        gravityBehavior.magnitude = 4
        dynamicAnimator.addBehavior(gravityBehavior)
    }
    
    func addEventDisplayView()  {
        
        let yOffset = calendar.frame.maxY + pad
        self.eventDisplayView.frame = self.view.bounds.offsetBy(dx: 0, dy: yOffset)
        
        if let tabHeight = self.tabBarController?.tabBar.frame.height, let navHeight = self.navigationController?.navigationBar.frame.height {
            eventDisplayView.setTableViewFrame(with: tabHeight, navHeight: navHeight)
        }

        view.addSubview(eventDisplayView)
        view.bringSubview(toFront: self.eventDisplayView)
        
        //collision behavior
        let collisionBehavior = UICollisionBehavior(items: [eventDisplayView])
        
        //lower boundary
        let boundaryY = eventDisplayView.frame.origin.y + eventDisplayView.frame.height
        let boundaryStart = CGPoint(x: 0, y: boundaryY)
        let boundaryEnd = CGPoint(x: eventDisplayView.frame.width, y: boundaryY)
        collisionBehavior.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        gravityBehavior.addItem(eventDisplayView)
        
    }
    
    func snap(dragView: UIView) {
        
        let viewHasNearedSnapPosition = dragView.frame.origin.y < self.view.bounds.height / 3
        
        if !isViewSnapped {
            if viewHasNearedSnapPosition {
                var snapPosition = view.center
                snapPosition.y += UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
                
                snap = UISnapBehavior(item: dragView, snapTo: snapPosition)
                snap?.damping = 1
                dynamicAnimator.addBehavior(snap!)
                eventDisplayView.eventDisplaySnapped()
                isViewSnapped = true
            }
        } else {
            if isViewSnapped {
                dynamicAnimator.removeBehavior(snap!)
                isViewSnapped = false
            }
        }
    }
}


//MARK: Collision Behavior Delegate
extension CalendarViewController: UICollisionBehaviorDelegate {
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        eventDisplayView.eventDisplayTouchedBoundary()
    }

}

//MARK: Event Display View Delegate
extension CalendarViewController: EventDisplayViewCalendarDelegate {
    
    func eventDisplayPosition(up: Bool) {
        if up {
            print("display view is up")
            self.navigationItem.title = "Upcoming Events"
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        } else {
            print("display view is down")
            self.navigationItem.title = monthYearString
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            if let dateString = eventDisplayView.displayDateString, let showDate = DateHandler.dateFromDateString(dateString) {
                hideShowInfoForSelectedDate(showDate, show: true)
            }
        }
    }
    
    
    func stackViewPan(panRecognizer: UIPanGestureRecognizer) {
        
        let currentPosition = panRecognizer.location(in: self.view)
        
        if let dragView = panRecognizer.view?.superview {
            if panRecognizer.state == .began {

                    isDragging = true
                    previousPosition = currentPosition
            } else if panRecognizer.state == .changed && isDragging {
                if let previousPosition = previousPosition {
                    let offset = previousPosition.y - currentPosition.y
                    dragView.center = CGPoint(x: dragView.center.x, y: dragView.center.y - offset)
                }
                previousPosition = currentPosition
            } else if panRecognizer.state == .ended && isDragging {
                
                snap(dragView: dragView)
                
                //Applies behavior to the dynamic item again. Makes it adhere to gravity etc.
                dynamicAnimator.updateItem(usingCurrentState: dragView)
                
                isDragging = false
            }
        }
    }
    
    func segControllerChanged(to title: String) {
        self.navigationItem.title = title
        //get data for piechart
        if title == "Spending \(DateHandler.stringYear())" {
            self.eventDisplayView.pieChartDatasource = PieChartService.shared.getSpendingData()
            self.eventDisplayView.isShowBudget = false
        } else if title == "Budget \(DateHandler.stringYear())" {
            self.eventDisplayView.pieChartDatasource = PieChartService.shared.getBudgetData()
            self.eventDisplayView.isShowBudget = true
        }
    }
}

//MARK: Event FRC delegate methods (update the calendar datasource)
extension CalendarViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //nothing?
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        

    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //nothing?
    }
    
}

extension CalendarViewController: EventTableViewDelegate {
    
    func showBudgetInfo(for event: Event) {
        
        let overlayVC = OverlayEventBudgetViewController()
        self.transitioningDelegate = self.customTransitionDelegate
        overlayVC.transitioningDelegate = self.customTransitionDelegate
        overlayVC.event = event
        overlayVC.modalPresentationStyle = .custom
        
        self.present(overlayVC, animated: true, completion: nil)
        
    }

    
    func didTouchEditEvent(event: Event) {
        
        print("Edit existing event")
        let destination = CreateEventViewController()
        destination.eventToBeEdited = event
        //destination.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func didTouchDeleteEvent(event: Event) {
        guard let dateString = event.dateString else { return }
        event.managedObjectContext?.delete(event)
        
        ManagedObjectBuilder.saveChanges { (success) in
            if success {
                print("successfully deleted event")
                
                let notificationDispatch = DispatchQueue(label: "notificationQueue", qos: DispatchQoS.userInitiated)
                
                notificationDispatch.async {
                    let userInfo = ["EventDisplayViewId": self.eventDisplayView.id]
                    NotificationCenter.default.post(name: Notifications.names.eventDeleted.name, object: nil, userInfo: userInfo)
                }
                
                calendar.deleteDateFromDataSource(dateString)
                self.updateCalendarDataSource(dateString: dateString)

            }
        }
    }
    
    func didTouchBegin() {
        //DO NOTHING
    }
}


