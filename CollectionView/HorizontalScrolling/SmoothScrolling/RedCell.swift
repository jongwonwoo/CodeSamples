//
//  RedCell.swift
//  SmoothScrolling
//
//  Created by Jongwon Woo on 27/06/2018.
//  Copyright © 2018 jongwonwoo. All rights reserved.
//

import UIKit

class RedCell: RainbowCell {
    override class var identifier: String {
        return "RedCell"
    }
    
    override class var height: CGFloat {
        return 150
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("RedCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        self.backgroundColor = .red
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
