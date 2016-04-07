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
    var followeds = [User]()
    var posts = [FUser]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for flwing in followeds
        {
            PFQuery(className: "Post")
            .whereKey("userId", equalTo: flwing.uniqueID)
            .findObjectsInBackgroundWithBlock
            { (objects, error) -> Void in
                
                if error != nil
                {
                    print("Deu erro \(error!.code)")
                    return
                }
                
                guard let objs = objects where objs.count > 0 else
                {
                    return
                }
                
                for obj in objs
                {
                    var user = FUser(uniqueID: flwing.uniqueID, username: flwing.username)
                    
                    user.imageFile = obj["imageData"] as? PFFile
                    user.message = obj["message"] as! String
                    
                    self.posts.append(user)
                }
                
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
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
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Feed, forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.photoImageView?.convertParseImageFile(posts[indexPath.row].imageFile)
        cell.userName?.text = posts[indexPath.row].username
        cell.messageTextField?.text = posts[indexPath.row].message
        
        return cell
    }
}
