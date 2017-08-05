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
    
    lazy var whiteDisplayView: WhiteDisplayView = {
        let view = WhiteDisplayView()
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
        
        if whiteDisplayView.isDescendant(of: self.view) {
            self.view.bringSubview(toFront: whiteDisplayView)
        } else {
            setupDynamicAnimator()
            addWhiteDisplayView()
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
        self.calendar.updateDataSource(stringDateCompleteDict: eventDateCompleteDict)
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
    
    func addWhiteDisplayView()  {
        
        let yOffset = calendar.frame.maxY + pad
        self.whiteDisplayView.frame = self.view.bounds.offsetBy(dx: 0, dy: yOffset)
        view.addSubview(whiteDisplayView)
        
        view.bringSubview(toFront: self.whiteDisplayView)
        
        //pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panRecognizer:)))
        whiteDisplayView.addGestureRecognizer(panGesture)
        
        //collision behavior
        let collisionBehavior = UICollisionBehavior(items: [whiteDisplayView])
        
        //lower boundary
        let boundaryY = whiteDisplayView.frame.origin.y + whiteDisplayView.frame.height
        let boundaryStart = CGPoint(x: 0, y: boundaryY)
        let boundaryEnd = CGPoint(x: whiteDisplayView.frame.width, y: boundaryY)
        collisionBehavior.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        gravityBehavior.addItem(whiteDisplayView)
        
    }
    
    func handlePan(panRecognizer: UIPanGestureRecognizer) {
        
        let currentPosition = panRecognizer.location(in: self.view)
        
        if let dragView = panRecognizer.view {
            if panRecognizer.state == .began {
                let isTouchNearTop = panRecognizer.location(in: dragView).y < 150
                
                if isTouchNearTop {
                    isDragging = true
                    previousPosition = currentPosition
                }
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
    
    func snap(dragView: UIView) {
        
        let viewHasNearedSnapPosition = dragView.frame.origin.y < 130
        
        if viewHasNearedSnapPosition {
            if !isViewSnapped {
                var snapPosition = view.center
                snapPosition.y += UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
                
                snap = UISnapBehavior(item: dragView, snapTo: snapPosition)
                dynamicAnimator.addBehavior(snap!)
                whiteDisplayView.whiteDisplaySnapped()
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
        whiteDisplayView.whiteDisplayTouchedBoundary()
    }

}

//MARK: White Display View Delegate
extension CalendarViewController: WhiteDisplayViewDelegate {
    
    func whiteDisplayPosition(up: Bool) {
        if up {
            print("display view is up")
        } else {
            print("display view is down")
        }
    }
}

//MARK: Event FRC delegate methods (update the calendar datasource)
extension CalendarViewController: NSFetchedResultsControllerDelegate {
    

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //nothing?
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let changedEvent = anObject as! Event
        
        if type == .delete {
            
            if changedEvent.dateString != nil {
                calendar.deleteDateFromDataSource(changedEvent.dateString!)
            } else {
                print("DELETE EVENT ERROR: No date string available")
            }
            
        } else if type == .insert {
            
        } else if type == .update {
            
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //nothing?
    }
    
}


