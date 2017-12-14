//
//  SafeAreaBorderView.swift
//  SafeAreaSample
//
//  Created by Jongwon Woo on 14/12/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit

class SafeAreaBorderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupBorder()
    }
    
    func setupBorder() {
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 3.0
    }
    
    
}
