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
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak private var imageSample: UIImageView?
    @IBOutlet weak private var messageText: UITextView? { didSet { messageText?.delegate = self } }
    
    @IBAction func pickImage(sender: UIButton)
    {
        self.imageSample?.pickImageFromAlbumWith(self)
    }
    
    @IBAction func postImage(sender: UIButton)
    {
        let post = PFObject(className: "Post")
        
        post["message"] = messageText?.text
        post["userId"] = PFUser.currentUser()!.objectId!
        
        let imageData = NSData(data: UIImagePNGRepresentation(imageSample!.image!)!)
        let imageName = "\(PFUser.currentUser()!.objectId!)-\(imageSample?.hashValue).png"
        post["imageData"] = PFFile(name: imageName, data: imageData)
        
        self.setUpActivityIndicator()
        
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
