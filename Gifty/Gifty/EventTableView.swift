//
//  EventCollectionView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventTableViewDelegate {
    func didTouchEditEvent(event: Event)
    func didTouchDeleteEvent(event: Event)
    func showBudgetInfo(for event: Event)
}

class EventTableView: UIView {

    var delegate: EventTableViewDelegate?
    
    var orderedEvents: [Event]? {
        didSet {
            datasource = orderedEvents
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var datasource: [Event]?
    
//    func updateEventLabelForEventsCount() {
//        if let events = orderedEvents, events.count > 0 {
//            eventLabel.text = "Upcoming events"
//        } else {
//            eventLabel.text = "You have no upcoming events"
//        }
//    }
    
    var displayDateString: String? = nil
    
//    var eventLabel: UILabel = {
//        var label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = Theme.colors.lightToneTwo.color
//        label.text = "You have no upcoming events"
//        label.textAlignment = .left
//        label.font = Theme.fonts.subtitleText.font
//        label.isHidden = false
//        return label
//    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.bounces = false
        return tableView
    }()
    
    var selectedIndexPath: IndexPath?
    
    let id = UUID().uuidString
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Register to listen for NSNotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(actionStateChanged(notification:)), name: Notifications.names.actionStateChanged.name, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func actionStateChanged(notification: NSNotification) {
        if let senderId = notification.userInfo?["EventDisplayViewId"] as? String, senderId != self.id {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension EventTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        cell.delegate = self
        cell.configureWith(event: (datasource?[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return 100
        } else {
            return 62
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
            cell.showActionsButtonsView()
        }
        
        tableView.beginUpdates()
        if selectedIndexPath != nil, let prevCell = tableView.cellForRow(at: selectedIndexPath!) as? EventTableViewCell {
            prevCell.hideActionsButtonsView()
        }
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        tableView.endUpdates()
        
        CATransaction.commit()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: " Edit ") { (action, indexPath) in
            if self.delegate != nil, let event = self.datasource?[indexPath.row] {
                self.delegate?.didTouchEditEvent(event: event)
            }
        }
        editAction.backgroundColor = Theme.colors.yellow.color
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if self.delegate != nil, let event = self.datasource?[indexPath.row] {
               self.datasource?.remove(at: indexPath.row)
                self.delegate?.didTouchDeleteEvent(event: event)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
        return [deleteAction, editAction]
    }
}

//MARK: Event Cell Delegate (Save change to event)
extension EventTableView: EventTableViewCellDelegate {
    
    func budgetButtonTouched(for event: Event) {
        
        if self.delegate != nil {
            self.delegate?.showBudgetInfo(for: event)
        }

    }
    
    
    func setAction(_ action: ActionButton.Actions, to state: ActionButton.SelectionStates, for event: Event) {
        
        let currentEvent = event
        
        if action == ActionButton.Actions.gift {
            currentEvent.giftState = state.rawValue
        } else if action == ActionButton.Actions.card {
            currentEvent.cardState = state.rawValue
        } else if action == ActionButton.Actions.phone {
            currentEvent.phoneState = state.rawValue
        }
        print("\(currentEvent.type!): \(action) was changed to state: \(state.rawValue)")
        
        _ = ManagedObjectBuilder.setEventComplete(currentEvent)
        
        ManagedObjectBuilder.saveChanges { (success) in
            print("saved successfully")
            
            //send notification
            guard let dateString = event.dateString else { return }
            
            let userInfo = ["EventDisplayViewId": self.id, "dateString": dateString]
            NotificationCenter.default.post(name: Notifications.names.actionStateChanged.name, object: nil, userInfo: userInfo)
            
            //update cell subviews according to checklist completion
            if self.selectedIndexPath != nil, let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as? EventTableViewCell {
                cell.configureWith(event: datasource![self.selectedIndexPath!.row])
            }
        }
    }
    
    
}
