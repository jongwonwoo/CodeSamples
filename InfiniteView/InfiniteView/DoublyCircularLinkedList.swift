//
//  DoublyCircularLinkedList.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/17.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import Foundation

class DoublyCircularLinkedList<T> {
    private class Node<T> {
        var value: T
        weak var prev: Node<T>?
        var next: Node<T>?
        
        init(_ value: T) {
            self.value = value
        }
    }
    
    private var tail: Node<T>?
    private var current: Node<T>?
    
    func append(_ value: T) {
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
    
    var currentValue: T? {
        return current?.value
    }
    
    var prevValue: T? {
        return current?.prev?.value
    }
    
    var nextValue: T? {
        return current?.next?.value
    }
}
