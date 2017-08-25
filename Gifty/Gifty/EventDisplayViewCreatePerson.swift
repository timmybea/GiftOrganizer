//
//  EventDisplayViewCreatePerson.swift
//  Gifty
//
//  Created by Tim Beals on 2017-08-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventDisplayViewPersonDelegate: EventTableViewDelegate {
    func didTouchAddEventButton()
}

class EventDisplayViewCreatePerson: EventTableView {

    fileprivate var eventDisplayViewPersonDelegate: EventDisplayViewPersonDelegate?
    override var delegate: EventTableViewDelegate? {
        get { return eventDisplayViewPersonDelegate }
        set { self.eventDisplayViewPersonDelegate = newValue as! EventDisplayViewPersonDelegate? }
    }
    
    override internal func updateEventLabelForEventsCount() {
        if let events = orderedEvents, events.count > 0 {
            eventLabel.text = "Upcoming events"
        } else {
            eventLabel.text = "You have no upcoming events"
        }
    }
    
    lazy var addButton: CustomImageControl = {
        let add = CustomImageControl()
        add.imageView.image = UIImage(named: ImageNames.addButton.rawValue)?.withRenderingMode(.alwaysTemplate)
        add.imageView.contentMode = .scaleAspectFit
        add.imageView.tintColor = Theme.colors.lightToneTwo.color
        add.addTarget(self, action: #selector(addButtonTouchedDown), for: .touchDown)
        add.addTarget(self, action: #selector(addButtonTouchedUpInside), for: .touchUpInside)
        return add
    }()
    
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
        addButton.frame = CGRect(x: self.bounds.width - pad - addSize, y: smallPad, width: addSize, height: addSize)
        
        addSubview(tableView)
        tableView.frame = CGRect(x: pad, y: smallPad + addButton.frame.height + smallPad, width: self.bounds.width - pad, height: self.bounds.height - (4 * smallPad) - addButton.frame.height - 35 - pad)
        
        addSubview(eventLabel)
        eventLabel.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive  = true
        eventLabel.bottomAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true
    }
    
}

extension EventDisplayViewCreatePerson {
    
    func addButtonTouchedDown() {
        addButton.imageView.tintColor = Theme.colors.lightToneOne.color
    }
    
    func addButtonTouchedUpInside() {
        addButton.imageView.tintColor = Theme.colors.lightToneTwo.color
        self.eventDisplayViewPersonDelegate?.didTouchAddEventButton()
    }
}

