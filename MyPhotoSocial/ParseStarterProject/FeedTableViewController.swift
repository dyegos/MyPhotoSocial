//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController
{
    // MARK: - Properties
    
    private var posts = [FUser]()
    
    // MARK: - view lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let arrayOfFollowings = PFUser.currentUser()?["followings"] as? [String] ?? [String]()
        
        PFQuery(className: "Post")
        .whereKey("userId", containedIn: arrayOfFollowings)
        .findObjectsInBackgroundWithBlock
        {
            guard let objs = $0 where objs.count > 0 else
            {
                print("Objects invalid or has no itens : Deu erro \($1?.code)")
                return
            }
            
            self.posts = objs.flatMap
            {
                guard let user = $0 as? PFUser else { return nil }
                var fuser = FUser(uniqueID: user.objectId!, username: user.username!)
                
                fuser.imageFile = $0["imageData"] as? PFFile
                fuser.message = $0["message"] as? String
                
                return fuser
            }
            
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Feed, forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.configure(withPresenter: CardViewModel(model: posts[indexPath.row]))
        
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
