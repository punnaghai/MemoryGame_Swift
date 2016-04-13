//
//  FlickrPhoto.swift
//  MemoryGame
//  Model object that stores the image details fetched from the service & populate the app
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import Foundation

class FlickrPhoto:NSObject {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    var image:UIImage?
    
    init (photoID:String,farm:Int, server:String, secret:String, title:String) {
        self.photoId = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
        self.title = title
    }
    
    func flickrImageURL(size:String = "s") -> NSURL {
        return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(size).jpg")!
    }
}