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
    private let login = Login()
    //Creates the UIActivityIndicatorView object
    private lazy var activityIndicator:UIActivityIndicatorView =
    { [unowned self] in
        
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRectMake(0, 0, 100, 100)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .Gray
        
        return indicator
    }()
    
    private lazy var tapGesture:UITapGestureRecognizer =
    { [unowned self] in
            
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touched))
        return gesture
    }()
    
    //Propertie that helps switch the label and button names if the user wants to sign up ou login
    private var isSignUp = false
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
    @IBAction private func loginButton()
    {
        //blocks user interactions and puts a loading indicator on the screen
        self.activityIndicator.startAnimatingAndIgnoreInteractions()
        
        //Sets up the login request
        self.login.set(isSignIn: !self.isSignUp, username: self.usernameField?.text, password: self.passwordField?.text)
        //Gets if it has an error
        .onError
        {
            let error = $0!
            //Creates an alert that shows the error
            self.createAlertWithTitle(error.title, andMessage: error.message)
            //reenable user interactions and removes the loading indicator on the screen
            self.activityIndicator.stopAnimatingAndIngnoreInteractions()
        }
        //Gets if is success
        .onSuccess
        { _ in
            //reenable user interactions and removes the loading indicator on the screen
            self.activityIndicator.stopAnimatingAndIngnoreInteractions()
            
            self.performSegueWithIdentifier(SegueIdentifier.Login, sender: self)
        }
        //Starts login request
        .start();
    }
    
    @IBAction private func signupButton()
    {
        //switches the texts for sing up and login
        self.isSignUp = !self.isSignUp
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if let _ = PFUser.currentUser()?.objectId
        {
            self.performSegueWithIdentifier(SegueIdentifier.Login, sender: self)
            return
        }
        
        self.usernameField?.delegate = self
        self.passwordField?.delegate = self
        self.view.addGestureRecognizer(self.tapGesture)
        self.view.addSubview(activityIndicator)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Touch Delegate
    func touched()
    {
        self.view.endEditing(true)
    }
}