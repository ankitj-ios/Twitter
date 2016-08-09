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
    
    let menuItems = ["Home", "Profile", "Mentions"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        self.tableView.backgroundColor = UIColor.grayColor()
        self.tableView.separatorStyle = .None
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        mentionsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
        self.tableView.reloadData()
        
        hamburgerViewController.contentViewController = viewControllers[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // ============ Table View ==============
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
        print(menuItems[indexPath.row])
        menuCell.menuItemLabel.text = menuItems[indexPath.row]
        return menuCell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("menu items count ... \(menuItems.count)")
        return menuItems.count
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected ... \(menuItems[indexPath.row])")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}

