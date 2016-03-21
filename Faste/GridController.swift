//
//  ViewController.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class GridController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videoArray = ["QBWwWP_5Nc8","8oo8z8NwpLA","BNdFm-stES0", "DtrcDz-yUKU", "kZOCBths2lY", "vsbxs8tYXxM","QBWwWP_5Nc8","8oo8z8NwpLA","DtrcDz-yUKU","QBWwWP_5Nc8","8oo8z8NwpLA","DtrcDz-yUKU","QBWwWP_5Nc8","8oo8z8NwpLA","BNdFm-stES0", "DtrcDz-yUKU", "kZOCBths2lY", "vsbxs8tYXxM","QBWwWP_5Nc8","8oo8z8NwpLA","DtrcDz-yUKU","QBWwWP_5Nc8","8oo8z8NwpLA","DtrcDz-yUKU"]
    
    let apiKey: String = "AIzaSyBrA9OpNqp6u_wnMKfTaT3sBkjnmflmAuc"
    var desiredChannelsArray = ["Emento Developer"]
    var videoIndex = 0
    var channelsDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    var YTVideosArray: Array<YTVideo> = []
    var selectedVideoIndex: Int!
    var viewLoaded = false
    var shadowLoaded = false
    var newHeight : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.barTintColor = UIColor.darkGrayColor();
        let navSize = self.navigationController!.navigationBar.frame
        self.navigationController!.navigationBar.frame.size.width =  100
        self.title = "FASTEREGLER"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        var videos = "";
        for(var i = 0; i<videoArray.count; i++){
            videos += videoArray[i];
            if(i != videoArray.count-1){
                videos += ","
            }
        }
        getVideos(videos);
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YTVideosArray.count
    }
    
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var size : CGSize = layout.itemSize
        var rect = CGRect()
        size.height = self.newHeight
        
        if(!shadowLoaded){
            var visibleCells = layout.collectionView!.visibleCells()
            if(visibleCells.count != 0){
                for cell in visibleCells{
                    rect.size = size
                    cell.layer.shadowColor = UIColor.grayColor().CGColor;
                    cell.layer.shadowOffset = CGSizeMake(0, 2.0);
                    cell.layer.shadowRadius = 3.0;
                    cell.layer.shadowOpacity = 0.25;
                    cell.layer.masksToBounds = false;
                    cell.layer.shadowPath = UIBezierPath(roundedRect:rect, cornerRadius: 0).CGPath;
                }
                shadowLoaded = true
            }
        }
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
        if(viewLoaded != true){
            
            let video = YTVideosArray[indexPath.item]
            cell.titleLbl.text = video.title
            
            let ratio = CGFloat(video.thumbnailHeight)/CGFloat(video.thumbnailWidth)
            var bounds = CGRect()
            
            bounds.origin = CGPointZero;
            bounds.size = CGSize(width: cell.bounds.width, height: cell.bounds.width*ratio)
            let imgURL: NSURL = NSURL(string: video.thumbnail)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: NSOperationQueue.mainQueue(),
                completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                    if error == nil {
                        cell.thumbnailImg.image = UIImage(data: data!)!
                        cell.thumbnailImg.bounds = bounds;
                        
                    }
            })
            
            cell.viewLbl.text = video.viewCount
            cell.durationLbl.text = ISOConverter(video.duration)
            if(indexPath.item == YTVideosArray.count-1){
                self.newHeight = bounds.size.height + cell.descriptionView.bounds.height
                viewLoaded = true
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
            
            
        }
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedVideoIndex = indexPath.row
        performSegueWithIdentifier("idSeguePlayer", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "idSeguePlayer" {
            let playerViewController = segue.destinationViewController as! VideoController
            playerViewController.video = YTVideosArray[selectedVideoIndex]
        }
    }
    
    func ISOConverter(var isoString: String) -> String{
        isoString = isoString.stringByReplacingOccurrencesOfString("PT", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
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
            minutes = (Int(minutesPre) < 10 ? "0"+minutesPre : minutesPre) + ":"
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
    
    func getIndexPathForSelectedCell() -> NSIndexPath? {
        var indexPath:NSIndexPath?
        
        if collectionView.indexPathsForSelectedItems()?.count > 0{
            indexPath = collectionView.indexPathsForSelectedItems()![0]
        }
        return indexPath
    }
    
    func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in dispatch_async(dispatch_get_main_queue(), { () -> Void in completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
        })
        })
        
        task.resume()
    }
    
    func getVideos(videos : String) {
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
                    
                    for var i=0; i<items.count; ++i {
                        let videoSnippetDict = (items[i] as Dictionary<NSObject, AnyObject>)["snippet"] as! Dictionary<NSObject, AnyObject>
                        let videoDetailsDict = (items[i] as Dictionary<NSObject, AnyObject>)["contentDetails"] as! Dictionary<NSObject, AnyObject>
                        let videoStatDict = (items[i] as Dictionary<NSObject, AnyObject>)["statistics"] as! Dictionary<NSObject, AnyObject>
                        let video = YTVideo()
                        video.ID = (items[i] as Dictionary<NSObject, AnyObject>)["id"] as! String
                        video.title = videoSnippetDict["title"] as! String
                        video.thumbnail = ((videoSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["url"] as! String
                        video.thumbnailWidth = ((videoSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["width"] as! Int
                        video.thumbnailHeight = ((videoSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["height"] as! Int
                        video.description = videoSnippetDict["description"] as! String
                        video.duration = videoDetailsDict["duration"] as! String
                        video.viewCount = videoStatDict["viewCount"] as! String
                        video.likeCount = videoStatDict["likeCount"] as! String
                        
                        self.YTVideosArray.append(video)
                        
                        
                        self.videoIndex++
                        if self.videoIndex == self.videoArray.count{
                            self.collectionView.reloadData()
                        }
                    }
                }
                catch _{
                    
                }
            }
            else{
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel videos: \(error)")
            }
        })
    }
    
    
}

