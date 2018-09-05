//
//  GiftCreateEventCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-22.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol AddGiftViewCellDelegate {
    func remove(gift: Gift)
}

class AddGiftViewCell: UITableViewCell {

    var delegate: AddGiftViewCellDelegate?
    
    private var gift : Gift?
    
    static var cellHeight: CGFloat = 50.0

    private var removeButton: CustomImageControl = {
        let c = CustomImageControl()
        c.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: ImageNames.removeIcon.rawValue)?.withRenderingMode(.alwaysTemplate) {
            c.setDefaultImage(image)
        }
        c.setContentMode(.scaleAspectFill)
        c.setTintColor(Theme.colors.lightToneTwo.color)
        return c
    }()
    
    private var giftImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: ImageNames.giftIcon.rawValue)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private var giftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.charcoal.color
        label.textAlignment = .left
        label.font = Theme.fonts.subtitleText.font
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = Theme.fonts.smallText.font
        return label
    }()
    
    let separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.colors.lightToneOne.color
        v.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupSubviews() {
        
        addSubview(giftImage)
        NSLayoutConstraint.activate([
            giftImage.topAnchor.constraint(equalTo: topAnchor),
            giftImage.leftAnchor.constraint(equalTo: leftAnchor),
            giftImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            giftImage.widthAnchor.constraint(equalToConstant: type(of: self).cellHeight)
            ])

        addSubview(giftNameLabel)
        NSLayoutConstraint.activate([
            giftNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            giftNameLabel.leftAnchor.constraint(equalTo: giftImage.rightAnchor, constant: pad)
            ])
        
        addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.leftAnchor.constraint(equalTo: giftNameLabel.leftAnchor),
            summaryLabel.topAnchor.constraint(equalTo: giftNameLabel.bottomAnchor, constant: 2)
            ])
        
        addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad),
            removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
            ])
        removeButton.addTarget(self, action: #selector(removeIconTouched(sender:)), for: .touchUpInside)
        
        addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorLine.leftAnchor.constraint(equalTo: self.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
            ])

    }

    func setup(with gift: Gift) {
        self.gift = gift
        self.giftNameLabel.text = gift.name
        self.summaryLabel.text = "\(currencySymbol)\(CurrencyHandler.formattedString(for: gift.cost))"
        
        if let imageData = gift.image {
            let image = UIImage(data: imageData as Data)
            giftImage.image = image
        } else {
            giftImage.image = UIImage(named: ImageNames.giftIcon.rawValue)
        }
    }
    
    
    @objc
    func removeIconTouched(sender: CustomImageControl) {
        print("Remove gift from tv")
        if let g = self.gift {
            self.delegate?.remove(gift: g)
        }
    }
}
