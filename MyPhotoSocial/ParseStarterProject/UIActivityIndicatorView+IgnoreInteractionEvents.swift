//
//  UIActivityIndicatorView+IgnoreInteractionEvents.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView
{
    func startAnimatingAndIgnoreInteractions()
    {
        self.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopAnimatingAndIngnoreInteractions()
    {
        self.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}