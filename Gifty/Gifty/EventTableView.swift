//
//  EventCollectionView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventTableViewDelegate {
    func didTouchAddEventButton()
    func didTouchEditEvent(event: Event)
    func didTouchDeleteEvent(event: Event)
}

class EventTableView: UIView {

    var delegate: EventTableViewDelegate?
    
    var orderedEvents: [Event]? {
        didSet {
            showHideCollectionView()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func showHideCollectionView() {
        if orderedEvents?.count == nil || orderedEvents?.count == 0 {
            eventLabel.isHidden = false
            tableView.isHidden = true
        } else {
            eventLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    var eventLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.lightToneTwo.color
        label.text = "No events created"
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
        tableView.layer.masksToBounds = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.bounces = false
        tableView.isHidden = true
        return tableView
    }()
    
    lazy var addButton: CustomImageControl = {
        let add = CustomImageControl()
        add.imageView.image = UIImage(named: ImageNames.addButton.rawValue)?.withRenderingMode(.alwaysTemplate)
        add.imageView.contentMode = .scaleAspectFill
        add.imageView.tintColor = UIColor.white
        add.addTarget(self, action: #selector(addButtonTouchedDown), for: .touchDown)
        add.addTarget(self, action: #selector(addButtonTouchedUpInside), for: .touchUpInside)
        return add
    }()
    
    var selectedIndexRow: Int = -1
    
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
        let addSize: CGFloat = 30
        addButton.frame = CGRect(x: self.bounds.width - 4 - addSize, y: 4, width: addSize, height: addSize)

        addSubview(tableView)
        tableView.frame = CGRect(x: pad, y: smallPad + addButton.frame.height + smallPad, width: self.bounds.width - pad - pad, height: self.bounds.height - (3 * smallPad) - addButton.frame.height - 35 - smallPad - pad)
        
        addSubview(eventLabel)
        eventLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        eventLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
}


extension EventTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        
        cell.configureWith(event: (orderedEvents?[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let cell = tableView.cellForRow(at: indexPath) as? EventTableViewCell
        if indexPath.row == selectedIndexRow {
            //cell?.isExpandedCell = true
            return 100
        } else {
            //cell?.isExpandedCell = false
            return 62
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        if indexPath.row == selectedIndexRow {
            selectedIndexRow = -1
        } else {
            selectedIndexRow = indexPath.row
        }
        tableView.endUpdates()
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

extension EventTableView {
    
    func addButtonTouchedDown() {
        addButton.imageView.tintColor = Theme.colors.lightToneOne.color
    }
    
    func addButtonTouchedUpInside() {
        addButton.imageView.tintColor = Theme.colors.lightToneTwo.color
        if self.delegate != nil {
            self.delegate?.didTouchAddEventButton()
        }
    }
}
