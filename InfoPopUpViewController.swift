//
//  InfoPopUpViewController.swift
//  Fasteregler
//
//  Created by Rasmus Fredensborg Jensen on 24/05/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class InfoPopUpViewController: UIViewController {
    let animationDuration : Double = 0.5;
    @IBOutlet weak var infoView: UIView!;    
    @IBOutlet weak var hyperlink: UITextView!
    @IBOutlet weak var email: UITextView!    
    @IBOutlet weak var btnOK: UIButton!;
    weak var delegate : InfoPopUpViewControllerDelegate?;
    
    @IBAction func btnOKTap(sender: AnyObject) {
        self.delegate?.infoOK();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InfoPopUpViewController.orientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.75);
        // Dispose of any resources that can be recreated.
    }
    
    func showInfoPopUp(targetView: UIViewController, message: NSString){
        let statusBarOffset : CGFloat;
        if(!UIApplication.sharedApplication().statusBarHidden){
            
            let navigationBarSize = (targetView.navigationController?.navigationBar.frame.size)! as CGSize;
            let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size;
            
            if(statusBarSize.width < statusBarSize.height){
                statusBarOffset = statusBarSize.width + navigationBarSize.width;
            }
            else{
                statusBarOffset = statusBarSize.height + navigationBarSize.height;
            }
        }
        else{
            statusBarOffset = 0;
        }
        
        var width, height, offsetX, offsetY : CGFloat;
        width = targetView.view.frame.size.width;
        height = targetView.view.frame.size.height;
        
        offsetX = 0;
        offsetY = -statusBarOffset;
        
        self.view.frame = CGRectMake(targetView.view.frame.origin.x, targetView.view.frame.origin.y, width, height);
        self.view.frame.offsetInPlace(dx: offsetX, dy: offsetY);
        targetView.view.addSubview(self.view);
        
        infoView.frame = CGRectMake((width-infoView.frame.size.width)/2, self.view.frame.size.height, infoView.frame.size.width, infoView.frame.size.height);
//        infoView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2)
        
        UIView.beginAnimations("", context: nil);
        UIView.setAnimationDuration(animationDuration);
        UIView.setAnimationCurve(.EaseOut);
        infoView.frame = CGRectMake((width-infoView.frame.size.width)/2, (height-infoView.frame.size.height)/2, infoView.frame.size.width, infoView.frame.size.height);
        
        
        UIView.commitAnimations();
        
        hyperlink.editable = false;
        hyperlink.dataDetectorTypes = .Link;
        email.editable = false;
        email.dataDetectorTypes = .Link;
    }
    
    func removeInfoPopUp(){
        UIView.beginAnimations("", context: nil);
        UIView.setAnimationDuration(animationDuration);
        UIView.setAnimationCurve(.EaseOut);
        infoView.frame = CGRectMake((self.view.frame.size.width-infoView.frame.size.width)/2, -infoView.frame.size.height, infoView.frame.size.width, infoView.frame.size.height);
        UIView.commitAnimations();
        self.view.performSelector(#selector(self.view.removeFromSuperview), withObject: nil, afterDelay: animationDuration);
        
    }
    
    func removeInfoPopUpInstantly(){
        self.view.removeFromSuperview();
    }
    
    func orientation(){
        infoView.frame = CGRectMake((self.view.frame.size.width-infoView.frame.size.width)/2, (self.view.frame.size.height-infoView.frame.size.height)/2, infoView.frame.size.width, infoView.frame.size.height);
    }
}

protocol InfoPopUpViewControllerDelegate : class{
    func infoOK();
}
