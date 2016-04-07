//
//  UIImage+UIImagePicker.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 2/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

extension UIImageView : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func pickImageFromCameraWith(presentingViewControler: UIViewController)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .Camera
        image.allowsEditing = false
        
        presentingViewControler.presentViewController(image, animated: true, completion: nil)
    }
    
    func pickImageFromAlbumWith(presentingViewControler: UIViewController)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .PhotoLibrary
        image.allowsEditing = false
        
        presentingViewControler.presentViewController(image, animated: true, completion: nil)
    }
    
    //MARK: image picker delegate
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.image = image
        
        picker.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
