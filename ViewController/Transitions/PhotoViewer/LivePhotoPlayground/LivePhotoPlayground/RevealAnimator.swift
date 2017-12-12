//
//  RevealAnimator.swift
//  LivePhotoPlayground
//
//  Created by Jongwon Woo on 25/10/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    let animationDuration = 2.0
    var operation: UINavigationControllerOperation = .push
    
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if operation == .push {
            let containerView = transitionContext.containerView
            let toView = transitionContext.view(forKey: .to)!
            
            let originFrame = CGRect(x: 0, y: 0, width: 100, height: 100) // TODO: 선택된 셀로부터...
            let initialFrame = originFrame
            let finalFrame = toView.frame
            
            let xScaleFactor = initialFrame.width / finalFrame.width
            let yScaleFactor = initialFrame.height / finalFrame.height
            
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            
            toView.transform = scaleTransform
            toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            toView.clipsToBounds = true
            
            containerView.addSubview(toView)
            containerView.bringSubview(toFront: toView)
            
            UIView.animate(withDuration: animationDuration, delay:0.0,
                           usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
                           animations: {
                            toView.transform = CGAffineTransform.identity
                            toView.transform = toView.transform.rotated(by: 1/3 * .pi * 2)
                            toView.transform = toView.transform.rotated(by: 1/3 * .pi * 2)
                            toView.transform = toView.transform.rotated(by: 1/3 * .pi * 2)
                            toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, completion: { _ in
                
                transitionContext.completeTransition(true)
            })
            
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
        }
        storedContext = nil
    }
}
