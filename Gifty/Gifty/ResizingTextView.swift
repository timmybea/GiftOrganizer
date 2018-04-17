//
//  ResizingTextView.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-16.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

protocol ResizingTextViewDelegate {
    func resizeToHeight(_ height: CGFloat)
}

class ResizingTextView: UIView {

    var delegate : ResizingTextViewDelegate?
    
    private lazy var textView: UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = UIColor.white
        v.font = Theme.fonts.mediumText.font
        v.backgroundColor = UIColor.clear
        v.bounces = false
        v.returnKeyType = .done
        v.delegate = self
        v.text = placeholder
        return v
    }()

    private var placeholder = "Notes"
    
    private var currHeight: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        
        self.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        currHeight = self.frame.size.height
    }
    
    var text: String? {
        if textView.text != nil && textView.text != "" && textView.text != placeholder {
            return self.textView.text
        } else {
            return nil
        }
    }
    
    func returnToPlaceholder() {
        textView.text = placeholder
    }

    func setText(_ text: String?) {
        if text != nil && text != "" && text != placeholder {
            textView.text = text
            
            let h = calculateCurrentHeight()
            if h != currHeight {
                currHeight = h
                self.delegate?.resizeToHeight(h)
            }
        }
    }
    
    private func calculateCurrentHeight() -> CGFloat {
        let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: self.bounds.size.width, height: CGFloat(MAXFLOAT)))
        return sizeThatFitsTextView.height
    }
    
}

extension ResizingTextView : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholder {
            textView.text = ""
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return true
        }
        
        let h = calculateCurrentHeight()
        if h != currHeight {
            currHeight = h
            self.delegate?.resizeToHeight(h)
        }

        return true
    }
}

