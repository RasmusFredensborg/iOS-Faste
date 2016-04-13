//
//  VideoController.swift
//  Faste
//
//  Created by Emento on 29/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class VideoController: UIViewController, YTPlayerViewDelegate{
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playerHeight: NSLayoutConstraint!
    let playerVars = ["playsinline" : 1, "controls" : 1, "autohide" : 0, "showinfo" : 0, "autoplay" : 1, "fs" : 1, "rel" : 0, "modestbranding" : 1, "enablejsapi" : 1]
    var YTVideosArray : Array<YTVideo> = []
    var videoIndex = 0;
    
    @IBOutlet weak var descriptionView: DescriptionView!
    @IBOutlet weak var personView: PersonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        UINavigationBar.appearance().translucent = true
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.barTintColor = UIColor.darkGrayColor();
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        
        self.playerView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoController.orientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
        updateView();
        
        playerView.loadWithVideoId(YTVideosArray[videoIndex].ID, playerVars: playerVars)
        
        playerHeight.constant = UIScreen.mainScreen().bounds.width * (9/16)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        orientation()
    }
    
    override func viewDidLayoutSubviews() {
        descriptionView.layer.shadowColor = UIColor.grayColor().CGColor;
        descriptionView.layer.shadowOffset = CGSizeMake(0, 2.0);
        descriptionView.layer.shadowRadius = 3.0;
        descriptionView.layer.shadowOpacity = 0.25;
        descriptionView.layer.masksToBounds = false;
        descriptionView.layer.shadowPath = UIBezierPath(roundedRect:descriptionView.bounds, cornerRadius: 0).CGPath;
        
        personView.layer.shadowColor = UIColor.grayColor().CGColor;
        personView.layer.shadowOffset = CGSizeMake(0, 2.0);
        personView.layer.shadowRadius = 3.0;
        personView.layer.shadowOpacity = 0.25;
        personView.layer.masksToBounds = false;
        personView.layer.shadowPath = UIBezierPath(roundedRect:personView.bounds, cornerRadius: 0).CGPath;
    }
    
    func updateView(){
        let video = YTVideosArray[videoIndex];
        descriptionView.descriptionLabel?.text = video.description
        descriptionView.titleLabel?.text = video.title
        descriptionView.viewLabel?.text = String(video.viewCount);
        personView.nameLabel?.text = "Jannie"
        personView.descriptionLabel?.text = "Sygeplejerske"
    }
    
    @IBAction func nextVideoPressed(sender: AnyObject) {
        if(videoIndex < YTVideosArray.count-1){
            videoIndex+=1;
            self.playerView.loadWithVideoId(YTVideosArray[videoIndex].ID, playerVars: playerVars)
            updateView()
        }
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        playerView.playVideo()
        
    }
    
    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        print("Error")
    }
    
    func orientation(){
        if(UIDevice.currentDevice().orientation.isLandscape){
            playerHeight.constant = UIScreen.mainScreen().bounds.height  - (self.navigationController?.navigationBar.bounds.height)!
        }
        else if(UIDevice.currentDevice().orientation.isPortrait){
            playerHeight.constant = UIScreen.mainScreen().bounds.width * (9/16)
        }
    }

    
//    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        
//        let device = UIDevice.currentDevice()
//        
//        if(device.model == "iPad"){
//            layout.minimumLineSpacing = 20
//        }
//        if(device.orientation.isLandscape){
//            playerHeight.constant = UIScreen.mainScreen().bounds.height
//        }
//        var newItemSize = layout.itemSize
//        let numberOfItemsPerRow = 1
//        collectionView.backgroundColor = UIColor(red: 0xfa/255,green: 0xfa/255,blue: 0xfa/255,alpha: 1.0)
//        // Always use an item count of at least 1 and convert it to a float to use in size calculations
//        let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
//        
//        // Calculate the sum of the spacing between cells
//        let totalSpacing = layout.minimumInteritemSpacing * (itemsPerRow - 1.0)
//        
//        // Calculate how wide items should be
//        newItemSize.width = (collectionView.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right - totalSpacing) / itemsPerRow
//        // Use the aspect ratio of the current item size to determine how tall the items should be
//        if(indexPath.row==1){
//            newItemSize.height = 75
//        }
//        // Set the new item size
//        //layout.itemSize = newItemSize
//        return newItemSize
//        
//        
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        
//        if(indexPath.row==0){
//            let cell: DescriptionCell = collectionView.dequeueReusableCellWithReuseIdentifier("DescriptionCell", forIndexPath: indexPath) as! DescriptionCell
//            let video = YTVideosArray[videoIndex]
//            cell.nextVideo.addTarget(self, action: #selector(VideoController.nextVideoClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            cell.title.text = video.title
//            cell.videoDescription.text = video.description
//            cell.viewCount.text = String(video.viewCount)
//            
//            cell.layer.shadowColor = UIColor.grayColor().CGColor;
//            cell.layer.shadowOffset = CGSizeMake(0, 2.0);
//            cell.layer.shadowRadius = 3.0;
//            cell.layer.shadowOpacity = 0.25;
//            cell.layer.masksToBounds = false;
//            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).CGPath;
//            return cell;
//        }
//        else{
//            let cell: PersonCell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
//            
//            cell.layer.shadowColor = UIColor.grayColor().CGColor;
//            cell.layer.shadowOffset = CGSizeMake(0, 2.0);
//            cell.layer.shadowRadius = 3.0;
//            cell.layer.shadowOpacity = 0.25;
//            cell.layer.masksToBounds = false;
//            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).CGPath;
//            cell.nameLbl.text = "Jannie Falk Bjerregaard"
//            cell.descriptionLbl.text = "Sygeplejerske"
//            return cell
//        }
//        
//    }
}

