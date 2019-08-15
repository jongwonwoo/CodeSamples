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
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
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
    
    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            movePreviousViewToCurrentView()
        }
        else if gesture.direction == .left {
            moveCurrentViewToPreviousView()
        }
    }
    
    func moveCurrentViewToPreviousView() {
        delegate?.didChangeNextViewToCurrentView()
        
        let oldNextView = self.nextView
        self.nextView = self.prevView
        self.prevView = self.currentView
        self.currentView = oldNextView
        
        UIView.animate(withDuration: 0.3, animations: {
            self.prevView.frame = self.bounds.offsetBy(dx: -self.bounds.size.width, dy: 0)
        }) { completed in
            if completed {
                self.nextView.frame = self.bounds
                self.nextView.titleLabel.text = self.delegate?.itemForNextView()
                self.bringSubviewToFront(self.currentView!)
            }
        }
    }
    
    func movePreviousViewToCurrentView() {
        delegate?.didChangePreviousViewToCurrentView()
        
        let oldCurrentView = self.currentView
        self.currentView = self.prevView
        self.prevView = self.nextView
        self.nextView = oldCurrentView
        
        self.bringSubviewToFront(self.currentView!)
        UIView.animate(withDuration: 0.3, animations: {
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
