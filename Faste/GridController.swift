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
    var layout = UICollectionViewFlowLayout()
    let ytHelper = YTHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)
        self.title = "FASTEREGLER"
//        let infoImage = UIImage(named: "info.png")
//        let imgWidth = Int(30)
//        let imgHeight = Int(30)
//        let infoButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
//        infoButton.setBackgroundImage(infoImage, forState: .Normal)
//        infoButton.addTarget(self, action: #selector(GridController.infoTapped), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        
        self.navigationItem.titleView = constructTitle();
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.orientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.didBecomeReachable), name: "Reachable", object: nil)
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        var size = CGSize()
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ThumbnailCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCell")
        
        ytHelper.getVideos(self);
    }
    
    @objc func didBecomeReachable(note: NSNotification){
        if(ytHelper.ytImgCache.YTVideosArray.count == 0)
        {
            self.ytHelper.getVideos(self)
        }
    }
    
//    func orientation(){
//        if(device == "iPad"){
//            if(UIDevice.currentDevice().orientation.isLandscape){
//                layout.sectionInset.left = 30
//                layout.sectionInset.right = 30
//                layout.sectionInset.top = 10
//                layout.sectionInset.bottom = 10
//            }
//            else if(UIDevice.currentDevice().orientation.isPortrait){
//                layout.sectionInset.left = 57
//                layout.sectionInset.right = layout.sectionInset.left
//                layout.sectionInset.top = 57
//                layout.sectionInset.bottom = 57
//            }
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
//        orientation()
    }

    func constructTitle() -> UIView
    {
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
        titleLabel.text = "FASTE"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 24)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit();
        titleLabel.textAlignment = NSTextAlignment.Center
        
        let titleLabel2 = UILabel(frame: CGRectMake(titleLabel.frame.size.width, 0, 0, 0))
        titleLabel2.text = "regler"
        titleLabel2.font = UIFont(name: "AvenirNext-Medium", size: 24)
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
        
        if(video.thumbnailImage == nil)
        {
            cell.alpha = 0;
            
            ytHelper.loadImage(video.thumbnailUrl, imageview: cell.thumbnailImg!, index: indexPath.row)
            
            UIView.animateWithDuration(0.5) {
                cell.alpha = 1.0
            }
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

