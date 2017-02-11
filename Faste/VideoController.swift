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
        self.navigationController!.navigationBar.tintColor = UIColor.white;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)

        self.navigationItem.titleView = constructTitle(YTVideosArray[videoIndex].title.uppercased())
        self.playerView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoController.orientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        updateView();
        
        playerView.load(withVideoId: YTVideosArray[videoIndex].ID, playerVars: playerVars)
        playerHeight.constant = UIScreen.main.bounds.width * (9/16)
//        descriptionView.bringSubviewToFront(profile)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orientation()
    }
    
    func constructTitle(_ title: String) -> UIView
    {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.text = title.uppercased()
        if(UIDevice.current.model=="iPad")
        {
            titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 24)
        }
        else
        {
            titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 12)
        }
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit();
        titleLabel.textAlignment = NSTextAlignment.center
  
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.size.width, height: titleLabel.frame.size.height));
        titleView.addSubview(titleLabel)
        return titleView;
    }
    
    func updateView(){
        let video = YTVideosArray[videoIndex];
        descriptionView.descriptionLabel?.text = video.description;
        self.navigationItem.titleView = constructTitle(video.title.uppercased())
        personView.viewsLabel?.text = String(video.viewCount);
        personView.nameLabel?.text = "Jannie Falk Bjerregaard"
        personView.descriptionLabel?.text = "Narkose-sygeplejerske, Regionshospitalet Randers"
    }
    
    @IBAction func nextVideoPressed(_ sender: AnyObject) {
        if(videoIndex < YTVideosArray.count-1){
            videoIndex+=1;
            self.playerView.load(withVideoId: YTVideosArray[videoIndex].ID, playerVars: playerVars)
            updateView()
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView!) {
        playerView.playVideo()
        
    }
    
    func playerView(_ playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        print("Error")
    }
    
    func orientation(){
        if(UIDevice.current.orientation.isLandscape){
            if(UIDevice.current.model == "iPhone"){
                self.navigationController?.isNavigationBarHidden = true;
            }
            playerHeight.constant = UIScreen.main.bounds.width * (9/16)
        }
        else if(UIDevice.current.orientation.isPortrait){
            self.navigationController?.isNavigationBarHidden = false;
            playerHeight.constant = UIScreen.main.bounds.width * (9/16)
        }
    }
}

