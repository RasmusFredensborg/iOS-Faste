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
    let playerVars = ["playsinline" : 1, "controls" : 1, "autohide" : 0, "showinfo" : 0, "autoplay" : 1, "fs" : 1, "rel" : 0, "modestbranding" : 1, "enablejsapi" : 1]
    var YTVideosArray : Array<YTVideo> = []
    var videoIndex = 0;
    
    @IBOutlet weak var descriptionView: DescriptionView!
    @IBOutlet weak var personView: PersonView!
    @IBOutlet weak var relatedView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var playerHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        UINavigationBar.appearance().translucent = true
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.barTintColor = UIColor.darkGrayColor();
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        let font = UIFont(name: "Roboto-Regular", size: 18)
        if let font = font {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
            
        }
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
        descriptionView.layer.rasterizationScale = UIScreen.mainScreen().scale;
        descriptionView.layer.shouldRasterize = true
        descriptionView.layer.shadowColor = UIColor.grayColor().CGColor;
        descriptionView.layer.shadowOffset = CGSizeMake(0, 2.0);
        descriptionView.layer.shadowRadius = 3.0;
        descriptionView.layer.shadowOpacity = 0.25;
        descriptionView.layer.masksToBounds = false;
//        descriptionView.layer.shadowPath = UIBezierPath(roundedRect:descriptionView.bounds, cornerRadius: 0).CGPath;

        personView.layer.rasterizationScale = UIScreen.mainScreen().scale;
        personView.layer.shouldRasterize = true
        personView.layer.shadowColor = UIColor.grayColor().CGColor;
        personView.layer.shadowOffset = CGSizeMake(0, 2.0);
        personView.layer.shadowRadius = 3.0;
        personView.layer.shadowOpacity = 0.25;
        personView.layer.masksToBounds = false;
//        personView.layer.shadowPath = UIBezierPath(roundedRect:personView.bounds, cornerRadius: 0).CGPath;
        
        relatedView.layer.rasterizationScale = UIScreen.mainScreen().scale;
        relatedView.layer.shouldRasterize = true
        relatedView.layer.shadowColor = UIColor.grayColor().CGColor;
        relatedView.layer.shadowOffset = CGSizeMake(0, 2.0);
        relatedView.layer.shadowRadius = 3.0;
        relatedView.layer.shadowOpacity = 0.25;
        relatedView.layer.masksToBounds = false;
//        relatedView.layer.shadowPath = UIBezierPath(roundedRect:relatedView.bounds, cornerRadius: 0).CGPath;
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
            self.scrollView.scrollEnabled = false
        }
        else if(UIDevice.currentDevice().orientation.isPortrait){
            playerHeight.constant = UIScreen.mainScreen().bounds.width * (9/16)
            self.scrollView.scrollEnabled = true
        }
    }
}

