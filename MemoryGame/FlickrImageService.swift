//
//  FlickrImageService.swift
//  MemoryGame
//  this service fecthes the images from the flickr services & converts it into custom objects
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import Foundation
import Alamofire

//enum to specify the size of images to be downloaded
enum Size: String {
    case small = "s"
    case medium = "m"
    case large = "b"
}

//store the collection of images fetched
struct FlickrResults {
    let imageCollection : [FlickrPhoto]
}

public class FlickrImageService:NSObject{
    
    //shared instance since we neednt instantiate more than once
    class var sharedInstance : FlickrImageService {
        struct Singleton {
            static var instance:FlickrImageService? = nil
        }
        
        if(Singleton.instance == nil){
            Singleton.instance = FlickrImageService()
        }
        // Return singleton instance
        return Singleton.instance!
    }
    
    //imageSize:String - > image size provided as input to download the appropritae image size
    
    func fetchImages(imageSize:String, completion: (results: FlickrResults?, error : NSError?) -> Void){
        
        if(imageSize == Size.medium.rawValue){
            FlickrClient.sharedInstance.noOfPages = 6
        }else if(imageSize == Size.large.rawValue){
            FlickrClient.sharedInstance.noOfPages = 4
        }else{
            FlickrClient.sharedInstance.noOfPages = 8
        }
        
        Alamofire.request(FlickrClient.sharedInstance.URLRequest)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion(results: nil,error: response.result.error)
                    return
                }
                
                let responseJSON = response.result.value as? NSDictionary
                let results = responseJSON!["photos"] as? NSDictionary
                let photosArray = results!["photo"] as! [NSDictionary]
                
                let flickrPhotos : [FlickrPhoto] = photosArray.map {
                    photoDictionary in
                    
                    let photoID = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let server = photoDictionary["server"] as? String ?? ""
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret, title: title)
                    
                    let imageData = NSData(contentsOfURL: flickrPhoto.flickrImageURL(imageSize))
                    flickrPhoto.image = UIImage(data: imageData!)
                    
                    return flickrPhoto
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    // the array needs to be duplicated & shuffled for the game
                    let concatenatedArray = flickrPhotos + flickrPhotos
                    completion(results:FlickrResults(imageCollection: concatenatedArray.shuffle), error: nil)
                })

        }
    }
}
