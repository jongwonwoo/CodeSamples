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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
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
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || (gesture.state == .changed && movingView == nil) {
            startMovingView(withPanGesture: gesture)
        }
        
        if gesture.state != .cancelled {
            keepMovingView(withPanGesture: gesture)
        }
        
        switch gesture.state {
        case .ended, .cancelled, .failed:
            finishMovingView(withPanGesture: gesture)
        default:
            break
        }
    }
    
    let defaultDuration: TimeInterval = 0.3
    var initialCenter = CGPoint()
    weak var movingView: UIView?
    var startMovingDirection: UISwipeGestureRecognizer.Direction = .left
    
    func direction(withPangesture gesture: UIPanGestureRecognizer) -> UISwipeGestureRecognizer.Direction {
        let velocity = gesture.velocity(in: self)
        if abs(velocity.x) > abs(velocity.y) {
            return velocity.x < 0 ? .left : .right
        } else {
            return velocity.y < 0 ? .up : .down
        }
    }
    
    func startMovingView(withPanGesture gesture: UIPanGestureRecognizer) {
        let movingDirection = direction(withPangesture: gesture)
        if movingDirection == .left || movingDirection == .right {
            self.startMovingDirection = movingDirection
            self.movingView = movingDirection == .left ? self.currentView : self.prevView
            self.initialCenter = self.movingView!.center
            self.bringSubviewToFront(self.movingView!)
        }
    }
    
    func keepMovingView(withPanGesture gesture: UIPanGestureRecognizer) {
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
    
    func finishMovingView(withPanGesture gesture: UIPanGestureRecognizer) {
        guard let movingView = self.movingView else {
            return
        }
        
        let duration = defaultDuration * TimeInterval((movingView.bounds.size.width - abs(initialCenter.x - movingView.center.x)) / self.bounds.size.width)
        let lastMovingDirection = direction(withPangesture: gesture)
        if lastMovingDirection == .left || lastMovingDirection == .right {
            if lastMovingDirection == .left && startMovingDirection == .left {
                moveCurrentViewToPreviousView(withDuration: duration)
            } else if lastMovingDirection == .right && startMovingDirection == .right {
                movePreviousViewToCurrentView(withDuration: duration)
            } else {
                cancelMovingView()
            }
        } else {
            if startMovingDirection == .left {
                moveCurrentViewToPreviousView(withDuration: duration)
            } else {
                movePreviousViewToCurrentView(withDuration: duration)
            }
        }
        
        self.movingView = nil
    }
    
    func cancelMovingView() {
        guard let movingView = self.movingView else {
            return
        }
        
        let duration = defaultDuration * TimeInterval(abs(initialCenter.x - movingView.center.x) / self.bounds.size.width)
        UIView.animate(withDuration: duration) {
            movingView.center = self.initialCenter
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

extension InfiniteView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gesture: \(gestureRecognizer.debugDescription)")
        print("other: \(otherGestureRecognizer.debugDescription)")
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let panDirection = direction(withPangesture: panGesture)
        if panDirection == .up || panDirection == .down {
            return true
        }
        
        return false
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
