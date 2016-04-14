/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

struct SegueIdentifier
{
    static let Login = "login"
    static let PostImage = "post"
    static let Feed = "feed"
}

class LoginViewController: UIViewController
{
    //MARK: Outlets
    
    @IBOutlet weak private var usernameField: UITextField?
    @IBOutlet weak private var passwordField: UITextField?
    @IBOutlet weak private var requestButton: UIButton?
    @IBOutlet weak private var toggleState: UIButton?
    @IBOutlet weak private var registerLabel: UILabel?
    
    //MARK: Properties
    
    //Creates the login object
    let login = Login()
    //Creates the UIActivityIndicatorView object
    let activityIndicator = UIActivityIndicatorView()
    
    //Propertie that verifies if any of the filds are legible to login
    var isTextFieldsLegible: Bool
    {
        guard self.usernameField?.text != "" || self.passwordField?.text != "" else
        {
            self.createAlertWithTitle("Invalid input", andMessage: "Please enter a valid username and password")
                
            return false
        }
            
        return true
    }
    
    //Propertie that helps switch the label and button names if the user wants to sign up ou login
    var isSignUp = false
    {
        didSet
        {
            self.requestButton?.setTitle(self.isSignUp ? "Sign up" : "Login", forState: .Normal)
            self.toggleState?.setTitle(self.isSignUp ? "Login" : "Sign up", forState: .Normal)
            self.registerLabel?.text = self.isSignUp ? "Have an Account?" : "Don't have an account?"
            
            self.usernameField?.becomeFirstResponder()
        }
    }
    
    //MARK: buttons IBActions
    
    @IBAction func loginButton()
    {
        //verify if the labels are good
        if !self.isTextFieldsLegible { return }
        
        //blocks user interactions and puts a loading indicator on the screen
        self.activityIndicator.startAnimatingAndIgnoreInteractions()
        
        //Sets up the login request
        self.login.set(isSignIn: !self.isSignUp, username: self.usernameField!.text!, password: self.passwordField!.text!)
        //Gets if it has an error
        .onError
        {
            print("\($0)")
            //Creates an alert that shows the error
            self.createAlertWithTitle("request failed", andMessage: $0!)
            //reenable user interactions and removes the loading indicator on the screen
            self.activityIndicator.stopAnimatingAndIngnoreInteractions()
        }
        //Gets if is success
        .onSuccess
        {
            print("\($0)")
            
            //reenable user interactions and removes the loading indicator on the screen
            self.activityIndicator.stopAnimatingAndIngnoreInteractions()
            
            self.performSegueWithIdentifier(SegueIdentifier.Login, sender: self)
        }
        //Starts login request
        .start();
    }
    
    @IBAction func signupButton()
    {
        //switches the texts for sing up and login
        self.isSignUp = !self.isSignUp
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Sets up the activity spinner
        self.createActivitySpinner()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        /*if let _ = PFUser.currentUser()
        {
            self.performSegueWithIdentifier(SegueIdentifier.Login, sender: self)
        }*/
    }
    
    //MARK: Methods
    
    //Sets up the activity spinner
    func createActivitySpinner()
    {
        self.activityIndicator.frame = CGRectMake(0, 0, 100, 100)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        
        self.view.addSubview(self.activityIndicator)
    }
    
    //Creates an simples alert on the screen
    func createAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Prepera for segue
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let viewController = segue.verifiedViewController as? LoginViewController
        {
            if let identifier = segue.identifier
            {
                if identifier == SegueIdentifier.Login
                {
                    viewController.displayLayer(CALayer());
                }
            }
        }
    }*/

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
