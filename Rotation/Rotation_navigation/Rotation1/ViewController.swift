//
//  ViewController.swift
//  Rotation1
//
//  Created by Jongwon Woo on 07/03/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /*
         이 vc가 top인 상태에서 회전하면 size와 self.view.frame.size가 다르다.
         그런데 top이 아닌 상태에서 돌아갈때는 portrait, landcape일 때 다르게 동작한다.
         - landscape로 바뀌는 상황이라면 size와 self.view.frame.size가 다르다.
         - portrait로 바뀔 때는 size와 self.view.frame.size가 같다.
         */
        print("\(ViewController.self)")
        dump(size)
        dump(self.view.frame.size)
    }
    
}

