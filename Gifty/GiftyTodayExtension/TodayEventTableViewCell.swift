//
//  TodayEventTableViewCell.swift
//  GiftyTodayExtension
//
//  Created by Tim Beals on 2018-01-18.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class TodayEventTableViewCell: UITableViewCell {

    var event: Event?

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
    
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.charcoal.color
        label.textAlignment = .left
        label.font = Theme.fonts.subtitleText.font
        return label
    }()
    
    let customBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        return view
    }()

    let completionIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "incomplete")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.smallText.font
        return label
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
        
        self.backgroundColor = UIColor.clear
        
        addSubview(customBackground)
        customBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        customBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        customBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: smallPad).isActive = true
        customBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -smallPad).isActive = true
        
        let leftEdgeView = UIView()
        leftEdgeView.backgroundColor = Theme.colors.lightToneOne.color
        leftEdgeView.translatesAutoresizingMaskIntoConstraints = false
        
        customBackground.addSubview(leftEdgeView)
        leftEdgeView.leftAnchor.constraint(equalTo: customBackground.leftAnchor).isActive = true
        leftEdgeView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftEdgeView.topAnchor.constraint(equalTo: customBackground.topAnchor).isActive = true
        leftEdgeView.bottomAnchor.constraint(equalTo: customBackground.bottomAnchor).isActive = true
        customBackground.clipsToBounds = true
        
        customBackground.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: customBackground.leftAnchor, constant: pad).isActive = true
        monthLabel.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 6).isActive = true
        
        customBackground.addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: -4).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor).isActive = true
        
        customBackground.addSubview(eventTypeLabel)
        eventTypeLabel.leftAnchor.constraint(equalTo: customBackground.leftAnchor, constant: 50).isActive = true
        eventTypeLabel.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 6).isActive = true
        
        customBackground.dropShadow()
        
        customBackground.addSubview(completionIcon)
        completionIcon.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 15).isActive = true
        completionIcon.rightAnchor.constraint(equalTo: customBackground.rightAnchor, constant: -pad).isActive = true
        completionIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        completionIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        customBackground.addSubview(summaryLabel)
        summaryLabel.leftAnchor.constraint(equalTo: eventTypeLabel.leftAnchor).isActive = true
        summaryLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -6).isActive = true
        
    }

    func configureWith(event: Event) {
        
        self.event = event
        
        if self.event != nil {
            if let fullName = event.person?.fullName, let type = event.type {
                eventTypeLabel.text = "\(fullName) • \(type)"
            }
            if let date = event.date {
                self.dayLabel.text = DateHandler.stringDayNum(from: date)
                self.monthLabel.text = DateHandler.stringMonthAbb(from: date).uppercased()
            }
            
            let count = countIncompleteActions(event: event)
            
            if count == 0 {
                self.summaryLabel.text = "All actions completed"
                completionIcon.image = UIImage(named: "complete")
            } else if count > 0 {
                if count == 1 {
                    self.summaryLabel.text = "1 incomplete action"
                } else {
                    self.summaryLabel.text = "\(count) incomplete actions"
                }
                completionIcon.image = UIImage(named: "incomplete")
            }
        }
    }
    
    private func countIncompleteActions(event: Event) -> Int {
        
        var count = 0
        
        if !event.isComplete {
            count += 1 //<<<< THIS IS INCOMPLETE
        }
        return count
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}


