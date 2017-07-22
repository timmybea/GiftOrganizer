//
//  PersonCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-06.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    var person: Person?
    
//    let whiteView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 8
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
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
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = Theme.fonts.subtitleText.font
        return label
    }()
    
    let eventIcon: UIImageView = {
        let image = UIImage(named: ImageNames.eventIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.tintColor = Theme.colors.lightToneTwo.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.textColor = Theme.colors.lightToneTwo.color
        label.textAlignment = .left
        label.font = Theme.fonts.smallText.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total budget: $0, Spent: $0"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
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
        
        self.selectionStyle = .none
        
        let medPad: CGFloat = 8
        let smallPad: CGFloat = 4
        
//        self.addSubview(whiteView)
//        whiteView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
//        whiteView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
//        whiteView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
//        whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
//        whiteView.dropShadow()

        
        self.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: medPad).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: medPad).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        
        self.addSubview(eventCountLabel)
        eventCountLabel.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        eventCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -medPad).isActive = true
        eventCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addSubview(eventIcon)
        eventIcon.rightAnchor.constraint(equalTo: eventCountLabel.leftAnchor, constant: -smallPad).isActive = true
        eventIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eventIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eventIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(budgetSummaryLabel)
        budgetSummaryLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: medPad).isActive = true
        budgetSummaryLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        
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
        
        if let eventCount = person.event?.allObjects.count {
            eventCountLabel.text = "0/\(eventCount)"
        }
    }
}
