//
//  CreateEventNotificationViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class CreateEventNotificationVC: CustomViewController {

    var event: Event?
    
    var notificationDate: Date?
    
    var datasource = CENTableViewData.getData()
    
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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.clear
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = Theme.colors.offWhite.color
        return tv
    }()
    
    var tvBottomConstraint: NSLayoutConstraint!
    
    let saveButton: ButtonTemplate = {
        let b = ButtonTemplate()
        b.setTitle("SAVE")
        return b
    }()
    
    private var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        saveButton.addTarget(self, action: #selector(saveButtonTouched(sender:)), for: .touchUpInside)
        layoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.register(CENTitleTableViewCell.self, forCellReuseIdentifier: "CENtitle")
        tableView.register(CENDateTableViewCell.self, forCellReuseIdentifier: "CENdate")
        
        
//        guard let event = self.event else { return }
//        let nb = EventNotificationBuilder.newNotificaation(for: event)
//        nb.moBuilder.addDate(Date(timeInterval: 30.0, since: Date()))
//            .addMessage("This is my message")
//            .addTitle("Hello!")
//        _ = nb.createNewNotification()
//        nb.saveChanges(DataPersistenceService.shared)
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain, target: self, action: #selector(backButtonTouched(sender:)))
        navigationItem.leftBarButtonItem = backButton
        
        title = "New Reminder"
    }
    
    private func layoutSubviews() {
        
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
        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = Theme.colors.offWhite.color
        
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgView.heightAnchor.constraint(equalToConstant: tabBarHeight + pad + 35 + pad),
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: pad),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        tvBottomConstraint = NSLayoutConstraint(item: tableView,
                                                            attribute: .bottom,
                                                            relatedBy: .equal,
                                                            toItem: bgView,
                                                            attribute: .top,
                                                            multiplier: 1,
                                                            constant: 0)
        tvBottomConstraint.isActive = true

        view.addSubview(saveButton)
        let buttonframe = CGRect(x: pad,
                                 y: view.bounds.height - tabBarHeight - pad - 35,
                                 width: view.bounds.width - pad - pad,
                                 height: 35)
        saveButton.frame = buttonframe
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewsWithEvent()
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
    
    @objc
    func backButtonTouched(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func saveButtonTouched(sender: UIButton) {
        print("Save button touched")
    }
}

//MARK: Keyboard notification handler
extension CreateEventNotificationVC {
    
    @objc
    func handleKeyboardNotification(sender: Notification) {
        
        if let userInfo = sender.userInfo {
            guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            let keyboardUp = sender.name == Notification.Name.UIKeyboardWillShow
            tvBottomConstraint.constant = keyboardUp ? CGFloat(-keyboardFrame.height) : -tabBarHeight + 40
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                
            })
        }
    }
    
    func addDateWasSelected() {
        let destination = DatePickerViewController()
        destination.delegate = self
        
        self.navigationController?.pushViewController(destination, animated: true)
    }

}

extension CreateEventNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = datasource[indexPath.row]
        switch type {
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CENdate") as? CENDateTableViewCell
            return cell!
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CENtitle") as? CENTitleTableViewCell
            return cell!
        case .body:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = datasource[indexPath.row]
        switch type {
        case .date:
            return 60
        case .title:
            return 50
        case .body:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = datasource[indexPath.row]
        switch type {
        case .date:
            addDateWasSelected()
        case .title:
            print("Title selected")
        case .body:
            print("body selected")
        }
    }
}

extension CreateEventNotificationVC : DatePickerViewControllerDelegate {
    
    func didSetDate(_ date: Date?) {
        let ip = IndexPath(row: 0, section: 0) //hard code
        if let cell = tableView.cellForRow(at: ip) as? CENDateTableViewCell {
            cell.updateLabel(with: date)
        }
    }
}
