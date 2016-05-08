//
//  myInfo.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Parse

class MyInfo : CanFailProtocol
{
    var users = [User]()
    
    internal var error: callClosure?
    internal var success: callClosure?
    
    private var userRequestCount = 0
    private var totalRequestedUsers = 0
    
    private func loadFollowing(following: PFUser, follower: String)
    {
        PFQuery(className: "Followers")
        .whereKey("follower", equalTo: follower)
        .whereKey("following", equalTo: following.objectId!)
        .findObjectsInBackgroundWithBlock
        {
            if let error = $1
            {
                print("Deu erro \(error.code)")
                if let closure = self.error { closure(RequestError(title: "Request failed", message: error.userInfo["error"] as! String)) }
                return
            }
            
            if let objs = $0 where objs.count > 0
            {
                print("Tem um usuário aqui q eu sigo %s ", objs[0]["follower"] as! String, objs[0]["following"] as! String)
                
                self.users.append(FUser(uniqueID: following.objectId!, username: following.username!))
            }
            else
            {
                self.users.append(SUser(uniqueID: following.objectId!, username: following.username!))
            }
            
            self.userRequestCount += 1
            self.verifyUserRequest()
        }
    }
    
    func loadUsersInfo() -> Self
    {
        self.users.removeAll()
        
        PFUser.query()?.findObjectsInBackgroundWithBlock
        {
            if let error = $1
            {
                print("Deu erro \(error.code)")
                if let closure = self.error { closure(RequestError(title: "Request failed", message: error.userInfo["error"] as! String)) }
                return
            }
            
            if let users = $0 where users.count > 0
            {
                self.totalRequestedUsers = users.count - 1
                
                for object in users
                {
                    if let user = object as? PFUser
                    {
                        print("Vai ver se eu sigo esse cara %s - ID %s", user.username!, user.objectId!)
                        
                        if user.objectId != PFUser.currentUser()!.objectId
                        {
                            self.loadFollowing(user, follower: PFUser.currentUser()!.objectId!)
                        }
                    }
                }
            }
        }
        
        return self
    }
    
    private func verifyUserRequest()
    {
        if self.totalRequestedUsers == self.userRequestCount
        {
            self.totalRequestedUsers = 0
            self.userRequestCount = 0
            if let closure = self.success { closure(nil) }
        }
    }
    
    func unfollowUser(following: String, follower: String) -> Self
    {
        PFQuery(className: "Followers")
        .whereKey("follower", equalTo: follower)
        .whereKey("following", equalTo: following)
        .findObjectsInBackgroundWithBlock
        { (objects, error) -> Void in
            if let objs = objects where objs.count > 0
            {
                objs[0].deleteInBackgroundWithBlock
                {
                    if let error = $1
                    {
                        print("Deu erro aqui na hora de apagar o rolê \(error.code)")
                        if let closure = self.error { closure(RequestError(title: "Request failed", message: error.userInfo["error"] as! String)) }
                        return
                    }
                    
                    if let closure = self.success { closure(nil) }
                }
            }
        }
        
        return self
    }
    
    func followUser(following: String, follower: String) -> Self
    {
        let followers = PFObject(className: "Followers")
        followers["following"] = following
        followers["follower"] = follower
        
        followers.saveInBackgroundWithBlock
        {
            if let error = $1
            {
                if let closure = self.error { closure(RequestError(title: "Request failed", message: error.userInfo["error"] as! String)) }
                return
            }
            
            if let closure = self.success { closure(nil) }
        }
        
        return self
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

protocol User
{
    var uniqueID:String { get }
    var username:String { get }
    var isFollowing:Bool { get }
}

extension User where Self: Following
{
    var isFollowing: Bool { return true }
}

protocol Following
{
    var message: String? { get }
    var imageFile: PFFile? { get }
}

struct SUser : User
{
    var uniqueID: String = "no ID"
    var username: String = "no name"
    var isFollowing = false
    
    init(uniqueID uID:String, username name:String)
    {
        self.uniqueID = uID
        self.username = name
    }
}

typealias FollowingUser = protocol<User, Following>
struct FUser : FollowingUser
{
    var uniqueID: String = "no ID"
    var username: String = "no name"
    var message: String? = "no message"
    var imageFile: PFFile?
    
    init(uniqueID uID:String, username name:String)
    {
        self.uniqueID = uID
        self.username = name
    }
}