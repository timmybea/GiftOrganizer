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
    
    lazy var calendar: CustomCalendar = {
        let frame = CGRect(x: pad, y: 70, width: self.view.bounds.width - (2 * pad), height: 280)
        let calendar = CustomCalendar(frame: frame)
        calendar.delegate = self
        return calendar
    }()
    
    lazy var eventDisplayView: EventDisplayViewCalendar = {
        let view = EventDisplayViewCalendar(frame: self.view.frame, in: self.view)
        view.stackViewDelegate = self
        return view
    }()
    
    //stack view properties
    var dynamicAnimator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var snap: UISnapBehavior?
    var isDragging = false
    var previousPosition: CGPoint?
    var isViewSnapped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        var eventDateCompleteDict = Dictionary<String, Bool>()
        
        if let sections = frc?.sections {
            for section in sections {
                
                let dateString = section.name
                
                var complete = false
                
                if let eventsForDate = section.objects as? [Event] {
                    for event in eventsForDate {
                        
                        if event.isComplete == true {
                            complete = true
                        }
                    }
                }
                eventDateCompleteDict[dateString] = complete
            }
        }
        self.calendar.setDataSource(stringDateCompleteDict: eventDateCompleteDict)
    }
    
    func pushToCreateEvent() {
        print("push to create event")
    }

    //MARK: Orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}

//MARK: Calendar Delegate (update month label)
extension CalendarViewController: CustomCalendarDelegate {
    
    func monthYearLabelWasUpdated(_ string: String) {
        self.title = string
    }

    
    func hideShowInfoForSelectedDate(_ date: Date, show: Bool) {
            if show {
                print(date)
                frc = EventFRC.frc(for: date)
                frc?.delegate = self
                eventDisplayView.orderedEvents = frc?.fetchedObjects
            } else {
                print("Don't show info")
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
        //let maxY = self.view.frame.maxY - (self.tabBarController?.tabBar.frame.height)! - smallPad
        //eventDisplayView.setTableViewFrame(with: maxY)
        
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
        
        let viewHasNearedSnapPosition = dragView.frame.origin.y < 130
        
        if viewHasNearedSnapPosition {
            if !isViewSnapped {
                var snapPosition = view.center
                snapPosition.y += UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
                
                snap = UISnapBehavior(item: dragView, snapTo: snapPosition)
                dynamicAnimator.addBehavior(snap!)
                eventDisplayView.eventDisplaySnapped()
                //changeStackViewAlpha(currentView: dragView)
                isViewSnapped = true
            }
        } else {
            if isViewSnapped {
                dynamicAnimator.removeBehavior(snap!)
                //changeStackViewAlpha(currentView: dragView)
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
extension CalendarViewController: StackViewDelegate {
    
    func eventDisplayPosition(up: Bool) {
        if up {
            print("display view is up")
        } else {
            print("display view is down")
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
}

//MARK: Event FRC delegate methods (update the calendar datasource)
extension CalendarViewController: NSFetchedResultsControllerDelegate {
    

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //nothing?
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let changedEvent = anObject as? Event, let dateString = changedEvent.dateString {
            if type == .delete {
                
                calendar.deleteDateFromDataSource(dateString)
                
            } else if type == .insert || type == .update {
                
                calendar.updateDataSource(dateString: dateString, completed: changedEvent.isComplete)
                
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //nothing?
    }
    
}


