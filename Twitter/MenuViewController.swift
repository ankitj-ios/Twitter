//
//  MenuViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 8/7/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweetsViewController : UIViewController!
    var profileViewController : UIViewController!
    var mentionsViewController : UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    var viewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsViewController")
        profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        mentionsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MentionsViewController")
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
        tableView.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // ============ Table View ==============
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("inside cellForRowAtIndexPath ... ")
        let menuCell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
        let menuItems = ["Home", "Profile", "Mentions"];
        print(menuItems[indexPath.row])
        menuCell.menuItemLabel.text = menuItems[indexPath.row]
        return menuCell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("menu items count ... \(menuItems.count)")
        print("inside numberOfRowsInSection ... ")
        return 3
    }
    

}

