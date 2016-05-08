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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)

        self.navigationItem.titleView = constructTitle(YTVideosArray[videoIndex].title.uppercaseString)
        self.playerView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoController.orientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
        updateView();
        
        playerView.loadWithVideoId(YTVideosArray[videoIndex].ID, playerVars: playerVars)
        playerHeight.constant = UIScreen.mainScreen().bounds.width * (9/16)
//        descriptionView.bringSubviewToFront(profile)
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

        personView.layer.rasterizationScale = UIScreen.mainScreen().scale;
        personView.layer.shouldRasterize = true
        personView.layer.shadowColor = UIColor.grayColor().CGColor;
        personView.layer.shadowOffset = CGSizeMake(0, 2.0);
        personView.layer.shadowRadius = 3.0;
        personView.layer.shadowOpacity = 0.25;
        personView.layer.masksToBounds = false;
    }
    
    func constructTitle(title: String) -> UIView
    {
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
        titleLabel.text = title.uppercaseString
        if(UIDevice.currentDevice().model=="iPad")
        {
            titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 24)
        }
        else
        {
            titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 12)
        }
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit();
        titleLabel.textAlignment = NSTextAlignment.Center
  
        let titleView = UIView(frame: CGRectMake(0, 0, titleLabel.frame.size.width, titleLabel.frame.size.height));
        titleView.addSubview(titleLabel)
        return titleView;
    }
    
    func updateView(){
        let video = YTVideosArray[videoIndex];
        descriptionView.descriptionLabel?.text = video.description;
        self.navigationItem.titleView = constructTitle(video.title.uppercaseString)
        personView.viewsLabel?.text = String(video.viewCount);
        personView.nameLabel?.text = "Jannie Falk Bjerregaard"
        personView.descriptionLabel?.text = "Narkose-sygeplejerske, Regionshospitalet Randers"
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
        playerHeight.constant = UIScreen.mainScreen().bounds.width * (9/16)

    }
}

