//
//  Extensions.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 4/13/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

//MARK: UIImageView Extension: Gives the right UIViewController to segue for if you have an UINavigationController before it

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

//MARK: UIImageView Extension: Encapsulates begining and ending interation events for the user

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

//MARK: UIImageView Extension: Pick an image from album or camera

extension UIImageView : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //Pick from the camera
    func pickImageFromCameraWith(presentingViewControler: UIViewController)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .Camera
        image.allowsEditing = false
        
        presentingViewControler.presentViewController(image, animated: true, completion: nil)
    }
    
    //Pick from the album
    func pickImageFromAlbumWith(presentingViewControler: UIViewController)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .PhotoLibrary
        image.allowsEditing = false
        
        presentingViewControler.presentViewController(image, animated: true, completion: nil)
    }
    
    //Image picker delegate
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.image = image
        
        picker.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: Get QOS_CLASS_USER_INITIATED queue

func getQOSUserInitiated() -> dispatch_queue_t
{
    let qos = QOS_CLASS_USER_INITIATED
    return dispatch_get_global_queue(qos, 0)
}

//MARK: UIImageView Extension: Converts the Parse PFFile data to an UIImage given the PPFile

extension UIImageView
{
    //Converts the Parse PFFile data to an UIImage given the PPFile
    func convertParseImageFile(file:PFFile?)
    {
        //Starts getting the data
        file?.getDataInBackgroundWithBlock
        {
            //if it got any error just return
            if let error = $1
            {
                print("got error trying to convert the file \(error)")
                return
            }
            
            //verify if the date is not nil. if it is, just return
            guard let imageData = $0 else
            {
                print("got nothing on image data")
                return
            }
            
            //dispatch another queue to get the data
            dispatch_async(getQOSUserInitiated())
            {
                let finalImage = UIImage(data: imageData)
                
                //returns to main queue to set the image
                dispatch_async(dispatch_get_main_queue())
                {
                    self.image = finalImage
                }
            }
        }
    }
}

//MARK: Array Extension: Replaces an Element given the element and the index

extension Array
{
    public mutating func replace(object obj:Element, AtIndex index:Int)
    {
        self.removeAtIndex(index)
        self.insert(obj, atIndex: index)
    }
}

//MARK: Login Verifier

struct UserLoginInfo
{
    let username:String
    let password:String
}

protocol LoginVerifier
{
    func isTextFieldsLegible(username: String?, password: String?) -> UserLoginInfo?
}

extension LoginVerifier
{
    //Propertie that verifies if any of the filds are legible to login
    func isTextFieldsLegible(username: String?, password: String?) -> UserLoginInfo?
    {
        guard let user = username where user != "", let pws = password where pws != "" else
        {
            return nil
        }
        
        return UserLoginInfo(username: user, password: pws)
    }
}

//MARK: Error
struct RequestError
{
    let title:String
    let message:String
}

//MARK: View Controller
extension UIViewController : UITextFieldDelegate
{
    public func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
}

extension UIViewController
{
    //Creates an simples alert on the screen
    func createAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}