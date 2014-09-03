//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Yi on 8/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    var imageIndex: Int!
    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var photoActionsImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var imageViews = [UIImageView]()
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    var zoom: CGFloat!
    var scrollViewAlpha: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneImageView.alpha = 0
        photoActionsImageView.alpha = 0
        
        imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5]
        scrollView.contentSize = CGSize(width: 1600, height: scrollView.frame.size.height)
        scrollView.contentOffset.x = CGFloat(320 * imageIndex)
        scrollViewAlpha = 1
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.2, animations: {
            self.doneImageView.alpha = 1
            self.photoActionsImageView.alpha = 1
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        if zoom <= 1 {
            var alpha = (100 - abs(scrollView.contentOffset.y)) / 100
            imageIndex = Int(round(scrollView.contentOffset.x / 320))
            scrollView.backgroundColor = UIColor(white: 0, alpha: alpha)
            scrollViewAlpha = alpha
        } else {
            scrollView.backgroundColor = UIColor(white: 0, alpha: 1)
            scrollViewAlpha = 1
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        UIView.animateWithDuration(0.2, animations: {
            self.doneImageView.alpha = 0
            self.photoActionsImageView.alpha = 0
        })
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if abs(scrollView.contentOffset.y) > 100 && zoom <= 1 {
            dismissViewControllerAnimated(true, completion: nil)
        } else if zoom <= 1 {
            UIView.animateWithDuration(0.2, animations: {
                self.doneImageView.alpha = 1
                self.photoActionsImageView.alpha = 1
                scrollView.backgroundColor = UIColor(white: 0, alpha:1)
            })
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        scrollView.pagingEnabled = false
        for iv in imageViews {
            iv.hidden = true
        }
        imageViews[imageIndex].hidden = false
        zoom = scrollView.zoomScale
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        var page = Int(round(scrollView.contentOffset.x / 320))
        return imageViews[page]
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView!, withView view: UIView!) {
        UIView.animateWithDuration(0.2, animations: {
            self.doneImageView.alpha = 0
            self.photoActionsImageView.alpha = 0
        })
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView!, withView view: UIView!, atScale scale: CGFloat) {
        if zoom <= 1 {
            scrollView.pagingEnabled = true            
            scrollView.contentSize = CGSize(width: 1600, height: scrollView.frame.size.height)
            for iv in imageViews {
                iv.hidden = false
            }
            UIView.animateWithDuration(0.2, animations: {
                self.doneImageView.alpha = 1
                self.photoActionsImageView.alpha = 1
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
