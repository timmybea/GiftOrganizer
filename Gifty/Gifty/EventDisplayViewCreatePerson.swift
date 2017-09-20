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
    
    lazy var addButton: CustomImageControl = {
        let add = CustomImageControl()
        add.translatesAutoresizingMaskIntoConstraints = false
        add.imageView.image = UIImage(named: ImageNames.addButton.rawValue)?.withRenderingMode(.alwaysTemplate)
        add.imageView.contentMode = .scaleAspectFit
        add.imageView.tintColor = Theme.colors.lightToneTwo.color
        add.addTarget(self, action: #selector(addButtonTouchedDown), for: .touchDown)
        add.addTarget(self, action: #selector(addButtonTouchedUpInside), for: .touchUpInside)
        return add
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Upcoming", "Overdue"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Theme.colors.lightToneTwo.color
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
//        saveButton.delegate = self
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: smallPad).isActive = true
        tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -smallPad).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
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

