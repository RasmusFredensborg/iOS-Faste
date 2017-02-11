//
//  YTHelper.swift
//  Fasteregler
//
//  Created by Rasmus Fredensborg Jensen on 26/04/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class YTHelper
{
    let videoArray = ["DtrcDz-yUKU", "QBWwWP_5Nc8", "kZOCBths2lY", "vsbxs8tYXxM", "8oo8z8NwpLA", "BNdFm-stES0"]
    
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
    
    func loadImage(_ urlString:String, imageview:UIImageView, index:NSInteger)
    {
        ytImgCache.load_image(urlString, imageview: imageview, index: index)
    }
    
    func performGetRequest(_ targetURL: URL!, completion: @escaping (_ data: Data?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void) {
        let request = URLRequest(url: targetURL)
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in DispatchQueue.main.async(execute: { () -> Void in
            if(error == nil){
                completion(data, (response as! HTTPURLResponse).statusCode, error as NSError?)
            }
            else{
                print("Offline!")
                completion(data, 0, error as NSError?)
            }
        })
        })
        
        task.resume()
    }
    
    func getVideos(_ parent : UIViewController) {
        // Form the request URL string.
        let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(videos)&part=snippet,contentDetails,statistics&key=\(apiKey)"
        
        // Create a NSURL object based on the above string.
        let targetURL = URL(string: urlString)
        
        // Fetch the playlist from Google.
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do{
                    let resultsDict = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    for i in 0 ..< items.count {
                        let videoSnippetDict = (items[i] as NSDictionary)["snippet"] as! NSDictionary
                        let videoDetailsDict = (items[i] as NSDictionary)["contentDetails"] as! NSDictionary
                        let videoStatDict = (items[i] as NSDictionary)["statistics"] as! NSDictionary
                        let video = YTVideo()
                        video.ID = (items[i] as NSDictionary)["id"] as! String
                        video.title = videoSnippetDict["title"] as! String
                        video.thumbnailUrl = ((videoSnippetDict["thumbnails"] as! NSDictionary)["medium"] as! NSDictionary)["url"] as! String
                        video.thumbnailWidth = ((videoSnippetDict["thumbnails"] as! NSDictionary)["medium"] as! NSDictionary)["width"] as! Int
                        video.thumbnailHeight = ((videoSnippetDict["thumbnails"] as! NSDictionary)["medium"] as! NSDictionary)["height"] as! Int
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
                                
                                if(parent.isKind(of: GridController.self)){
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
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                parent.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func ISOConverter(_ source: String) -> String{
        var isoString = source.replacingOccurrences(of: "PT", with: "", options: NSString.CompareOptions.literal, range: nil)
        var hours = ""
        var minutes = ""
        
        if isoString.range(of: "H") != nil {
            let stringArray = isoString.characters.split(separator: "H").map(String.init)
            hours = stringArray[0] + ":"
            isoString = stringArray[1]
        }
        if isoString.range(of: "M") != nil {
            let stringArray = isoString.characters.split(separator: "M").map(String.init)
            let minutesPre = stringArray[0]
            minutes = (Int(minutesPre) < 10 ? "0" + minutesPre : minutesPre) + ":"
            isoString = stringArray[1]
        }
        else
        {
            minutes = "0:"
        }
        let secondsPre = isoString.characters.split(separator: "S").map(String.init)[0]
        let seconds = (Int(secondsPre) < 10 ? "0"+secondsPre : secondsPre)
        let duration = hours + minutes + seconds
        return duration
    }
    

}
