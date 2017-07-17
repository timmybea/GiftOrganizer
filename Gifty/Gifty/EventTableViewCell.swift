//
//  EventCollectionViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-10.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.highlightedText
        label.font = FontManager.dateMonth
        label.textAlignment = .center
        label.text = "MAR"
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = ColorManager.highlightedText
        label.font = FontManager.dateDay
        label.text = "24"
        return label
    }()
    
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.tabBarPurple
        label.font = FontManager.subtitleText
        return label
    }()
    
    let customBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 2
        view.layer.borderColor = ColorManager.lightText.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    var actionsButtonsView: ActionsButtonsView = {
        let view = ActionsButtonsView(imageSize: 34, actionsSelectionType: ActionsSelectionType.checkList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        addSubview(customBackground)
        customBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        customBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        customBackground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        customBackground.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        customBackground.addSubview(dayLabel)
        dayLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        
        customBackground.addSubview(monthLabel)
        monthLabel.bottomAnchor.constraint(equalTo: dayLabel.topAnchor, constant: 4).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor).isActive = true
        
//        customBackground.addSubview(eventTypeLabel)
//        eventTypeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        eventTypeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        customBackground.addSubview(actionsButtonsView)
        actionsButtonsView.leftAnchor.constraint(equalTo: monthLabel.rightAnchor, constant: pad).isActive = true
        actionsButtonsView.rightAnchor.constraint(equalTo: customBackground.rightAnchor, constant: -pad).isActive = true
        actionsButtonsView.bottomAnchor.constraint(equalTo: customBackground.bottomAnchor).isActive = true
        actionsButtonsView.topAnchor.constraint(equalTo: customBackground.topAnchor).isActive = true
        actionsButtonsView.layoutSubviews()
        actionsButtonsView.tintSelected = ColorManager.highlightedText
        actionsButtonsView.tintCompleted = ColorManager.yellow
        actionsButtonsView.delegate = self
        
    }
    
    func configureWith(event: Event) {

        eventTypeLabel.text = event.type
 
//>>>>>     actionsButtonsView.configureWith(event: event)

        self.dayLabel.text = DateHandler.stringDayNum(from: event.date! as Date)
        
        self.monthLabel.text = DateHandler.stringMonthAbb(from: event.date! as Date).uppercased()
    }
}


extension EventTableViewCell: ActionsButtonsViewDelegate {
    
    func giftChangedTo(selectionState: ActionsSelectionState) {
        print("GIFT IS \(selectionState.rawValue)")
    }
    
    func cardChangedTo(selectionState: ActionsSelectionState) {
        print("CARD IS \(selectionState.rawValue)")
    }
    
    func phoneChangedTo(selectionState: ActionsSelectionState) {
        print("PHONE IS \(selectionState.rawValue)")
    }
}
