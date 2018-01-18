//
//  TodayViewController.swift
//  GiftyTodayExtension
//
//  Created by Tim Beals on 2018-01-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var datasource = ["first item", "second item", "third item"]
    
    let segControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["upcoming", "overdue"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.backgroundColor = UIColor.white
        seg.tintColor = Theme.colors.lightToneTwo.color
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        
        view.addSubview(segControl)
        segControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segControl.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableView.register(DemoTableViewCell.self, forCellReuseIdentifier: "demoCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: 300.0)
        } else {
            preferredContentSize = maxSize
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell") as! DemoTableViewCell
        cell.backgroundColor = UIColor.blue
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
