//
//  InfiniteView.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/15.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import UIKit

class InfiniteView: UIView {

    var currentView: UIView?
    var prevView: UIView?
    var nextView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.clipsToBounds = true
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        let blueView = UIView.init(frame: self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0))
        blueView.backgroundColor = .blue
        self.addSubview(blueView)
        self.prevView = blueView
        
        let greenView = UIView.init(frame: self.bounds)
        greenView.backgroundColor = .green
        self.addSubview(greenView)
        self.nextView = greenView
        
        let redView = UIView.init(frame: self.bounds)
        redView.backgroundColor = .red
        self.addSubview(redView)
        self.currentView = redView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            movePreviousViewToCurrentView()
        }
        else if gesture.direction == .left {
            moveCurrentViewToPreviousView()
        }
    }
    
    func moveCurrentViewToPreviousView() {
        let oldNextView = self.nextView
        self.nextView = self.prevView
        self.prevView = self.currentView
        self.currentView = oldNextView
        
        UIView.animate(withDuration: 0.3, animations: {
            self.prevView?.frame = self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0)
        }) { completed in
            if completed {
                self.nextView?.frame = self.bounds
                self.bringSubviewToFront(self.currentView!)
            }
        }
    }
    
    func movePreviousViewToCurrentView() {
        let oldCurrentView = self.currentView
        self.currentView = self.prevView
        self.prevView = self.nextView
        self.nextView = oldCurrentView
        
        self.bringSubviewToFront(self.currentView!)
        UIView.animate(withDuration: 0.3, animations: {
            self.currentView?.frame = self.bounds
        }) { completed in
            if completed {
                self.prevView?.frame = self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0)
            }
        }
    }
}
