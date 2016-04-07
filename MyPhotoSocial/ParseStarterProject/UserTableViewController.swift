//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 2/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

struct CellIdentifier
{
    static let User = "userCell"
    static let Feed = "feedCell"
}

class UserTableViewController: UITableViewController
{
    let refresher = UIRefreshControl()
    let myInfo = MyInfo()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setUpPushToRefresh()
        self.loadUsers()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.myInfo.users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.User, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.myInfo.users[indexPath.row].username
        cell.accessoryType = (self.myInfo.users[indexPath.row].isFollowing ? .Checkmark : .None)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if self.myInfo.users[indexPath.row].isFollowing
        {
            myInfo.unfollowUser(self.myInfo.users[indexPath.row].uniqueID, follower: PFUser.currentUser()!.objectId!)
            .onSuccess
            {
                print($0)
                
                let old = self.myInfo.users[indexPath.row]
                let new = SUser(uniqueID: old.uniqueID, username: old.username)
                
                self.myInfo.users.replace(object: new, AtIndex: indexPath.row)
                
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            .onError
            {
                print($0)
            }
        }
        else
        {
            myInfo.followUser(self.myInfo.users[indexPath.row].uniqueID, follower: PFUser.currentUser()!.objectId!)
            .onSuccess
            {
                print($0)
                
                let old = self.myInfo.users[indexPath.row]
                let new = FUser(uniqueID: old.uniqueID, username: old.username)
                
                self.myInfo.users.replace(object: new, AtIndex: indexPath.row)

                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            .onError
            {
                print($0)
            }
        }
    }
    
    func loadUsers()
    {
        myInfo.loadUsersInfo()
        .onSuccess
        {
            print("\($0)")
            
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            self.refresher.endRefreshing()
        }
        .onError
        {
            print("\($0)")
            
            self.refresher.endRefreshing()
        }
    }
    
    func setUpPushToRefresh()
    {
        refresher.backgroundColor = UIColor(red: 0.25, green: 0.14, blue: 0.16, alpha: 1)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh");
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
    }
    
    func refresh()
    {
        print("Is refreshing!")
        
        self.loadUsers()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let viewController = segue.verifiedViewController as? FeedTableViewController
        {
            if let identifier = segue.identifier
            {
                if identifier == SegueIdentifier.Feed
                {
                    viewController.followeds = myInfo.users.filter { $0.isFollowing }
                }
            }
        }
    }


}
