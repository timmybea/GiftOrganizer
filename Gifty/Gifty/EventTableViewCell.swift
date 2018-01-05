//
//  EventCollectionViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-10.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventTableViewCellDelegate {
    func setAction(_ action: ActionButton.Actions, to state: ActionButton.SelectionStates, for event: Event)
    func budgetButtonTouched(for event: Event)
}

class EventTableViewCell: UITableViewCell {
    
    var event: Event?
    
    var delegate: EventTableViewCellDelegate?
    
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
    
    lazy var actionsButtonsView: ActionsButtonsView = {
        let view = ActionsButtonsView(imageSize: 34, actionsSelectionType: ActionButton.SelectionTypes.checkList)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    let completionIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.incompleteIcon.rawValue)
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
        
        //actionsButtonsView.isHidden = true
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
        customBackground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        customBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        
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
        
        //customBackground.layer.masksToBounds = true
        customBackground.dropShadow()
        
        customBackground.addSubview(completionIcon)
        completionIcon.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 15).isActive = true
        completionIcon.rightAnchor.constraint(equalTo: customBackground.rightAnchor, constant: -pad).isActive = true
        completionIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        completionIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        customBackground.addSubview(summaryLabel)
        summaryLabel.leftAnchor.constraint(equalTo: eventTypeLabel.leftAnchor).isActive = true
        summaryLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -6).isActive = true
        
        customBackground.addSubview(actionsButtonsView)
        actionsButtonsView.leftAnchor.constraint(equalTo: eventTypeLabel.leftAnchor).isActive = true
        actionsButtonsView.rightAnchor.constraint(equalTo: customBackground.rightAnchor, constant: -pad).isActive = true
        actionsButtonsView.bottomAnchor.constraint(equalTo: customBackground.bottomAnchor, constant: -6).isActive = true
        actionsButtonsView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        actionsButtonsView.isHidden = true
    }
    
    
    func showActionsButtonsView() {
        if self.customBackground.frame.height > 70.0 {
            actionsButtonsView.isHidden = false
        }
    }
    
    func hideActionsButtonsView() {
        actionsButtonsView.isHidden = true
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
                completionIcon.image = UIImage(named: ImageNames.completeIcon.rawValue)
            } else if count > 0 {
                if count == 1 {
                    self.summaryLabel.text = "1 incomplete action"
                } else {
                    self.summaryLabel.text = "\(count) incomplete actions"
                }
                completionIcon.image = UIImage(named: ImageNames.incompleteIcon.rawValue)
            }
            
            actionsButtonsView.configureButtonStatesFor(event: event)
        }
    }
    
    private func countIncompleteActions(event: Event) -> Int {
        
        var count = 0
        
        if event.giftState == ActionButton.SelectionStates.selected.rawValue {
            count += 1
        }

        if event.cardState == ActionButton.SelectionStates.selected.rawValue {
            count += 1
        }
        
        if event.phoneState == ActionButton.SelectionStates.selected.rawValue {
            count += 1
        }
        return count
    }

}

//MARK: ActionsButtons Delegate
extension EventTableViewCell: ActionsButtonsViewDelegate {
    
    func budgetButtonTouched() {
    
        if self.delegate != nil, self.event != nil {
            self.delegate!.budgetButtonTouched(for: self.event!)
        }
    }
    
    func setAction(_ action: ActionButton.Actions, to state: ActionButton.SelectionStates) {
        
        if self.delegate != nil, self.event != nil {
            self.delegate!.setAction(action, to: state, for: self.event!)
        }
    }
}
