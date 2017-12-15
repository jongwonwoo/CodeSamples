//
//  ViewController.swift
//  SafeAreaSample
//
//  Created by Jongwon Woo on 12/12/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        showInfo()
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


    func showInfo() {
        if #available(iOS 11.0, *) {
            descriptionLabel.text = "iOS 11"
        } else {
            descriptionLabel.text = "older version than iOS 11"
        }
    }
    
    @IBAction func changeAdditionalSafeAreaInsets(_ sender: Any) {
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func resetAdditionalSafeAreaInsets(_ sender: Any) {
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) { }
}

