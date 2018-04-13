//
//  ReminderTableviewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-16.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class CENNotificationsVC: CustomViewController {

    var datasource: [EventNotification]? {
        didSet {
            noNotifications()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var event: Event?
    
    //MARK: VIEWS
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 62
        tv.backgroundColor = UIColor.clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(CENReminderTableViewCell.self, forCellReuseIdentifier: "EventReminderCell")
        return tv
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = Theme.fonts.dateMonth.font
        label.textAlignment = .center
        label.text = "MAR"
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = Theme.fonts.dateDay.font
        label.text = "24"
        return label
    }()
    
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = Theme.fonts.subtitleText.font
        return label
    }()
    
    let noRemindersLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.colors.textLightTone.color
        label.textAlignment = .center
        label.font = Theme.fonts.subtitleText.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have not created any reminders for this event."
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
    }

    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain, target: self,
                                         action: #selector(backButtonTouched(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.title = "Reminders"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addEventNotificationTouched(sender:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillLayoutSubviews() {
        //remove views before adding them to avoid duplication
        eventTypeLabel.removeFromSuperview()
        dayLabel.removeFromSuperview()
        monthLabel.removeFromSuperview()
        tableView.removeFromSuperview()
        
        view.addSubview(monthLabel)
        NSLayoutConstraint.activate([
            monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monthLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70)
            ])
        
        view.addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: -4),
            dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor)
            ])
        
        view.addSubview(eventTypeLabel)
        NSLayoutConstraint.activate([
            eventTypeLabel.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            eventTypeLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -4)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: pad),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewsWithEvent()
        setupDatasourceWithEvent()
    }
    

    func setupViewsWithEvent() {
        guard let event = self.event else { return }
        
            if let fullName = event.person?.fullName, let type = event.type {
                eventTypeLabel.text = "\(fullName) • \(type)"
            }
            if let date = event.date {
                self.dayLabel.text = DateHandler.stringDayNum(from: date)
                self.monthLabel.text = DateHandler.stringMonthAbb(from: date).uppercased()
            }
    }
    
    private func setupDatasourceWithEvent() {
        guard let notifications = event?.eventNotification as? Set<EventNotification> else { datasource = nil; return }
        datasource = Array(notifications).sorted() { $0.date! < $1.date! }
    }
    
    @objc
    func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func addEventNotificationTouched(sender: UIBarButtonItem) {
        let dest = CreateEventNotificationVC()
        dest.event = self.event
        dest.delegate = self
        self.navigationController?.pushViewController(dest, animated: true)
    }
}

extension CENNotificationsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventReminderCell") as? CENReminderTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if let eventNotification = datasource?[indexPath.row] {
            cell.configureCell(notification: eventNotification)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                //remove from data source and table
                tableView.beginUpdates()
                let notification = self.datasource!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                let builder = EventNotificationBuilder.updateNotification(notification)
                builder.deleteNotification()
                builder.saveChanges(DataPersistenceService.shared, completion: {
                    //do nothing
                })

            }
            deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
            
            return [deleteAction]
    }
    
    private func noNotifications() {
        
        if datasource?.count == 0 {
            view.addSubview(noRemindersLabel)
            NSLayoutConstraint.activate([
                noRemindersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: pad),
                noRemindersLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -pad),
                noRemindersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
        } else {
            noRemindersLabel.removeFromSuperview()
        }
    }
    
    //Mark: ensure that editing is available for all cells except pieChartCll
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CENReminderTableViewCell else { return }
        cell.setCompleted()
    }
}

extension CENNotificationsVC : CENReminderCellDelegate {
    
    func set(notification: EventNotification, completed: Bool) {
        
        notification.completed = completed

        if let moc = DataPersistenceService.shared.mainQueueContext {
            DataPersistenceService.shared.saveToContext(moc, completion: {
                //do nothing
            })
        }
    }
}

extension CENNotificationsVC : CreateEventNotificationDelegate {
    
    func newNotificationCreated() {
        setupDatasourceWithEvent()
    }
}
