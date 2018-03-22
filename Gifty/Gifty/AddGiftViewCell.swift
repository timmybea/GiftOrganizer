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

    private var removeButton: CustomImageControl = {
        let c = CustomImageControl()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.imageView.image = UIImage(named: ImageNames.removeIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        c.imageView.contentMode = .scaleAspectFill
        c.imageView.tintColor = Theme.colors.lightToneTwo.color
        return c
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
        
        //backgroundColor = UIColor.blue
        
        addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad),
            removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
            ])
        removeButton.addTarget(self, action: #selector(removeIconTouched(sender:)), for: .touchUpInside)
        
    }

    func setup(with gift: Gift) {
        self.gift = gift
        self.textLabel?.text = gift.name
    }
    
    
    @objc
    func removeIconTouched(sender: CustomImageControl) {
        print("Remove gift from tv")
        if let g = self.gift {
            self.delegate?.remove(gift: g)
        }
    }
}
