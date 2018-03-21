//
//  CustomImageControl.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

final class CustomImageControl: UIControl {
    
    let imageView: UIImageView = UIImageView()
    var isImageSelected = false
    //var actionsSelectionState: ActionButton.SelectionStates = ActionButton.SelectionStates.unselected
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //NOW YOU CAN INCLUDE: .addTarget(self, action: "imageTouchedDown:", forControlEvents: .TouchDown) etc for your imageView
}
