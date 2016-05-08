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
    @IBOutlet var backgroundView: UIView!
    
    var videoIndex = 0
    
    var selectedVideoIndex: Int!
    let device = UIDevice.currentDevice().model
    let ytHelper = YTHelper()
    var layout = UICollectionViewFlowLayout();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)
        
        self.navigationItem.titleView = constructTitle();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.didBecomeReachable), name: "Reachable", object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ThumbnailCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCell")
        var size = CGSize()
        
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        if(DeviceType.IS_IPHONE_6){
            size.width = 180
            size.height = 180
            layout.minimumLineSpacing = 5
        }
        if(DeviceType.IS_IPHONE_5){
            size.width = 150
            size.height = 150
            layout.minimumLineSpacing = 6
        }
//        layout.minimumInteritemSpacing = 5
        layout.sectionInset.top = layout.minimumLineSpacing
        layout.sectionInset.left = layout.sectionInset.top
        layout.sectionInset.right = layout.sectionInset.top
        
        layout.itemSize = size
        
        
        ytHelper.getVideos(self);
    }
    
    override func viewDidLayoutSubviews() {
        var collectionSize = collectionView.collectionViewLayout.collectionViewContentSize()        
        
        let topImage = UIImage(named: "background.png")
        var bottomImage = UIImage()
        let rect = CGRectMake(0, 0, collectionSize.width, collectionSize.height)
        UIGraphicsBeginImageContextWithOptions(collectionSize, false, 0)
        
        var color = UIColor(red: 0x18/255,green: 0x1F/255,blue: 0x59/255,alpha: 1.0)
        color.setFill()
        UIRectFill(rect)
        bottomImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        backgroundView.backgroundColor = color;
        
        let size = CGSizeMake(topImage!.size.width, topImage!.size.height + bottomImage.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        [topImage!.drawInRect(CGRectMake(0,0,size.width, topImage!.size.height))];
        [bottomImage.drawInRect(CGRectMake(0,topImage!.size.height,size.width, bottomImage.size.height))];
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //        collectionView.backgroundView = backgroundImage
        collectionView.backgroundColor = UIColor(patternImage: newImage)
    }
    
    @objc func didBecomeReachable(note: NSNotification){
        if(ytHelper.ytImgCache.YTVideosArray.count == 0)
        {
            self.ytHelper.getVideos(self)
        }
    }

    func constructTitle() -> UIView
    {
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
        titleLabel.text = "FASTE"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 12)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit();
        titleLabel.textAlignment = NSTextAlignment.Center
        
        let titleLabel2 = UILabel(frame: CGRectMake(titleLabel.frame.size.width, 0, 0, 0))
        titleLabel2.text = "regler"
        titleLabel2.font = UIFont(name: "AvenirNext-Medium", size: 12)
        titleLabel2.textColor = UIColor.whiteColor()
        titleLabel2.sizeToFit();
        titleLabel2.textAlignment = NSTextAlignment.Center
        let twoSegmentTitleView = UIView(frame: CGRectMake(0, 0, titleLabel.frame.size.width+titleLabel2.frame.size.width, titleLabel.frame.size.height));
        twoSegmentTitleView.addSubview(titleLabel)
        twoSegmentTitleView.addSubview(titleLabel2)
        return twoSegmentTitleView;
    }
    
    func infoTapped(){
        let alert = UIAlertController(title: "Emento", message: "Contact: developer@emento.dk", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytHelper.ytImgCache.YTVideosArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        let video = ytHelper.ytImgCache.YTVideosArray[indexPath.row]
        cell.titleLbl.text = video.title.uppercaseString
        
        cell.alpha = 0;
        
        UIView.animateWithDuration(0.5) {
            cell.alpha = 1.0
        }
        if(video.thumbnailImage == nil)
        {
            ytHelper.loadImage(video.thumbnailUrl, imageview: cell.thumbnailImg!, index: indexPath.row)

        }
        else
        {
            cell.thumbnailImg.image = video.thumbnailImage
        }
        
        cell.viewLbl.text = String(video.viewCount)
        cell.durationLbl.text = video.duration
        
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
            playerViewController.YTVideosArray = ytHelper.ytImgCache.YTVideosArray
            playerViewController.videoIndex = selectedVideoIndex
        }
        
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
}

