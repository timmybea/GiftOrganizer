//
//  EventReminderCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class EventReminderCell: UITableViewCell {

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
    
    let leftEdge: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.colors.lightToneOne.color
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.charcoal.color
        label.textAlignment = .left
        label.font = Theme.fonts.subtitleText.font
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.smallText.font
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.lightToneTwo.color
        label.textAlignment = .left
        label.font = Theme.fonts.mediumText.font
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        monthLabel.removeFromSuperview()
        dayLabel.removeFromSuperview()
        leftEdge.removeFromSuperview()
        titleLabel.removeFromSuperview()
        messageLabel.removeFromSuperview()
        statusLabel.removeFromSuperview()
        
        addSubview(leftEdge)
        NSLayoutConstraint.activate([
            leftEdge.leftAnchor.constraint(equalTo: self.leftAnchor),
            leftEdge.topAnchor.constraint(equalTo: self.topAnchor),
            leftEdge.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftEdge.widthAnchor.constraint(equalToConstant: 10)
            ])
        
        addSubview(monthLabel)
        NSLayoutConstraint.activate([
            monthLabel.leftAnchor.constraint(equalTo: leftEdge.rightAnchor, constant: smallPad),
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6)
            ])
        
        addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: -4)
            ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 66),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -100) //<<<This will need to be adjusted
            ])
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -6),
            messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 66),
            messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -100)
            ])
        
        addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: -90),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    func configureCell(notification: EventNotification) {

        if let date = notification.date {
            dayLabel.text = DateHandler.stringDayNum(from: date)
            monthLabel.text = DateHandler.stringMonthAbb(from: date).uppercased()
            
            statusLabel.text = date < Date() ? "SENT" : "PENDING"
        }
        
        if let title = notification.eventTitle {
            titleLabel.text = title
        }
        
        if let msg = notification.message {
            messageLabel.text = msg
        }
    }
}
