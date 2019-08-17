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
            items.addNode(value: "\(value)")
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
        guard let value = items.prev?.value else {
            return ""
        }
        
        return value
    }
    
    func itemForCurrentView() -> String {
        guard let value = items.current?.value else {
            return ""
        }
        
        return value
    }
    
    func itemForNextView() -> String {
        guard let value = items.next?.value else {
            return ""
        }
        
        return value
    }
}

class Node: NSObject {
    var value: String!
    var prev: Node?
    var next: Node?
    
    init(withValue value: String) {
        super.init()
        self.value = value
    }
}

class DoublyCircularLinkedList: NSObject {
    var tail: Node?
    
    func addNode(value: String) {
        let newNode = Node(withValue: value)
        if tail == nil {
            newNode.prev = newNode
            newNode.next = newNode
            tail = newNode
        } else {
            newNode.next = tail?.next
            newNode.prev = tail
            newNode.next?.prev = newNode
            tail?.next = newNode
            tail = newNode
        }
    }
    
    var current: Node?
    var prev: Node? {
        return current?.prev
    }
    var next: Node? {
        return current?.next
    }
    
    func resetCurrent() {
        current = tail?.next
    }
    
    func moveNext() {
        current = current?.next
    }
    
    func movePrev() {
        current = current?.prev
    }
}
