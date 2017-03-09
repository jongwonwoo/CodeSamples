//
//  DetailViewController.swift
//  Rotation1
//
//  Created by Jongwon Woo on 07/03/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(DetailViewController.self) - " + #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(DetailViewController.self) - " + #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(DetailViewController.self) - " + #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("\(DetailViewController.self) - " + #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("\(DetailViewController.self) - " + #function)
    }
}
