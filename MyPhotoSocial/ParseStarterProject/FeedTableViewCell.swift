//
//  FeedTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewCell: UITableViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageTextField: UILabel!
}

extension UIImageView
{
    func convertParseImageFile(file:PFFile?)
    {
        file!.getDataInBackgroundWithBlock
        { (data, error) -> Void in
            
            dispatch_async(getQOSUserInitiated())
            {
                if let finalImage = UIImage(data: data!)
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.image = finalImage
                    }
                }
            }
        }
    }
}
