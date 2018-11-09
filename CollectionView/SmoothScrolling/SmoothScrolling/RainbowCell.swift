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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("RainbowCell")
        
//        for i in 0...200 {
//            let x = CGFloat(arc4random() % 100)
//            let titleLabel = UILabel(frame: CGRect(x: x, y: CGFloat(0), width: self.contentView.bounds.width, height: self.contentView.bounds.height))
//            titleLabel.textColor = .white
//            self.contentView.addSubview(titleLabel)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        print(String.init(format: "configure #%i", indexPath.item))

        self.backgroundColor = .black
        
        for i in 0...200 {
            let x = CGFloat(arc4random() % 100)
            let titleLabel = UILabel(frame: CGRect(x: x, y: CGFloat(0), width: self.contentView.bounds.width, height: self.contentView.bounds.height))
            titleLabel.textColor = .white
            titleLabel.text = String.init(format: "#%i", indexPath.item)
            self.contentView.addSubview(titleLabel)
        }
        
//        for subview in self.contentView.subviews {
//            if let label = subview as? UILabel {
//                label.text = String.init(format: "#%i", indexPath.item)
//            }
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(String.init(format: "layoutSubviews #%i", indexPath.item))
    }
    
    override func prepareForReuse() {
        print(String.init(format: "prepareForReuse #%i", indexPath.item))
        
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }

//        for subview in self.contentView.subviews {
//            if let label = subview as? UILabel {
//                label.text = nil
//            }
//        }
    }
}
