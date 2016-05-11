//
//  FeedTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by iPicnic Digital on 3/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

protocol UserNamePresentable
{
    var name: String { get }
}

protocol MessageFieldPresentable
{
    var message: String { get }
}

protocol ImageViewPFFilePresentable
{
    var imageFile: PFFile? { get }
}

protocol ImageViewPresentable
{
    var imageName: String { get }
}


struct CardViewModel : UserPhotoCard
{
    let model: FUser
}

extension CardViewModel
{
    var message:String { return model.message ?? "" }
}
extension CardViewModel
{
    var name:String { return model.username }
}
extension CardViewModel
{
    var imageFile:PFFile? { return model.imageFile }
}

typealias UserPhotoCard = protocol<UserNamePresentable, MessageFieldPresentable, ImageViewPFFilePresentable>

class FeedTableViewCell: UITableViewCell
{
    @IBOutlet weak private var photoImageView: UIImageView?
    @IBOutlet weak private var userName: UILabel?
    @IBOutlet weak private var messageTextField: UILabel?
    
    private var presenter: UserPhotoCard?
    
    func configure(withPresenter presenter: UserPhotoCard)
    {
        self.presenter = presenter
        
        photoImageView?.convertParseImageFile(self.presenter?.imageFile)
        userName?.text = self.presenter?.name
        messageTextField?.text = self.presenter?.message
    }
}
