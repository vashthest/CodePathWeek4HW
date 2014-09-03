//
//  ZoomTransition.swift
//  Facebook
//
//  Created by Yi on 8/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class ZoomTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool!
    var duration: NSTimeInterval!
    var zoomImageView: UIImageView!
    var imageViews = [UIImageView]()
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return duration
    }
    
    func getFullscreenFrame(image: UIImage!) -> (CGRect) {
        var window = UIApplication.sharedApplication().keyWindow
        var height = image.size.height
        var width = image.size.width
        var maxWidth = window.frame.width
        var maxHeight = window.frame.height
        var frame = CGRect(x: 0, y: (maxHeight - maxWidth/width * height)/2, width: maxWidth, height: maxWidth/width * height)
        return frame
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        if isPresenting == true {
            
            var window = UIApplication.sharedApplication().keyWindow
            var frame = window.convertRect(zoomImageView.frame, fromView: zoomImageView.superview)
            
            var index = (toViewController as PhotoViewController).imageIndex
            var fromImageView = imageViews[index]
            var savedImage = fromImageView.image
            
            var imageView = UIImageView(frame: frame)
            imageView.image = zoomImageView.image
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            window.addSubview(imageView)
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            (toViewController as PhotoViewController).imageViews[index].alpha = 0
            
            fromImageView.image = nil
            fromImageView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            
            UIView.animateWithDuration(duration, animations: {
                imageView.frame = self.getFullscreenFrame(imageView.image)
                toViewController.view.alpha = 1
                }, completion: {
                    (finished: Bool) in
                    imageView.removeFromSuperview()
                    fromImageView.image = savedImage
                    (toViewController as PhotoViewController).imageViews[index].alpha = 1
                    transitionContext.completeTransition(true)
            })
            
        } else {
            
            var index = (fromViewController as PhotoViewController).imageIndex
            var fromImageView = (fromViewController as PhotoViewController).imageViews[index]
            var contentOffsetY = (fromViewController as PhotoViewController).scrollView.contentOffset.y
            
            var window = UIApplication.sharedApplication().keyWindow
            var frame = self.getFullscreenFrame(fromImageView.image)
            frame = CGRect(x: frame.origin.x, y: frame.origin.y - contentOffsetY, width: frame.width, height: frame.height)
            
            var toImageView = imageViews[index]
            var endFrame = window.convertRect(toImageView.frame, fromView: toImageView.superview)
            var savedImage = toImageView.image
            
            var imageView = UIImageView(frame: frame)
            imageView.image = fromImageView.image
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            window.addSubview(imageView)
            
            fromViewController.view.alpha = (fromViewController as PhotoViewController).scrollViewAlpha
            fromImageView.alpha = 0
            
            toImageView.image = nil
            toImageView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            
            UIView.animateWithDuration(duration, animations: {
                imageView.frame = endFrame
                fromViewController.view.alpha = 0
                }, completion: {
                    (finished: Bool) in
                    toImageView.image = savedImage
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
        
    }
    
}
