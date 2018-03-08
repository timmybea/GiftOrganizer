//
//  CreateEventNotificationViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class CreateEventNotificationViewController: CustomViewController {

    var event: Event?
    
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
