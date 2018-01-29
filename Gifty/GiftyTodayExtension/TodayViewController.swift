//
//  TodayViewController.swift
//  GiftyTodayExtension
//
//  Created by Tim Beals on 2018-01-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import NotificationCenter
import GiftyBridge

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var datasource: [Event]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var upcomingEvents: [Event]?
    var overdueEvents: [Event]?
    
    var isExpanded = false
    
    let segControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["upcoming", "overdue"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.backgroundColor = UIColor.white
        seg.tintColor = Theme.colors.lightToneTwo.color
        seg.selectedSegmentIndex = 0
        seg.layer.cornerRadius = 4.0
        seg.clipsToBounds = true
        return seg
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.separatorColor = UIColor.clear
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        layoutSubviews()
        
        guard let frc = EventFRC.frc(), frc.fetchedObjects != nil else { return }
        setupDataSources(for: frc.fetchedObjects!)
    }
    
    func setupDataSources(for orderedEvents: [Event]) {
        EventFRC.sortEventsTodayExtension(events: orderedEvents) { (upcoming, overdue) in
        
            self.overdueEvents = overdue
            self.upcomingEvents = upcoming
            self.datasource = upcoming
            
            if overdueEvents != nil {
                segControl.setTitle("overdue (\(String(describing: overdueEvents!.count)))", forSegmentAt: 1)
            }
        }
    }
    
    
    private func layoutSubviews() {
        
        view.addSubview(segControl)
        segControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: smallPad).isActive = true
        segControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -smallPad).isActive = true
        segControl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .valueChanged)
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 3).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableView.register(TodayEventTableViewCell.self, forCellReuseIdentifier: "todayEventCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        guard let frc = EventFRC.frc(), frc.fetchedObjects != nil else { return }
        setupDataSources(for: frc.fetchedObjects!)
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            isExpanded = true
            preferredContentSize = CGSize(width: 0.0, height: 236.0)
        } else {
            isExpanded = false
            preferredContentSize = maxSize
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc
    func segmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: datasource = upcomingEvents
        case 1: datasource = overdueEvents
        default: print("this should never execute")
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpanded {
            return datasource?.count ?? 0
        } else {
            return datasource != nil ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayEventCell") as! TodayEventTableViewCell
        if let event = datasource?[indexPath.row] {
            cell.configureWith(event: event)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TodayEventTableViewCell
        let event = cell.event
        let dateString = event?.dateString
        if let url = URL(string: "giftyApp://ShowDate/?q=\(dateString!)") {
            self.extensionContext?.open(url, completionHandler: { success in print("called url complete handler: \(success)")})
        }
    }
}
