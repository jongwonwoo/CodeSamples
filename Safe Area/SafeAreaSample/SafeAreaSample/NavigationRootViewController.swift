//
//  NavigationRootViewController.swift
//  SafeAreaSample
//
//  Created by Jongwon Woo on 13/12/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit

class NavigationRootViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 3.0
    }

}
