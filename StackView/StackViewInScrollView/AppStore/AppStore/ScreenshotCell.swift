//
//  ScreenshotCell.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        screenshotImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
