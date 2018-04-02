//
//  EventDisplayViewCreatePerson.swift
//  Gifty
//
//  Created by Tim Beals on 2017-08-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol EventDisplayViewPersonDelegate: EventTableViewDelegate {
    func didTouchAddEventButton()
    func didTouchSaveButton()
}

class EventDisplayViewCreatePerson: EventTableView {

    fileprivate var eventDisplayViewPersonDelegate: EventDisplayViewPersonDelegate?
    override var delegate: EventTableViewDelegate? {
        get { return eventDisplayViewPersonDelegate }
        set { self.eventDisplayViewPersonDelegate = newValue as! EventDisplayViewPersonDelegate? }
    }
    
    private var upcomingEvents: [TableSectionEvent]?
    private var overdueEvents: [TableSectionEvent]?
    
    lazy var addButton: CustomImageControl = {
        let add = CustomImageControl()
        add.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: ImageNames.addButton.rawValue)?.withRenderingMode(.alwaysTemplate) {
            add.setDefaultImage(image)
        }
        add.setTintColor(Theme.colors.lightToneTwo.color)
        add.addTarget(self, action: #selector(addButtonTouchedDown), for: .touchDown)
        add.addTarget(self, action: #selector(addButtonTouchedUpInside), for: .touchUpInside)
        return add
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Upcoming", "Overdue"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Theme.colors.lightToneTwo.color
        segmentedControl.addTarget(self, action: #selector(valueChangedFor(sender:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    var saveButton: ButtonTemplate = ButtonTemplate()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        
        backgroundColor = Theme.colors.offWhite.color
        
        addSubview(addButton)
        let addSize: CGFloat = 22
        addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: addSize).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: addSize).isActive = true
        
        addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -pad).isActive  = true
        segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: smallPad).isActive = true

        addButton.centerYAnchor.constraint(equalTo: segmentedControl.centerYAnchor).isActive = true
        
        addSubview(saveButton)
        saveButton.setTitle("SAVE")
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        saveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: saveButton.defaultHeight).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -smallPad).isActive = true
        saveButton.delegate = self
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: smallPad).isActive = true
        tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -smallPad).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func setupDataSources(for orderedEvents: [Event]) {
        EventFRC.sortEventsIntoUpcomingAndOverdue(events: orderedEvents, sectionHeaders: false) { (upcoming, overdue) in
            
            upcomingEvents = upcoming
            overdueEvents = overdue
            
            var title = "Overdue"
            if let overdueCount = overdueEvents?[0].events.count, overdueCount > 0 {
                title = "Overdue (\(overdueCount))"
            }
            DispatchQueue.main.async {
                self.segmentedControl.setTitle(title, forSegmentAt: 1)
                self.datasource = self.segmentedControl.selectedSegmentIndex == 0 ? self.upcomingEvents : self.overdueEvents
            }
            
        }
    }
    
    @objc private func valueChangedFor(sender: UISegmentedControl) {
        datasource = sender.selectedSegmentIndex == 0 ? upcomingEvents : overdueEvents
    }
}

extension EventDisplayViewCreatePerson {
    
    @objc func addButtonTouchedDown() {
        addButton.setTintColor(Theme.colors.lightToneOne.color)
    }
    
    @objc func addButtonTouchedUpInside() {
        addButton.setTintColor(Theme.colors.lightToneTwo.color)
        self.eventDisplayViewPersonDelegate?.didTouchAddEventButton()
    }
}


extension EventDisplayViewCreatePerson: ButtonTemplateDelegate {
    func buttonWasTouched() {
        self.eventDisplayViewPersonDelegate?.didTouchSaveButton()
        
    }
}
