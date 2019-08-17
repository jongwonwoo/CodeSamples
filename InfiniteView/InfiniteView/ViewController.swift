//
//  ViewController.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/15.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var items = DoublyCircularLinkedList()
    func setupItems() {
        for value in 0...6 {
            items.append("\(value)")
        }
        
        items.resetCurrent()
    }
    
    weak var infinteView: InfiniteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupItems()
        
        let infiniteView = InfiniteView(frame: CGRect.init(x: 50, y: 100, width: 200, height: 150))
        infiniteView.delegate = self
        self.view.addSubview(infiniteView)
        self.infinteView = infiniteView
    }
}

extension ViewController: InfiniteViewDelegate {
    func didChangeNextViewToCurrentView() {
        items.moveNext()
    }
    
    func didChangePreviousViewToCurrentView() {
        items.movePrev()
    }
    
    func itemForPreviousView() -> String {
        return items.prevValue
    }
    
    func itemForCurrentView() -> String {
        return items.currentValue
    }
    
    func itemForNextView() -> String {
        return items.nextValue
    }
}
