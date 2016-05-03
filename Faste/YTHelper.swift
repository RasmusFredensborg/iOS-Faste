//
//  YTHelper.swift
//  Fasteregler
//
//  Created by Rasmus Fredensborg Jensen on 26/04/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class YTHelper
{
    let videoArray = ["DtrcDz-yUKU", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0"]//, "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM"]
    
    let apiKey: String = "AIzaSyBrA9OpNqp6u_wnMKfTaT3sBkjnmflmAuc"
    let ytImgCache = YTImgCache()
    var videoCount = 0
    var videoIndex = 0
    var videos = "";
    
    init()
    {
        videoCount = videoArray.count;
        
        for i in 0 ..< videoCount {
            videos += videoArray[i];
            if(i != videoArray.count-1){
                videos += ","
            }
        }
    }
    
    func loadImage(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        ytImgCache.load_image(urlString, imageview: imageview, index: index)
    }
    
    func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if(error == nil){
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            }
            else{
                print("Offline!")
                completion(data: data, HTTPStatusCode: 0, error: error)
            }
        })
        })
        
        task.resume()
    }
    
    func getVideos(parent : UIViewController) {
        // Form the request URL string.
        let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(videos)&part=snippet,contentDetails,statistics&key=\(apiKey)"
        
        // Create a NSURL object based on the above string.
        let targetURL = NSURL(string: urlString)
        
        // Fetch the playlist from Google.
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do{
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    for i in 0 ..< items.count {
                        let videoSnippetDict = (items[i] as Dictionary<NSObject, AnyObject>)["snippet"] as! Dictionary<NSObject, AnyObject>
                        let videoDetailsDict = (items[i] as Dictionary<NSObject, AnyObject>)["contentDetails"] as! Dictionary<NSObject, AnyObject>
                        let videoStatDict = (items[i] as Dictionary<NSObject, AnyObject>)["statistics"] as! Dictionary<NSObject, AnyObject>
                        let video = YTVideo()
                        video.ID = (items[i] as Dictionary<NSObject, AnyObject>)["id"] as! String
                        video.title = videoSnippetDict["title"] as! String
                        video.thumbnailUrl = ((videoSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["url"] as! String
                        video.thumbnailWidth = ((videoSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["width"] as! Int
                        video.thumbnailHeight = ((videoSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["height"] as! Int
                        video.description = videoSnippetDict["description"] as! String
                        video.duration = self.ISOConverter( videoDetailsDict["duration"] as! String )
                        video.viewCount = Int(videoStatDict["viewCount"] as! String)!
                        video.likeCount = videoStatDict["likeCount"] as! String
                        
                        self.ytImgCache.YTVideosArray.append(video)
                        
                        self.videoIndex+=1
                        if self.videoIndex == self.videoArray.count{
                            //self.YTVideosArray.sortInPlace({$0.viewCount > $1.viewCount}); // Sorting algorithm
                            do{
                                try self.ytImgCache.read()
                                
                                if(parent.isKindOfClass(GridController)){
                                    (parent as! GridController).do_grid_refresh()
                                }
                                else{
                                    (parent as! GridControlleriPad).do_grid_refresh()
                                }
                            }
                            catch _{
                                
                            }
                        }
                    }
                }
                catch _{
                    print("Error")
                }
            }
            else{
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading videos: \(error)")
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                parent.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func ISOConverter(source: String) -> String{
        var isoString = source.stringByReplacingOccurrencesOfString("PT", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var hours = ""
        var minutes = ""
        
        if isoString.rangeOfString("H") != nil {
            let stringArray = isoString.characters.split("H").map(String.init)
            hours = stringArray[0] + ":"
            isoString = stringArray[1]
        }
        if isoString.rangeOfString("M") != nil {
            let stringArray = isoString.characters.split("M").map(String.init)
            let minutesPre = stringArray[0]
            minutes = (Int(minutesPre) < 10 ? "0" + minutesPre : minutesPre) + ":"
            isoString = stringArray[1]
        }
        else
        {
            minutes = "0:"
        }
        let secondsPre = isoString.characters.split("S").map(String.init)[0]
        let seconds = (Int(secondsPre) < 10 ? "0"+secondsPre : secondsPre)
        let duration = hours + minutes + seconds
        return duration
    }
    

}
