//
//  ViewController.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit
import SafariServices

class GridControlleriPad: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var backgroundView: UIView!
    
    var videoIndex = 0
    
    var selectedVideoIndex: Int!
    let device = UIDevice.currentDevice().model
    let ytHelper = YTHelper()
    var cellsLoaded = 0;
    var layout = UICollectionViewFlowLayout();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)
        
        self.navigationItem.titleView = constructTitle();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridController.didBecomeReachable), name: "Reachable", object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ThumbnailCelliPad", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCelliPad")
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        ytHelper.getVideos(self);
        
        let collectionSize = CGSize(width:  UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height + (self.navigationController?.navigationBar.bounds.size.height)!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridControlleriPad.orientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        let topImage = UIImage(named: "background.png")
        var bottomImage = UIImage()
        let rect = CGRectMake(0, 0, collectionSize.width, collectionSize.height)
        UIGraphicsBeginImageContextWithOptions(collectionSize, false, 0)
        
        let color = UIColor(red: 0x18/255,green: 0x1F/255,blue: 0x59/255,alpha: 1.0)
        color.setFill();
        UIRectFill(rect);
        bottomImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        backgroundView.backgroundColor = color;
        
        let size = CGSizeMake(topImage!.size.width, topImage!.size.height + bottomImage.size.height);
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        [topImage!.drawInRect(CGRectMake(0,0,size.width, topImage!.size.height))];
        [bottomImage.drawInRect(CGRectMake(0,topImage!.size.height,size.width, bottomImage.size.height))];
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        collectionView.backgroundColor = UIColor(patternImage: newImage);
        
        let infoImage = UIImage(named: "ic_info_outline_white_2x.png");
        let imgWidth = Int(30);
        let imgHeight = Int(30);
        let infoButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight));
        infoButton.setBackgroundImage(infoImage, forState: .Normal);
        infoButton.addTarget(self, action: #selector(GridControlleriPad.infoTapped), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        self.collectionView.reloadData();
        orientation();
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
        
        cell.titleLbl.text = video.title.uppercaseString
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
        let popUpView : InfoPopup = NSBundle.mainBundle().loadNibNamed("InfoPopUp", owner: self, options: nil).first as! InfoPopup
        
        
        let alert = UIAlertController(title: "Emento", message: " ", preferredStyle: UIAlertControllerStyle.Alert)
        let urlAction = UIAlertAction(title: "Link", style: .Default) { (action:UIAlertAction!) in
            var urlString = "www.regionshospitalet-randers.dk";
            if urlString.lowercaseString.hasPrefix("http://")==false{
                urlString = "http://".stringByAppendingString(urlString)
            }
            let url = NSURL(string: urlString);
            if((NSClassFromString("SFSafariViewController")) != nil)
            {
                let safariViewController = SFSafariViewController(URL: url!);
                safariViewController.delegate = self
                self.presentViewController(safariViewController, animated: true, completion: nil)
            }
            else{
                if(UIApplication.sharedApplication().canOpenURL(url!)){
                    UIApplication.sharedApplication().openURL(url!);
                }
            }
        }
        let sample = UIViewController();
        
        let urlString = NSAttributedString(string:  "http://www.regionshospitalet-randers.dk", attributes: [NSLinkAttributeName : NSURL(string: "http://www.regionshospitalet-randers.dk")!])
        
        popUpView.text.attributedText = urlString;
        sample.view.addSubview(popUpView as! UIView);
        alert.setValue(sample, forKey: "contentViewController");
        alert.addAction(UIAlertAction(title: "Luk", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(urlAction);
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func orientation(){
        if(UIDevice.currentDevice().orientation.isLandscape){
            layout.sectionInset.left = 57;
            layout.sectionInset.right = layout.sectionInset.left;
            layout.sectionInset.top = layout.sectionInset.left;
        }
        else if(UIDevice.currentDevice().orientation.isPortrait){
            layout.sectionInset.left = 75;
            layout.sectionInset.right = layout.sectionInset.left;
            layout.sectionInset.top = layout.sectionInset.left;
        }
    }
}
//
//Om denne app:\nIndholdet af denne app (video, tekst) er udarbejdet af Regionshospitalet Randers. På hospitalets hjemmeside kan du finde yderligere informationer:www.regionshospitalet-randers.dk \nKontaktinformation\nRegionshospitalet Randers\nSkovlyvej 1\n8930 Randers NØ\nTlf: 78 42 00 00\nFax: 78 42 43 00\nLOGO\nDesign og programmering:\nEMENTO A/S\nCvr.nr 37321745\nkontakt@emento.dk
