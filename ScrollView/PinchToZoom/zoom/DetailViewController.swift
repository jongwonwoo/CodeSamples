//
//  DetailViewController.swift
//  zoom
//
//  Created by jongwon woo on 2017. 2. 28..
//  Copyright © 2017년 jongwonwoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideBars(true)
    }
    
    @IBAction func tappedOnView(_ sender: UITapGestureRecognizer) {
        
        hideBars(!self.hide)
    }
    
    func hideBars(_ value: Bool) {
        self.hide = value
        UIView.animate(withDuration:0.4) {
            self.navigationController?.isNavigationBarHidden = value
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }
    }
    
    var hide = false
    override var prefersStatusBarHidden : Bool {
        return self.hide
    }
    
}
