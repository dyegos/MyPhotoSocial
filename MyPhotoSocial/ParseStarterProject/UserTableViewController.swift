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
    //Creates the instance for push to refresh object
    let refresher = UIRefreshControl()
    //Creates a struct to save users info
    let myInfo = ServerRequests()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //sets up the push to refresh
        self.setUpPushToRefresh()
        //starts loading the users
        self.loadUsers()
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
        //Dequeues the new cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.User, forIndexPath: indexPath)
        
        //sets the user name for the cell
        cell.textLabel?.text = self.myInfo.users[indexPath.row].username
        //verifies if it needs to put a checkmark that represents if the user is being followed or not
        cell.accessoryType = (self.myInfo.users[indexPath.row].isFollowing ? .Checkmark : .None)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //Verifies if the user is being followed to unfollow it,
        //Othewise the user will be followed
        if self.myInfo.users[indexPath.row].isFollowing
        {
            //Starts the request to unfollow the user
            myInfo.unfollowUser(self.myInfo.users[indexPath.row].uniqueID, follower: PFUser.currentUser()!.objectId!)
            //Gets the success
            .onSuccess
            {
                print($0)
                
                //Saves the old info of the user that will be unfollowed
                let old = self.myInfo.users[indexPath.row]
                //Saves a new info who will be the followed user
                let new = SUser(uniqueID: old.uniqueID, username: old.username)
                
                //Replaces the old object with the new one
                self.myInfo.users.replace(object: new, AtIndex: indexPath.row)
                
                //Reload the table
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            //Gets the error
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
                
                //Saves the old info of the user that will be followed
                let old = self.myInfo.users[indexPath.row]
                //Saves a new info who will be the unfollowed user
                let new = FUser(uniqueID: old.uniqueID, username: old.username)
                
                //Replaces the old object with the new one
                self.myInfo.users.replace(object: new, AtIndex: indexPath.row)
                
                //Reload the table
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            .onError
            {
                //print the error
                print($0)
            }
        }
    }
    
    // MARK: - Methods
    
    func loadUsers()
    {
        //Stars the request to load the users that uses the app
        myInfo.loadUsersInfo()
        .onSuccess // Gets que success
        {
            print("\($0)")
            
            //Reloads the table
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            
            //Stops push to refresh animation
            self.refresher.endRefreshing()
        }
        .onError // Gets the rror
        {
            print("\($0)")
            
            //Stops push to refresh animation
            self.refresher.endRefreshing()
        }
    }
    
    func setUpPushToRefresh()
    {
        refresher.backgroundColor = UIColor(red: 0.25, green: 0.14, blue: 0.16, alpha: 1)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh");
        refresher.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
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
                    //viewController.followeds = myInfo.users.filter { $0.isFollowing }
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
