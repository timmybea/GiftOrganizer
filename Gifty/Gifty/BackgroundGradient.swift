//
//  BackGroundGradient.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class BackgroundGradient: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background_gradient")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        self.addSubview(imageView)
    }
    
    func resize(_ size: CGSize) {
        self.bounds.size = size
        imageView.frame.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
