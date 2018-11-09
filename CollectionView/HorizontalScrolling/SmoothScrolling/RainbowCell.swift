//
//  RainbowCell.swift
//  SmoothScrolling
//
//  Created by Jongwon Woo on 27/06/2018.
//  Copyright © 2018 jongwonwoo. All rights reserved.
//

import UIKit

class RainbowCell: UICollectionViewCell {
    
    class var identifier: String {
        return "RainbowCell"
    }
    
    class var height: CGFloat {
        return 100
    }
    
    var indexPath: IndexPath!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("RainbowCell")
        
        let titleLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(20), width: self.contentView.bounds.width-10, height: 20))
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        print(String.init(format: "configure #%i", indexPath.item))

        self.backgroundColor = .black
        
        titleLabel.text = String.init(format: "#%i", indexPath.item)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(String.init(format: "layoutSubviews #%i", indexPath.item))
    }
    
    override func prepareForReuse() {
        print(String.init(format: "prepareForReuse #%i", indexPath.item))
    }
}
