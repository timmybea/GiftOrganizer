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
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = FontManager.dateMonth
        label.textAlignment = .center
        label.text = "MAR"
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = FontManager.dateDay
        label.text = "24"
        return label
    }()
    
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.darkPurple.color
        label.textAlignment = .left
        label.font = FontManager.mediumText
        return label
    }()
    
    let customBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        //view.layer.borderWidth = 2
        //view.layer.borderColor = Theme.colors.lightToneOne.color.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var actionsButtonsView: ActionsButtonsView = {
        let view = ActionsButtonsView(imageSize: 34, actionsSelectionType: ActionsSelectionType.checkList)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintSelected = Theme.colors.lightToneTwo.color
        view.tintCompleted = Theme.colors.yellow.color
        view.delegate = self
        return view
    }()
    
    var isExpandedCell = false
    
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
        customBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        customBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        customBackground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        customBackground.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        customBackground.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: customBackground.leftAnchor, constant: pad).isActive = true
        monthLabel.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 6).isActive = true
        
        customBackground.addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: -4).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor).isActive = true
       
        customBackground.addSubview(eventTypeLabel)
        eventTypeLabel.leftAnchor.constraint(equalTo: customBackground.leftAnchor, constant: 50).isActive = true
        eventTypeLabel.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 6).isActive = true
        
//        customBackground.addSubview(actionsButtonsView)
//        actionsButtonsView.leftAnchor.constraint(equalTo: monthLabel.rightAnchor, constant: pad).isActive = true
//        actionsButtonsView.rightAnchor.constraint(equalTo: customBackground.rightAnchor, constant: -pad).isActive = true
//        actionsButtonsView.bottomAnchor.constraint(equalTo: customBackground.bottomAnchor).isActive = true
//        actionsButtonsView.topAnchor.constraint(equalTo: customBackground.topAnchor).isActive = true
//        actionsButtonsView.layoutSubviews()
        
    }
    
    func configureWith(event: Event) {

        if let fullName = event.person?.fullName, let type = event.type {
            eventTypeLabel.text = "\(fullName) • \(type)"
        }
        self.dayLabel.text = DateHandler.stringDayNum(from: event.date! as Date)
        self.monthLabel.text = DateHandler.stringMonthAbb(from: event.date! as Date).uppercased()

        
        
        //actionsButtonsView.configureButtonStatesFor(event: event)

        
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
