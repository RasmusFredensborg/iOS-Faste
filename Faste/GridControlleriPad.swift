//
//  ViewController.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class GridControlleriPad: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var backgroundView: UIView!
    
    var videoIndex = 0
    
    var selectedVideoIndex: Int!
    let device = UIDevice.currentDevice().model
    let ytHelper = YTHelper()
    var cellsLoaded = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)
        
        self.navigationItem.titleView = constructTitle();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.didBecomeReachable), name: "Reachable", object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ThumbnailCelliPad", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCelliPad")
        
        ytHelper.getVideos(self);
        
        
        
        
        
        let collectionSize = CGSize(width:  UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height + (self.navigationController?.navigationBar.bounds.size.height)!)
        
        let topImage = UIImage(named: "background.png")
        var bottomImage = UIImage()
        let rect = CGRectMake(0, 0, collectionSize.width, collectionSize.height)
        UIGraphicsBeginImageContextWithOptions(collectionSize, false, 0)
        
        let color = UIColor(red: 0x18/255,green: 0x1F/255,blue: 0x59/255,alpha: 1.0)
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
        
        collectionView.backgroundColor = UIColor(patternImage: newImage)
        
        let infoImage = UIImage(named: "ic_info_outline_white_2x.png")
        let imgWidth = Int(30)
        let imgHeight = Int(30)
        let infoButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        infoButton.setBackgroundImage(infoImage, forState: .Normal)
        infoButton.addTarget(self, action: #selector(GridControlleriPad.infoTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        if(collectionView.numberOfItemsInSection(0) > 0)
        {
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
            
            backgroundView.backgroundColor = color;
            
            let size = CGSizeMake(topImage!.size.width, topImage!.size.height + bottomImage.size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            [topImage!.drawInRect(CGRectMake(0,0,size.width, topImage!.size.height))];
            [bottomImage.drawInRect(CGRectMake(0,topImage!.size.height,size.width, bottomImage.size.height))];
            
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            collectionView.backgroundColor = UIColor(patternImage: newImage)
        }
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytHelper.ytImgCache.YTVideosArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCelliPad", forIndexPath: indexPath) as! ThumbnailCell
        
        let finalCellFrame = cell.frame;
        let translation = collectionView.panGestureRecognizer.translationInView(collectionView.superview);
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        let video = ytHelper.ytImgCache.YTVideosArray[indexPath.row]
        cell.titleLbl.text = video.title.uppercaseString
        
        if(cellsLoaded<ytHelper.ytImgCache.YTVideosArray.count){
            if(translation.x > 0){
                cell.frame = CGRectMake(finalCellFrame.origin.x, UIScreen.mainScreen().bounds.size.height + CGFloat(indexPath.item * 75), finalCellFrame.size.width,  finalCellFrame.size.height)
            }
            else{
                cell.frame = CGRectMake(finalCellFrame.origin.x, UIScreen.mainScreen().bounds.size.height + CGFloat(indexPath.item * 75), finalCellFrame.size.width,  finalCellFrame.size.height)
            }
            UIView.animateWithDuration(0.8+Double(indexPath.item)/10) {
                
                cell.frame = finalCellFrame;
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
    
    func infoTapped(){
        let alert = UIAlertController(title: "Emento", message: "Contact: developer@emento.dk", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

