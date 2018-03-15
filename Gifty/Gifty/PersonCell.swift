//
//  PersonCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-06.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class PersonCell: UITableViewCell {

    var person: Person?
    
    let profileImageView: CircleView = {
        let view = CircleView(image: UIImage(named: ImageNames.defaultProfileBlock.rawValue))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.charcoal.color
        label.font = Theme.fonts.subtitleText.font
        return label
    }()
    
    let eventCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.colors.lightToneTwo.color
        label.textAlignment = .left
        label.font = Theme.fonts.mediumText.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        return label
    }()
    
    let budgetSummaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.smallText.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setupViews() {
        self.backgroundColor = Theme.colors.offWhite.color
        
        let medPad: CGFloat = 8
        let smallPad: CGFloat = 4

        self.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: medPad).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: medPad).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        
        self.addSubview(budgetSummaryLabel)
        budgetSummaryLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: medPad).isActive = true
        budgetSummaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: smallPad).isActive = true
        
        self.addSubview(eventCountLabel)
        eventCountLabel.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        eventCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -medPad).isActive = true
        eventCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func configureCellWith(person: Person) {
        self.person = person
        
        nameLabel.text = person.fullName
        
        if let imageData = person.profileImage {
            let image = UIImage(data: imageData as Data)
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: ImageNames.defaultProfileBlock.rawValue)
        }
        
        if let events = person.event?.allObjects as? [Event] {
            
            let eventCount = events.count
            var completedCount = 0
            var budgetAmt: Float = 0.0
            var actualAmt: Float = 0.0
            
            for event in events {
                if event.isComplete {
                    completedCount += 1
                }
                budgetAmt += event.budgetAmt
                actualAmt += event.actualAmt
            }
            eventCountLabel.text = "\(completedCount)/\(eventCount)"
            budgetSummaryLabel.text = "Budgetted $\(String(format: "%.2f", budgetAmt)) • Spent $\(String(format: "%.2f", actualAmt))"
        }
    }
}
