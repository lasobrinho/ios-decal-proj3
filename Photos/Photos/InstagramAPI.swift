//
//  InstagramAPI.Swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation
import UIKit

class InstagramAPI {
    /* Connects with the Instagram API and pulls resources from the server. */
    func loadPhotos(search: String, completion: (([Photo]) -> Void)!) {
        var url: NSURL
        if search.isEmpty {
            url = Utils.getPopularURL()
        } else {
            url = Utils.getHashtagURL(search)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                var photos = [Photo]()
                do {
                    let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let dataValues = feedDictionary.valueForKey("data") as! [NSDictionary]
                    
                    for keys in dataValues {
                        photos.append(Photo(data: keys))
                    }
                    
                    // DO NOT CHANGE BELOW
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(photos)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func loadThumbnail(photo: Photo, cell: PhotosCollectionViewCell, completion: ((PhotosCollectionViewCell, UIImage) -> Void)!) {
        let loadURL = NSURL(string: photo.url_thumbnail)!
        NSURLSession.sharedSession().dataTaskWithURL(loadURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                var thumbnailImage: UIImage
                do {
                    thumbnailImage = UIImage(data: data!)!
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(cell, thumbnailImage)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
            }.resume()
    }
    
    func loadLargeImage(photo: Photo, detailVC: DetailViewController, completion: ((DetailViewController, UIImage) -> Void)!) {
        let url = (photo.url_large as NSString).stringByReplacingOccurrencesOfString("s640x640/sh0.08/e35/", withString: "")
        let loadURL = NSURL(string: url)!
        NSURLSession.sharedSession().dataTaskWithURL(loadURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                var largeImage: UIImage
                do {
                    largeImage = UIImage(data: data!)!
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(detailVC, largeImage)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
            }.resume()
    }
    
}