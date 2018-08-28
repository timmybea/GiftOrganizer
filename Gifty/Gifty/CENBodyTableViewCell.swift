//
//  CENBodyTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol CENBodyCellDelegate {
    func finishedEditing(text: String)
}

class CENBodyTableViewCell: UITableViewCell {
    
    let clearframe: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderColor = Theme.colors.lightToneTwo.color.cgColor
        v.layer.borderWidth = 2.0
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "120"
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = Theme.fonts.mediumText.font
        label.textAlignment = .left
        return label
    }()
    
    let textView: UITextView = {
        let t = UITextView()
        t.font = Theme.fonts.mediumText.font
        t.textColor = Theme.colors.lightToneTwo.color
        t.text = "Message"
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = Theme.colors.offWhite.color
        t.textAlignment = .left
        t.bounces = false
        return t
    }()
    
    var count = 120
    
    var delegate: CENBodyCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        selectionStyle = .none
        backgroundColor = Theme.colors.offWhite.color
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        self.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: -(pad * 3))
            ])
        
        self.addSubview(clearframe)
        NSLayoutConstraint.activate([
            clearframe.leftAnchor.constraint(equalTo: leftAnchor, constant: pad),
            clearframe.rightAnchor.constraint(equalTo: rightAnchor, constant: -pad),
            clearframe.topAnchor.constraint(equalTo: topAnchor, constant: pad),
            clearframe.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -4)
            ])
        
        self.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: clearframe.topAnchor, constant: 4),
            textView.leftAnchor.constraint(equalTo: clearframe.leftAnchor, constant: 4),
            textView.rightAnchor.constraint(equalTo: clearframe.rightAnchor, constant: -4),
            textView.bottomAnchor.constraint(greaterThanOrEqualTo: clearframe.bottomAnchor, constant: -4)
            ])
        textView.delegate = self
    }
}

extension CENBodyTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = Theme.colors.charcoal.color
        textView.text = ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n", var t = textView.text {
            _ = t.removeLast()
            textView.text = t
            textView.resignFirstResponder()
        }
        
        if textView.text.count > 120, let t = textView.text {
            let trimmed = String(Array(t)[0..<120])
            textView.text = trimmed
        }
        
        countLabel.text = String(120 - textView.text.count)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let t = textView.text, t != "" && t != "Message" else {
            textView.text = "Message"
            textView.textColor = Theme.colors.lightToneTwo.color
            return
        }
        
        delegate?.finishedEditing(text: t)
    }
    
}
