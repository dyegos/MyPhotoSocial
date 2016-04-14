//
//  Login.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

typealias callClosure = (String?) -> Void

protocol CanFailProtocol
{
    var error: callClosure? { get }
    var success: callClosure? { get }
    
    func onError(closure: callClosure) -> Self
    func onSuccess(closure: callClosure) -> Self
}

class Login : CanFailProtocol
{
    private var username = ""
    private var password = ""
    private var isSignIn = false
    
    internal var error: callClosure?
    internal var success: callClosure?
    
    init() {}
    
    func set(isSignIn isS:Bool, username name:String, password pass:String) -> Self
    {
        self.username = name
        self.password = pass
        self.isSignIn = isS
        
        return self
    }
    
    func start()
    {
        if self.isSignIn
        {
            PFUser.logInWithUsernameInBackground(self.username, password: self.password)
            {
                [unowned self] in
                
                if let error = $1
                {
                    if let closure = self.error { closure(error.userInfo["error"] as? String) }
                    return
                }
                
                if let closure = self.success { closure("OK") }
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
                    if let closure = self.error { closure(error.userInfo["error"] as? String) }
                    return
                }
                    
                if let closure = self.success { closure("OK") }
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
