//
//  InfiniteView.swift
//  InfiniteView
//
//  Created by Jongwon Woo on 2019/08/15.
//  Copyright © 2019 Jongwon Woo. All rights reserved.
//

import UIKit

protocol InfiniteViewDelegate: class {
    func didChangeNextViewToCurrentView()
    func didChangePreviousViewToCurrentView()
    
    func itemForPreviousView() -> String
    func itemForCurrentView() -> String
    func itemForNextView() -> String
}

class InfiniteView: UIView {

    weak var delegate: InfiniteViewDelegate? {
        didSet{
            DispatchQueue.main.async {
                self.prevView.titleLabel.text = self.delegate?.itemForPreviousView()
                self.currentView.titleLabel.text = self.delegate?.itemForCurrentView()
                self.nextView.titleLabel.text = self.delegate?.itemForNextView()
            }
        }
    }
    
    weak var currentView: ItemView!
    weak var prevView: ItemView!
    weak var nextView: ItemView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.clipsToBounds = true
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
//        swipeLeft.direction = .left
//        self.addGestureRecognizer(swipeLeft)
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
//        swipeRight.direction = .right
//        self.addGestureRecognizer(swipeRight)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(panGesture)
        
        let blueView = ItemView.init(frame: self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0))
        blueView.backgroundColor = .blue
        self.addSubview(blueView)
        self.prevView = blueView
        
        let greenView = ItemView.init(frame: self.bounds)
        greenView.backgroundColor = .green
        self.addSubview(greenView)
        self.nextView = greenView
        
        let redView = ItemView.init(frame: self.bounds)
        redView.backgroundColor = .red
        self.addSubview(redView)
        self.currentView = redView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let defaultDuration: TimeInterval = 0.3
    var initialCenter = CGPoint()
    weak var movingView: UIView?
    var movingType: Int = 0
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            let velocity = gesture.velocity(in: self)
            if abs(velocity.x) > abs(velocity.y) {
                if velocity.x < 0 {
                    print("left")
                    movingType = -1
                    self.movingView = self.currentView
                } else {
                    print("right")
                    movingType = 1
                    self.movingView = self.prevView
                }
                
                self.initialCenter = self.movingView!.center
                self.bringSubviewToFront(self.movingView!)
            }
        }
        
        if gesture.state != .cancelled {
            guard let movingView = self.movingView else {
                return
            }
            
            let transition = gesture.translation(in: self)
            let changedX = movingView.center.x + transition.x
            if abs(changedX) <= movingView.bounds.size.width / 2 {
                movingView.center = CGPoint(x: changedX, y: movingView.center.y)
                gesture.setTranslation(CGPoint.zero, in: self)
            }
        }
        
        switch gesture.state {
        case .ended, .cancelled, .failed:
            guard let movingView = self.movingView else {
                return
            }
            
            let duration = defaultDuration * TimeInterval((movingView.bounds.size.width - abs(initialCenter.x - movingView.center.x)) / self.bounds.size.width)
            
            let velocity = gesture.velocity(in: self)
            if abs(velocity.x) > abs(velocity.y) {
                if velocity.x < 0 {
                    if movingType < 0 {
                        moveCurrentViewToPreviousView(withDuration: duration)
                    } else {
                        let duration = defaultDuration * TimeInterval(abs(initialCenter.x - movingView.center.x) / self.bounds.size.width)
                        UIView.animate(withDuration: duration) {
                            movingView.center = self.initialCenter
                        }
                    }
                } else {
                    if movingType < 0 {
                        let duration = defaultDuration * TimeInterval(abs(initialCenter.x - movingView.center.x) / self.bounds.size.width)
                        UIView.animate(withDuration: duration) {
                            movingView.center = self.initialCenter
                        }
                    } else {
                        movePreviousViewToCurrentView(withDuration: duration)
                    }
                }
            } else {
                if movingType < 0 {
                    moveCurrentViewToPreviousView(withDuration: duration)
                } else {
                    movePreviousViewToCurrentView(withDuration: duration)
                }
            }
            
            self.movingView = nil
        default:
            break
        }
    }
    
    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            movePreviousViewToCurrentView()
        }
        else if gesture.direction == .left {
            moveCurrentViewToPreviousView()
        }
    }
    
    func moveCurrentViewToPreviousView(withDuration: TimeInterval = 0.3) {
        delegate?.didChangeNextViewToCurrentView()
        
        let oldNextView = self.nextView
        self.nextView = self.prevView
        self.prevView = self.currentView
        self.currentView = oldNextView
        
        UIView.animate(withDuration: withDuration, animations: {
            self.prevView.frame = self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0)
        }) { completed in
            if completed {
                self.nextView.frame = self.bounds
                self.nextView.titleLabel.text = self.delegate?.itemForNextView()
                self.bringSubviewToFront(self.currentView!)
            }
        }
    }
    
    func movePreviousViewToCurrentView(withDuration: TimeInterval = 0.3) {
        delegate?.didChangePreviousViewToCurrentView()
        
        let oldCurrentView = self.currentView
        self.currentView = self.prevView
        self.prevView = self.nextView
        self.nextView = oldCurrentView
        
        self.bringSubviewToFront(self.currentView!)
        UIView.animate(withDuration: withDuration, animations: {
            self.currentView.frame = self.bounds
        }) { completed in
            if completed {
                self.prevView.frame = self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0)
                self.prevView.titleLabel.text = self.delegate?.itemForPreviousView()
            }
        }
    }
}


class ItemView: UIView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel.init(frame: self.bounds)
        label.textAlignment = .center
        self.addSubview(label)
        self.titleLabel = label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
