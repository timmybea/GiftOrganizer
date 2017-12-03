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
    func didTouchBegin()
}

class EventTableView: UIView {

    var delegate: EventTableViewDelegate?
    
    var orderedEvents: [Event]? {
        didSet {
            if orderedEvents != nil {
                datasource = [TableSectionEvent(header: nil, events: orderedEvents!)]
            }
        }
    }

    var datasource: [TableSectionEvent]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var showSections = false
    
    var displayDateString: String? = nil //>>>>
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.bounces = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchesInTV(sender:)))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
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
    
    //drop down keyboard if textfield is editing.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.didTouchBegin()
    }

    @objc func touchesInTV(sender: UITapGestureRecognizer) {
        self.delegate?.didTouchBegin()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard showSections && datasource != nil else { return 1 }
        var count = 0
        for section in datasource! where section.events.count > 0 {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?[section].events.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        cell.delegate = self
        cell.configureWith(event: (datasource?[indexPath.section].events[indexPath.row])!)
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
            if self.delegate != nil, let event = self.datasource?[indexPath.section].events[indexPath.row] {
                self.delegate?.didTouchEditEvent(event: event)
            }
        }
        editAction.backgroundColor = Theme.colors.yellow.color
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if self.delegate != nil, let event = self.datasource?[indexPath.section].events[indexPath.row] {
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
                let event = self.datasource![(selectedIndexPath?.section)!].events[(selectedIndexPath?.row)!]
                cell.configureWith(event: event)
            }
        }
    }
    
    
}
