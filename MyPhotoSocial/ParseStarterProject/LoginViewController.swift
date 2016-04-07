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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var toggleState: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    //MARK: Properties
    
    var login = Login()
    var activityIndicator: UIActivityIndicatorView!
    var isTextFieldsLegible : Bool
    {
        guard self.usernameField.text != "" || self.passwordField.text != "" else
        {
            self.createAlertWithTitle("Invalid input", andMessage: "Please enter a valid username and password")
                
            return false
        }
            
        return true
    }
    var isSignUp = false
    {
        didSet
        {
            self.requestButton.setTitle(self.isSignUp ? "Sign up" : "Login", forState: .Normal)
            self.toggleState.setTitle(self.isSignUp ? "Login" : "Sign up", forState: .Normal)
            self.registerLabel.text = self.isSignUp ? "Have an Account?" : "Don't have an account?"
            
            self.usernameField.becomeFirstResponder()
        }
    }
    
    //MARK: buttons IBActions
    
    @IBAction func loginButton()
    {
        if !self.isTextFieldsLegible { return }
        
        self.activityIndicator.startAnimatingAndIgnoreInteractions()
        
        self.login.set(isSignIn: !self.isSignUp, username: self.usernameField.text!, password: self.passwordField.text!)
        .onError
        {
            print("\($0!)")
            self.createAlertWithTitle("request failed", andMessage: $0!)
            self.activityIndicator.stopAnimatingAndIngnoreInteractions()
        }
        .onSuccess
        {
            print("\($0!)")
            self.activityIndicator.stopAnimatingAndIngnoreInteractions()
            
            self.performSegueWithIdentifier(SegueIdentifier.Login, sender: self)
        }.start();
    }
    
    @IBAction func signupButton()
    {
        self.isSignUp = !self.isSignUp
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.createAcitivitySpinner()
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
    
    func createAcitivitySpinner()
    {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        
        self.view.addSubview(self.activityIndicator)
    }
    
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
