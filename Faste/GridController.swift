//
//  ViewController.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit
import SafariServices

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

class GridController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate, InfoPopUpViewControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var backgroundView: UIView!
    
    var videoIndex = 0
    
    var selectedVideoIndex: Int!
    let device = UIDevice.currentDevice().model
    let ytHelper = YTHelper()
    var layout = UICollectionViewFlowLayout();
    var cellsLoaded = 0;
    var fontSize = 0;
    var infoViewController = InfoPopUpViewController();
    var infoButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoViewController.delegate = self;
        infoViewController.loadView();
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)
        
        self.navigationItem.titleView = constructTitle();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.didBecomeReachable), name: "Reachable", object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ThumbnailCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCell")
        var size = CGSize()
        
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        if(DeviceType.IS_IPHONE_6P){
            size.width = 190
            size.height = 190
            layout.minimumLineSpacing = 10
            fontSize = 13;
        }
        if(DeviceType.IS_IPHONE_6){
            size.width = 170
            size.height = 170
            layout.minimumLineSpacing = 10
            fontSize = 10;
        }
        if(DeviceType.IS_IPHONE_5){
            size.width = 150
            size.height = 150
            layout.minimumLineSpacing = 6
            fontSize = 8;
        }
        if(DeviceType.IS_IPHONE_4_OR_LESS){
            size.width = 150
            size.height = 150
            layout.minimumLineSpacing = 7
            fontSize = 8;
        }
        layout.sectionInset.top = layout.minimumLineSpacing
        layout.sectionInset.left = layout.sectionInset.top
        layout.sectionInset.right = layout.sectionInset.top
        
        layout.itemSize = size
        
        
        ytHelper.getVideos(self);
        
        let infoImage = UIImage(named: "ic_info_outline_white_2x.png")
        let imgWidth = Int(20)
        let imgHeight = Int(20)
        infoButton = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        infoButton.setBackgroundImage(infoImage, forState: .Normal)
        infoButton.addTarget(self, action: #selector(GridController.infoTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let collectionSize = collectionView.collectionViewLayout.collectionViewContentSize()
        
        let topImage = UIImage(named: "background.png")
        var bottomImage = UIImage()
        let rect = CGRectMake(0, 0, collectionSize.width, collectionSize.height)
        UIGraphicsBeginImageContextWithOptions(collectionSize, false, 0)
        
        let color = UIColor(red: 0x18/255,green: 0x1F/255,blue: 0x59/255,alpha: 1.0)
        color.setFill()
        UIRectFill(rect)
        bottomImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let size = CGSizeMake(topImage!.size.width, topImage!.size.height + bottomImage.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        [topImage!.drawInRect(CGRectMake(0,0,size.width, topImage!.size.height))];
        [bottomImage.drawInRect(CGRectMake(0,topImage!.size.height,size.width, bottomImage.size.height))];
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        backgroundView.backgroundColor = UIColor(patternImage: newImage);
        collectionView.backgroundColor = UIColor(patternImage: newImage);
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
        infoViewController.showInfoPopUp(self, alphaView: self.collectionView );
        infoButton.enabled = false;
    }
    
    func infoOK() {
        infoViewController.removeInfoPopUp();
        infoButton.enabled = true;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytHelper.ytImgCache.YTVideosArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
        let finalCellFrame = cell.frame;
        let translation = collectionView.panGestureRecognizer.translationInView(collectionView.superview);
        
        let video = ytHelper.ytImgCache.YTVideosArray[indexPath.row]
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        if(cellsLoaded<ytHelper.ytImgCache.YTVideosArray.count){
            if(translation.x > 0){
                cell.frame = CGRectMake(finalCellFrame.origin.x, UIScreen.mainScreen().bounds.size.height + CGFloat(indexPath.item * 75), finalCellFrame.size.width,  finalCellFrame.size.height)
            }
            else{
                cell.frame = CGRectMake(finalCellFrame.origin.x, UIScreen.mainScreen().bounds.size.height + CGFloat(indexPath.item * 75), finalCellFrame.size.width,  finalCellFrame.size.height)
            }
            
            UIView.animateWithDuration(0.8, delay: Double(indexPath.item)/10, options: .CurveEaseOut, animations: {
                cell.frame = finalCellFrame;
            }) { _ in
            }
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
        cell.titleLbl.text = video.title.uppercaseString
        cellsLoaded += 1;
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedVideoIndex = indexPath.row
        cellsLoaded = 0;
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

