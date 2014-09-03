//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    var tappedImageView: UIImageView!
    var zoomTransition: ZoomTransition!
    var imageViews = [UIImageView]()
    
    @IBOutlet weak var wedImageView1: UIImageView!
    @IBOutlet weak var wedImageView2: UIImageView!
    @IBOutlet weak var wedImageView3: UIImageView!
    @IBOutlet weak var wedImageView4: UIImageView!
    @IBOutlet weak var wedImageView5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViews = [wedImageView1, wedImageView2, wedImageView3, wedImageView4, wedImageView5]

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }
    
    
    @IBAction func onPhotoTap(sender: UITapGestureRecognizer) {
        tappedImageView = sender.view as UIImageView
        performSegueWithIdentifier("photoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
        destinationViewController.imageIndex = find(imageViews, tappedImageView)
        
        zoomTransition = ZoomTransition()
        zoomTransition.duration = 0.3
        zoomTransition.zoomImageView = tappedImageView
        zoomTransition.imageViews = imageViews
        
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = zoomTransition
    }
}
