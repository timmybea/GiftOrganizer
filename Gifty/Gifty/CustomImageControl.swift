//
//  CustomImageControl.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

final class CustomImageControl: UIControl {
    
    var identifier: String?
    private let imageView: UIImageView = UIImageView()
    var isImageSelected = false
    
    private var defaultImage: UIImage? = nil {
        didSet {
            imageView.image = defaultImage
        }
    }
    //var actionsSelectionState: ActionButton.SelectionStates = ActionButton.SelectionStates.unselected
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultImage(_ image: UIImage) {
        self.defaultImage = image
    }

    func returnToDefaultImage() {
        if self.defaultImage != nil {
            self.imageView.image = defaultImage!
            isImageSelected = false
        }
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
        isImageSelected = true
    }
    
    func setContentMode(_ cm: UIViewContentMode) {
        self.imageView.contentMode = cm
    }

    func setTintColor(_ c: UIColor) {
        self.imageView.tintColor = c
    }
    
    func getSelectedImage() -> UIImage? {
        return isImageSelected ? self.imageView.image : nil
    }
    //NOW YOU CAN INCLUDE: .addTarget(self, action: "imageTouchedDown:", forControlEvents: .TouchDown) etc for your imageView
}
