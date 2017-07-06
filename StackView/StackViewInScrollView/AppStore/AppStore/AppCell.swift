//
//  AppCell.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import UIKit


class AppCell: UICollectionViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
