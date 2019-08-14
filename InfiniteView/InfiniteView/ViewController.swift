//
//  ViewController.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/15.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var infinteView: InfiniteView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let infiniteView = InfiniteView(frame: CGRect.init(x: 50, y: 100, width: 200, height: 150))
        self.view.addSubview(infiniteView)
        self.infinteView = infiniteView
    }


}

