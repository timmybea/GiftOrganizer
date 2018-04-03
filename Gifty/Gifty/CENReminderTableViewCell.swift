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
    
    private var notification: EventNotification?
    var delegate: CENReminderCellDelegate?
    
    private var completed = false {
        didSet {
            self.updateCompletedIcon()
            if let n = self.notification {
                self.delegate?.set(notification: n, completed: completed)
            }
        }
    }
    
    private let leftEdge: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.colors.lightToneOne.color
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.charcoal.color
        label.textAlignment = .left
        label.font = Theme.fonts.subtitleText.font
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.mediumText.font
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.smallText.font
        return label
    }()
    
    private let completionIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.incompleteIcon.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let separatorLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Theme.colors.lightToneOne.color
        return v
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        
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
            completionIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -pad),
            completionIcon.heightAnchor.constraint(equalToConstant: 24),
            completionIcon.widthAnchor.constraint(equalToConstant: 24)
            ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: smallPad),
            titleLabel.leftAnchor.constraint(equalTo: leftEdge.rightAnchor, constant: pad),
            titleLabel.rightAnchor.constraint(equalTo: completionIcon.leftAnchor, constant: -pad)
            ])
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            messageLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            ])
        
        addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorLine.leftAnchor.constraint(equalTo: self.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6),
            statusLabel.leftAnchor.constraint(equalTo: messageLabel.leftAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -pad)
            ])
    
    }
    
    func setCompleted() {
        self.completed = !self.completed
    }
    
    func updateCompletedIcon() {
        let name = self.completed ? ImageNames.completeIcon.rawValue : ImageNames.incompleteIcon.rawValue
        completionIcon.image = UIImage(named: name)
    }

    func configureCell(notification: EventNotification) {

        if let date = notification.date {
            statusLabel.text = date < Date() ? "Sent \(DateHandler.describeDate(date))" : "Scheduled \(DateHandler.describeDate(date))"
        }
        
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
