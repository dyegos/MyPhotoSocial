//
//  Login.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

typealias callClosure = (RequestError?) -> Void

protocol CanFailProtocol
{
    var error: callClosure? { get }
    var success: callClosure? { get }
    
    func onError(closure: callClosure) -> Self
    func onSuccess(closure: callClosure) -> Self
}

class Login : CanFailProtocol, LoginVerifier
{
    private var username:String?
    private var password:String?
    private var isSignIn = false
    
    internal var error: callClosure?
    internal var success: callClosure?
    
    func set(isSignIn isS:Bool, username name:String?, password pass:String?) -> Self
    {
        self.username = name
        self.password = pass
        self.isSignIn = isS
        
        return self
    }
    
    func start()
    {
        guard let userInfo = isTextFieldsLegible(self.username, password: self.password) else
        {
            if let closure = self.error { closure(RequestError(title: "Invalid input", message: "Please enter a valid username or password")) }
            return
        }
        
        if self.isSignIn
        {
            PFUser.logInWithUsernameInBackground(userInfo.username, password: userInfo.password)
            {
                [unowned self] in
                
                if let error = $1
                {
                    if let closure = self.error { closure(RequestError(title: "Request failed", message: error.userInfo["error"] as! String)) }
                    return
                }
                
                if let closure = self.success { closure(nil) }
            }
        }
        else
        {
            let user = PFUser()
            user.username = self.username
            user.password = self.password
            
            user.signUpInBackgroundWithBlock
            {
                [unowned self] in
                
                if let error = $1
                {
                    if let closure = self.error { closure(RequestError(title: "Request failed", message: error.userInfo["error"] as! String)) }
                    return
                }
                    
                if let closure = self.success { closure(nil) }
            }
        }
    }
    
    //MARK: Protocol implementation
    
    func onError(closure: callClosure) -> Self
    {
        self.error = closure
        
        return self
    }
    
    func onSuccess(closure: callClosure) -> Self
    {
        self.success = closure
        
        return self
    }
}
