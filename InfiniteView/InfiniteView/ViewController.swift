//
//  ViewController.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/15.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //TODO: 이중원형연결리스트롤 바꾸고 인덱스를 없애자
    let items = ["0", "1", "2", "3", "4", "5", "6"]
    var currentIndex = 0
    
    weak var infinteView: InfiniteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let infiniteView = InfiniteView(frame: CGRect.init(x: 50, y: 100, width: 200, height: 150))
        infiniteView.delegate = self
        self.view.addSubview(infiniteView)
        self.infinteView = infiniteView
    }
}

extension ViewController: InfiniteViewDelegate {
    func increseCurrentIndex() {
        currentIndex += 1
        if (currentIndex >= items.count) {
            currentIndex = 0
        }
    }
    
    func decreaseCurrentIndex() {
        currentIndex -= 1
        if (currentIndex < 0) {
            currentIndex = items.count - 1
        }
    }
    
    func didChangeNextViewToCurrentView() {
        increseCurrentIndex()
    }
    
    func didChangePreviousViewToCurrentView() {
        decreaseCurrentIndex()
    }
    
    func itemForPreviousView() -> String {
        var prevIndex = currentIndex - 1
        if (prevIndex < 0) {
            prevIndex = items.count - 1
        }
        
        return items[prevIndex]
    }
    
    func itemForCurrentView() -> String {
        return items[currentIndex]
    }
    
    func itemForNextView() -> String {
        var nextIndex = currentIndex + 1
        if (nextIndex >= items.count) {
            nextIndex = 0
        }
        
        return items[nextIndex]
    }
}

