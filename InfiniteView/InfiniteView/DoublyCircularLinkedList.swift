//
//  DoublyCircularLinkedList.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/17.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import Foundation

class DoublyCircularLinkedList {
    private class Node {
        var value: String
        weak var prev: Node?
        var next: Node?
        
        init(_ value: String) {
            self.value = value
        }
    }
    
    private var tail: Node?
    private var current: Node?
    
    func append(_ value: String) {
        let newNode = Node(value)
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
    
    func resetCurrent() {
        current = tail?.next
    }
    
    func moveNext() {
        current = current?.next
    }
    
    func movePrev() {
        current = current?.prev
    }
    
    var currentValue: String {
        guard let currentNode = current else { return "" }
        return currentNode.value
    }
    
    var prevValue: String {
        guard let prevNode = current?.prev else { return "" }
        return prevNode.value
    }
    
    var nextValue: String {
        guard let nextNode = current?.next else { return "" }
        return nextNode.value
    }
}
