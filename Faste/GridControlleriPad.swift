//
//  ViewController.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit
import SafariServices
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GridControlleriPad: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate, InfoPopUpViewControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var backgroundView: UIView!
    
    var videoIndex = 0
    
    var selectedVideoIndex: Int!
    let device = UIDevice.current.model
    let ytHelper = YTHelper()
    var cellsLoaded = 0;
    var layout = UICollectionViewFlowLayout();
    var infoViewController = InfoPopUpViewController();
    var infoButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoViewController.delegate = self;
        infoViewController.loadView();
        self.navigationController!.navigationBar.isTranslucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xfb/255,green: 0xbc/255,blue: 0x00/255,alpha: 1.0)
        
        self.navigationItem.titleView = constructTitle();
        NotificationCenter.default.addObserver(self, selector: #selector(GridController.didBecomeReachable), name: NSNotification.Name(rawValue: "Reachable"), object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ThumbnailCelliPad", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCelliPad")
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        ytHelper.getVideos(self);
        
        let collectionSize = CGSize(width:  UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + (self.navigationController?.navigationBar.bounds.size.height)!)
        NotificationCenter.default.addObserver(self, selector: #selector(GridControlleriPad.orientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let topImage = UIImage(named: "background.png")
        var bottomImage = UIImage()
        let rect = CGRect(x: 0, y: 0, width: collectionSize.width, height: collectionSize.height)
        UIGraphicsBeginImageContextWithOptions(collectionSize, false, 0)
        
        let color = UIColor(red: 0x18/255,green: 0x1F/255,blue: 0x59/255,alpha: 1.0)
        color.setFill();
        UIRectFill(rect);
        bottomImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        backgroundView.backgroundColor = color;
        
        let size = CGSize(width: topImage!.size.width, height: topImage!.size.height + bottomImage.size.height);
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        [topImage!.draw(in: CGRect(x: 0,y: 0,width: size.width, height: topImage!.size.height))];
        [bottomImage.draw(in: CGRect(x: 0,y: topImage!.size.height,width: size.width, height: bottomImage.size.height))];
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        collectionView.backgroundColor = UIColor(patternImage: newImage);
        
        let infoImage = UIImage(named: "ic_info_outline_white_2x.png");
        let imgWidth = Int(30);
        let imgHeight = Int(30);
        infoButton = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight));
        infoButton.setBackgroundImage(infoImage, for: UIControlState());
        infoButton.addTarget(self, action: #selector(GridControlleriPad.infoTapped), for: UIControlEvents.touchUpInside);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    func infoOK() {
        infoViewController.removeInfoPopUp();
        infoButton.isEnabled = true;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.collectionView.reloadData();
        orientation();
    }
    
    override func viewDidLayoutSubviews() {
        if(collectionView.numberOfItems(inSection: 0) > 0)
        {
            let collectionSize = collectionView.collectionViewLayout.collectionViewContentSize
            
            let topImage = UIImage(named: "background.png")
            var bottomImage = UIImage()
            let rect = CGRect(x: 0, y: 0, width: collectionSize.width, height: collectionSize.height)
            UIGraphicsBeginImageContextWithOptions(collectionSize, false, 0)
            
            let color = UIColor(red: 0x18/255,green: 0x1F/255,blue: 0x59/255,alpha: 1.0)
            color.setFill()
            UIRectFill(rect)
            bottomImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            
            
            let size = CGSize(width: topImage!.size.width, height: topImage!.size.height + bottomImage.size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            [topImage!.draw(in: CGRect(x: 0,y: 0,width: size.width, height: topImage!.size.height))];
            [bottomImage.draw(in: CGRect(x: 0,y: topImage!.size.height,width: size.width, height: bottomImage.size.height))];
            
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            backgroundView.backgroundColor = UIColor(patternImage: newImage)
            collectionView.backgroundColor = UIColor(patternImage: newImage)
        }
    }
    
    @objc func didBecomeReachable(_ note: Notification){
        if(ytHelper.ytImgCache.YTVideosArray.count == 0)
        {
            self.ytHelper.getVideos(self)
        }
    }
    
    func constructTitle() -> UIView
    {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.text = "FASTE"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 24)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit();
        titleLabel.textAlignment = NSTextAlignment.center
        
        let titleLabel2 = UILabel(frame: CGRect(x: titleLabel.frame.size.width, y: 0, width: 0, height: 0))
        titleLabel2.text = "regler"
        titleLabel2.font = UIFont(name: "AvenirNext-Medium", size: 24)
        titleLabel2.textColor = UIColor.white
        titleLabel2.sizeToFit();
        titleLabel2.textAlignment = NSTextAlignment.center
        let twoSegmentTitleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.size.width+titleLabel2.frame.size.width, height: titleLabel.frame.size.height));
        twoSegmentTitleView.addSubview(titleLabel)
        twoSegmentTitleView.addSubview(titleLabel2)
        return twoSegmentTitleView;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytHelper.ytImgCache.YTVideosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCelliPad", for: indexPath) as! ThumbnailCell
        
        let finalCellFrame = cell.frame;
        let translation = collectionView.panGestureRecognizer.translation(in: collectionView.superview);
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        let video = ytHelper.ytImgCache.YTVideosArray[indexPath.row]
        
        if(cellsLoaded<ytHelper.ytImgCache.YTVideosArray.count){
            if(translation.x > 0){
                cell.frame = CGRect(x: finalCellFrame.origin.x, y: UIScreen.main.bounds.size.height + CGFloat(indexPath.item * 75), width: finalCellFrame.size.width,  height: finalCellFrame.size.height)
            }
            else{
                cell.frame = CGRect(x: finalCellFrame.origin.x, y: UIScreen.main.bounds.size.height + CGFloat(indexPath.item * 75), width: finalCellFrame.size.width,  height: finalCellFrame.size.height)
            }
            
            UIView.animate(withDuration: 0.8, delay: Double(indexPath.item)/10, options: .curveEaseOut, animations: {
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
        
        cell.titleLbl.text = video.title.uppercased()
        cell.viewLbl.text = String(video.viewCount)
        cell.durationLbl.text = video.duration
        
        cellsLoaded += 1;
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedVideoIndex = indexPath.row
        cellsLoaded = 0;
        performSegue(withIdentifier: "idSeguePlayer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "idSeguePlayer" {
            let playerViewController = segue.destination as! VideoController
            playerViewController.YTVideosArray = ytHelper.ytImgCache.YTVideosArray
            playerViewController.videoIndex = selectedVideoIndex
        }
        
    }
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath:IndexPath?
        
        if collectionView.indexPathsForSelectedItems?.count > 0{
            indexPath = collectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
    func do_grid_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
            return
        })
    }
    
    func infoTapped(){
        infoViewController.showInfoPopUp(self, alphaView: self.collectionView);
        infoButton.isEnabled = false;
    }
    
    func orientation(){
        if(UIDevice.current.orientation.isLandscape){
            layout.sectionInset.left = 57;
            layout.sectionInset.right = layout.sectionInset.left;
            layout.sectionInset.top = layout.sectionInset.left;
        }
        else if(UIDevice.current.orientation.isPortrait){
            layout.sectionInset.left = 75;
            layout.sectionInset.right = layout.sectionInset.left;
            layout.sectionInset.top = layout.sectionInset.left;
        }
    }
}

