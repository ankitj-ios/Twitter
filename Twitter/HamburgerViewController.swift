//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 8/7/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewLeftContraint: NSLayoutConstraint!
    
    var orignalLeftContraint : CGFloat!
    
    var menuViewController : UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        let gestureState : UIGestureRecognizerState = sender.state
        
        if gestureState == .Began {
            print("gesture began")
            orignalLeftContraint = contentViewLeftContraint.constant
        } else if gestureState == .Changed {
            print("gesture changed")
            contentViewLeftContraint.constant += translation.x
        } else if gestureState == .Ended {
            print("gesture ended")
            UIView.animateWithDuration(0.5, animations: { 
                if velocity.x > 0 {
                    self.contentViewLeftContraint.constant = self.view.frame.size.width - 100
                } else {
                    self.contentViewLeftContraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    
}
