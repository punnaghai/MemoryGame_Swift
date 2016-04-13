//
//  FlickrClient.swift
//  MemoryGame
// The client instance constucts the URL that needs to be used for fetching the contents from flickr
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import Foundation
import Alamofire

public class FlickrClient: URLRequestConvertible {
    static let baseURLPath = "https://api.flickr.com/services/rest/?method=flickr.photos"
    static let authenticationToken = "5423dbab63f23a62ca4a986e7cbb35e2"
    static let queryString1 = String(format:"&api_key=%@",FlickrClient.authenticationToken)
    
    var queryString2 = "&per_page=%@&format=json&nojsoncallback=1"
    var noOfPages:Int = 0
    
    class var sharedInstance : FlickrClient {
        struct Singleton {
            static var instance:FlickrClient? = nil
        }
        
        if(Singleton.instance == nil){
            Singleton.instance = FlickrClient()
        }
        // Return singleton instance
        return Singleton.instance!
    }
    
    public var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method) = {
                return (".getRecent", .GET)
        }()
        let pageParamsString = String(format:queryString2,String(noOfPages))
        let urlString = String(format: "%@%@%@%@",FlickrClient.baseURLPath, result.path, FlickrClient.queryString1,pageParamsString)
        let URL = NSURL(string:urlString)!
        
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
        return URLRequest
    }
}