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
    func setAction(_ action: Actions, to state: ActionSelectionStates)
}

class EventTableView: UIView {

    var delegate: EventTableViewDelegate?
    
    var orderedEvents: [Event]? {
        didSet {
            updateEventLabelForEventsCount()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func updateEventLabelForEventsCount() {
        if let events = orderedEvents, events.count > 0 {
            eventLabel.text = "Upcoming events"
        } else {
            eventLabel.text = "You have no upcoming events"
        }
    }
    
    var eventLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.lightToneTwo.color
        label.text = "No upcoming events"
        label.textAlignment = .left
        label.font = Theme.fonts.subtitleText.font
        label.isHidden = false
        return label
    }()
    
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

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension EventTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        cell.delegate = self
        cell.configureWith(event: (orderedEvents?[indexPath.row])!)
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
            if self.delegate != nil, let event = self.orderedEvents?[indexPath.row] {
                self.delegate?.didTouchEditEvent(event: event)
            }
        }
        editAction.backgroundColor = Theme.colors.yellow.color
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if self.delegate != nil, let event = self.orderedEvents?[indexPath.row] {
                self.delegate?.didTouchDeleteEvent(event: event)
            }
            self.orderedEvents?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
        return [deleteAction, editAction]
    }
    
}

//MARK: Event Cell Delegate (Save change to event)
extension EventTableView: EventTableViewCellDelegate {
    func setAction(_ action: Actions, to state: ActionSelectionStates, for event: Event) {
        
        let currentEvent = event
        
        if action == Actions.gift {
            
            currentEvent.giftState = state.rawValue
            
        } else if action == Actions.card {
            
            currentEvent.cardState = state.rawValue
            
        } else if action == Actions.phone {
            
            currentEvent.phoneState = state.rawValue
            
        }
        print("\(currentEvent.type!): \(action) was changed to state: \(state.rawValue)")
        
        _ = ManagedObjectBuilder.setEventComplete(currentEvent)
        
        ManagedObjectBuilder.saveChanges { (success) in
            print("saved successfully")
            
            //update cell subviews according to checklist completion
            if self.selectedIndexPath != nil, let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as? EventTableViewCell {
                cell.configureWith(event: orderedEvents![self.selectedIndexPath!.row])
            }
        }
    }
}
