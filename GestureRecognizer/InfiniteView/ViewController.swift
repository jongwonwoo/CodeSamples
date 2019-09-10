//
//  ViewController.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/15.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var items = DoublyCircularLinkedList<Int>()
    func setupItems() {
        for value in 0...6 {
            items.append(value)
        }
        
        items.resetCurrent()
    }
    
    weak var infinteView: InfiniteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupItems()
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * 2, height: scrollView.bounds.size.height * 2)
        self.view.addSubview(scrollView)
        
        let infiniteView = InfiniteView(frame: CGRect.init(x: 50, y: 100, width: 200, height: 150))
        infiniteView.delegate = self
        scrollView.addSubview(infiniteView)
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
        guard let value = items.prevValue else { return "" }
        return "\(value)"
    }
    
    func itemForCurrentView() -> String {
        guard let value = items.currentValue else { return "" }
        return "\(value)"
    }
    
    func itemForNextView() -> String {
        guard let value = items.nextValue else { return "" }
        return "\(value)"
    }
}
