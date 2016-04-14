//
//  UploadImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadImageViewController: UIViewController, UITextViewDelegate
{
    //MARK: Outlets
    
    @IBOutlet weak private var imageSample: UIImageView?
    @IBOutlet weak private var messageText: UITextView? { didSet { messageText?.delegate = self } }
    
    @IBAction func pickImage(sender: UIButton)
    {
        //Picks the imagem from the device album
        self.imageSample?.pickImageFromAlbumWith(self)
    }
    
    @IBAction func postImage(sender: UIButton)
    {
        //Creates the post object in the database
        let post = PFObject(className: "Post")
        
        //Sets the message and the user ID for the post
        post["message"] = messageText?.text
        post["userId"] = PFUser.currentUser()!.objectId!
        
        //Transforms the image to data
        let imageData = NSData(data: UIImagePNGRepresentation(imageSample!.image!)!)
        //Gets the image name from the hashValue
        let imageName = "\(PFUser.currentUser()!.objectId!)-\(imageSample?.hashValue).png"
        post["imageData"] = PFFile(name: imageName, data: imageData)
        
        //Puts the loading on the screen
        self.setUpActivityIndicator()
        
        //Stats to save the post on the database
        post.saveInBackgroundWithBlock
        {
            if let error = $1
            {
                print("Deu erro no rolê \(error.code)")
            }
            
            print("Sucesso? \($0)")
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    //Set up the loading indicator
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: - Methods

    func setUpActivityIndicator()
    {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    //MARK: - TextView Delegate
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
