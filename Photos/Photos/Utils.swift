//
//  Utils.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation

class Utils {
    
    class func clientID() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let cid = NSDictionary(contentsOfFile: path!)?.valueForKey("client_id") as! String
        return cid
    }

    class func getPopularURL() -> NSURL {
        let cid = clientID()
        let urlStr = "https://api.instagram.com/v1/media/popular?client_id=\(cid)"
        return NSURL(string: urlStr)!
    }
    
    class func getHashtagURL(hashtag: String) -> NSURL {
        let cid = clientID()
        let newHashtag = hashtag.stringByReplacingOccurrencesOfString(" ", withString: "")
        let urlStr = "https://api.instagram.com/v1/tags/\(newHashtag)/media/recent?client_id=\(cid)"
        return NSURL(string: urlStr)!
    }
    
}