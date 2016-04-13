//
//  Photo.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class Photo {
    /* The number of likes the photo has. */
    var likes : Int!
    /* The string of the url to the photo file. */
    var url_large : String!
    var url_thumbnail: String!
    /* The username of the photographer. */
    var username : String!
    var createdTime: NSDate!
    var largeImage: UIImage!
    var thumbnail: UIImage!
    var liked: Bool

    /* Parses a NSDictionary and creates a photo object. */
    init (data: NSDictionary) {
        likes = data.valueForKey("likes")?.valueForKey("count") as! Int
        url_large = data.valueForKey("images")?.valueForKey("standard_resolution")?.valueForKey("url") as! String
        url_thumbnail = data.valueForKey("images")?.valueForKey("thumbnail")?.valueForKey("url") as! String
        username = data.valueForKey("user")?.valueForKey("username") as! String
        createdTime = NSDate(timeIntervalSince1970: Double(data.valueForKey("created_time") as! String)!)
        liked = false
    }
    
    
}