//
//  EventReminderCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol CENReminderCellDelegate {
    func set(notification: EventNotification, completed: Bool)
}

class CENReminderTableViewCell: UITableViewCell {
    
    var notification: EventNotification?
    var delegate: CENReminderCellDelegate?
    
    var completed = false {
        didSet {
            self.updateCompletedIcon()
            if let n = self.notification {
                self.delegate?.set(notification: n, completed: completed)
            }
        }
    }
    
//    let monthLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = Theme.colors.lightToneTwo.color
//        label.font = Theme.fonts.dateMonth.font
//        label.textAlignment = .center
//        label.text = "MAR"
//        return label
//    }()
//
//    let dayLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.textColor = Theme.colors.lightToneTwo.color
//        label.font = Theme.fonts.dateDay.font
//        label.text = "24"
//        return label
//    }()
    
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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.mediumText.font
        return label
    }()
    
//    let statusLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = Theme.colors.lightToneTwo.color
//        label.textAlignment = .left
//        label.font = Theme.fonts.mediumText.font
//        return label
//    }()
    
    let completionIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.incompleteIcon.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
//        monthLabel.removeFromSuperview()
//        dayLabel.removeFromSuperview()
//        leftEdge.removeFromSuperview()
//        titleLabel.removeFromSuperview()
//        messageLabel.removeFromSuperview()
//        statusLabel.removeFromSuperview()
        
        addSubview(leftEdge)
        NSLayoutConstraint.activate([
            leftEdge.leftAnchor.constraint(equalTo: leftAnchor),
            leftEdge.topAnchor.constraint(equalTo: topAnchor),
            leftEdge.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftEdge.widthAnchor.constraint(equalToConstant: 10)
            ])
        
        addSubview(completionIcon)
        NSLayoutConstraint.activate([
            completionIcon.topAnchor.constraint(equalTo: topAnchor, constant: smallPad),
            completionIcon.leftAnchor.constraint(equalTo: leftEdge.rightAnchor, constant: smallPad),
            completionIcon.heightAnchor.constraint(equalToConstant: 24),
            completionIcon.widthAnchor.constraint(equalToConstant: 24)
            ])
        
//        addSubview(monthLabel)
//        NSLayoutConstraint.activate([
//            monthLabel.leftAnchor.constraint(equalTo: leftEdge.rightAnchor, constant: smallPad),
//            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6)
//            ])
//
//        addSubview(dayLabel)
//        NSLayoutConstraint.activate([
//            dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor),
//            dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: -4)
//            ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: smallPad),
            titleLabel.leftAnchor.constraint(equalTo: completionIcon.rightAnchor, constant: pad),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -100) //<<<This will need to be adjusted
            ])
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            messageLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -pad)
            ])
        
//        addSubview(statusLabel)
//        NSLayoutConstraint.activate([
//            statusLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: -90),
//            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//            ])
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(completedIconTapped(sender:)))
        completionIcon.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func completedIconTapped(sender: UITapGestureRecognizer) {
        self.completed = !self.completed
    }
    
    func updateCompletedIcon() {
        let name = self.completed ? ImageNames.completeIcon.rawValue : ImageNames.incompleteIcon.rawValue
        completionIcon.image = UIImage(named: name)
    }

    func configureCell(notification: EventNotification) {

//        if let date = notification.date {
//            dayLabel.text = DateHandler.stringDayNum(from: date)
//            monthLabel.text = DateHandler.stringMonthAbb(from: date).uppercased()
            
            //statusLabel.text = date < Date() ? "SENT" : "PENDING"
//        }
        
        if let title = notification.title {
            titleLabel.text = title
        }
        
        if let msg = notification.message {
            messageLabel.text = msg
        }
        
        self.completed = notification.completed
        
        self.notification = notification
    }
}
