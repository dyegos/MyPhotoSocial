//
//  UIStoryboardSegue+UINavigationController.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

extension UIStoryboardSegue
{
    var verifiedViewController: UIViewController
    {
        let destination = self.destinationViewController
            
        if let navCon = destination as? UINavigationController
        {
            return navCon.visibleViewController!
        }
            
        return destination
    }
}
