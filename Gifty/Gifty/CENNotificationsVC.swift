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
        tv.backgroundColor = Theme.colors.offWhite.color
        tv.separatorStyle = .singleLine
        tv.separatorColor = Theme.colors.lightToneTwo.color
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
    
    
//    let customBackground: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 8
//        return view
//    }()
    
//    lazy var actionsButtonsView: ActionsButtonsView = {
//        let view = ActionsButtonsView(imageSize: 34, actionsSelectionType: ActionButton.SelectionTypes.checkList)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.delegate = self
//        return view
//    }()
    
//    let completionIcon: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: ImageNames.incompleteIcon.rawValue)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentMode = .scaleAspectFill
//        return view
//    }()
//
//    let summaryLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = UIColor.lightGray
//        label.textAlignment = .left
//        label.font = Theme.fonts.smallText.font
//        return label
//    }()
    
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
        tableView.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: pad).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
                builder.saveChanges(DataPersistenceService.shared)

            }
            deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
            
            return [deleteAction]
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
            DataPersistenceService.shared.saveToContext(moc)
        }
    }
    
    
    
    
}
