//
//  NotificationViewController.swift
//  GiftyNotificationExtension
//
//  Created by Tim Beals on 2018-03-12.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
//import GiftyBridge

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = Theme.fonts.dateMonth.font
        label.textAlignment = .center
        label.text = "MAR"
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = Theme.fonts.dateDay.font
        label.text = "24"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.bounds.size = CGSize(width: 320, height: 60)
        self.view.backgroundColor = UIColor.clear
    
        setupSubviews()
    }
    
    func setupSubviews() {
        
        view.addSubview(monthLabel)
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        view.addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: -4),
            dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor)
            ])
    }
    
    func didReceive(_ notification: UNNotification) {
        guard let date = notification.request.content.userInfo["date"] as? Date else { return }
        
//        monthLabel.text = DateHandler.stringMonthAbb(from: date).uppercased()
//        dayLabel.text = DateHandler.stringDayNum(from: date)
    }

}
