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
    
    var followeds = [User]()
    var posts = [FUser]()
    
    // MARK: - view lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for flwing in followeds
        {
            PFQuery(className: "Post")
            .whereKey("userId", equalTo: flwing.uniqueID)
            .findObjectsInBackgroundWithBlock
            {
                if let error = $1
                {
                    print("Deu erro \(error.code)")
                    return
                }
                
                guard let objs = $0 where objs.count > 0 else
                {
                    print("Objects invalid or has no itens")
                    return
                }
                
                self.posts = objs.flatMap
                {
                    var user = FUser(uniqueID: flwing.uniqueID, username: flwing.username)
                    
                    user.imageFile = $0["imageData"] as? PFFile
                    user.message = $0["message"] as? String
                    
                    return user
                }
                
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
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
        
        let viewModel = CardViewModel(model: posts[indexPath.row])
        cell.configure(withPresenter: viewModel)
        
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
