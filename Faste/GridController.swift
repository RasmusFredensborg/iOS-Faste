//
//  ViewController.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class GridController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let videoArray = ["DtrcDz-yUKU", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0"]//, "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY", "BNdFm-stES0", "QBWwWP_5Nc8", "vsbxs8tYXxM", "kZOCBths2lY"]
    
    let apiKey: String = "AIzaSyBrA9OpNqp6u_wnMKfTaT3sBkjnmflmAuc"
    
    var videoIndex = 0
    
    var selectedVideoIndex: Int!
    let device = UIDevice.currentDevice().model
    var layout = UICollectionViewFlowLayout()
    let ytImgCache = YTImgCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.barTintColor = UIColor.darkGrayColor();
        self.title = "FASTEREGLER"
        let infoImage = UIImage(named: "info.png")
        let imgWidth = Int(30)
        let imgHeight = Int(30)
        
        let infoButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        infoButton.setBackgroundImage(infoImage, forState: .Normal)
        infoButton.addTarget(self, action: #selector(GridController.infoTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.orientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        var size = CGSize()
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        if(device == "iPad"){
            size.height = 239
            size.width = 300
            
            layout.minimumLineSpacing = 10
        }else{
            
            if(DeviceType.IS_IPHONE_6){
                size.width = 180
                size.height = 171
                layout.minimumLineSpacing = 5
                layout.minimumInteritemSpacing = 5
            }
            if(DeviceType.IS_IPHONE_5){
                size.width = 152
                size.height = 155
                layout.minimumLineSpacing = 5
                layout.minimumInteritemSpacing = 5
            }
        }
        layout.itemSize = size
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ThumbnailCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCell")
        
        var videos = "";
        for i in 0 ..< videoArray.count {
            videos += videoArray[i];
            if(i != videoArray.count-1){
                videos += ","
            }
        }
        getVideos(videos);
    }
    
    func orientation(){
        if(device == "iPad"){
            if(UIDevice.currentDevice().orientation.isLandscape){
                layout.sectionInset.left = 30
                layout.sectionInset.right = 30
                layout.sectionInset.top = 10
                layout.sectionInset.bottom = 10
            }
            else if(UIDevice.currentDevice().orientation.isPortrait){
                layout.sectionInset.left = 57
                layout.sectionInset.right = layout.sectionInset.left
                layout.sectionInset.top = 57
                layout.sectionInset.bottom = 57
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        orientation()
    }

        
    func infoTapped(){
        let alert = UIAlertController(title: "Emento", message: "Contact: developer@emento.dk", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytImgCache.YTVideosArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        let video = ytImgCache.YTVideosArray[indexPath.row]
        cell.titleLbl.text = video.title
        
        if(video.thumbnailImage == nil)
        {
            cell.alpha = 0;
            
            ytImgCache.load_image(video.thumbnailUrl, imageview: cell.thumbnailImg!, index: indexPath.row)
            
            UIView.animateWithDuration(0.5) {
                cell.alpha = 1.0
            }
        }
        else
        {
            cell.thumbnailImg.image = video.thumbnailImage
        }
        
        cell.viewLbl.text = String(video.viewCount)
        cell.durationLbl.text = ISOConverter(video.duration)
        
        cell.layer.shadowColor = UIColor.grayColor().CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 3.0;
        cell.layer.shadowOpacity = 0.25;
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius: 0).CGPath;
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedVideoIndex = indexPath.row
        performSegueWithIdentifier("idSeguePlayer", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "idSeguePlayer" {
            let playerViewController = segue.destinationViewController as! VideoController
            playerViewController.YTVideosArray = ytImgCache.YTVideosArray
            playerViewController.videoIndex = selectedVideoIndex
        }
        
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
    
    func do_grid_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
            return
        })
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
                        video.duration = videoDetailsDict["duration"] as! String
                        video.viewCount = Int(videoStatDict["viewCount"] as! String)!
                        video.likeCount = videoStatDict["likeCount"] as! String
                        
                        self.ytImgCache.YTVideosArray.append(video)
                        
                        self.videoIndex+=1
                        if self.videoIndex == self.videoArray.count{
                            //self.YTVideosArray.sortInPlace({$0.viewCount > $1.viewCount}); // Sorting algorithm
                            do{
                                try self.ytImgCache.read()
                                self.do_grid_refresh()
                            }
                            catch _{
                                
                            }
                        }
                    }
                }
                catch _{
                    
                }
            }
            else{
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading videos: \(error)")
            }
        })
    }
    
    
}

