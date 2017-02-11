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
    @IBOutlet weak var infoHeight: NSLayoutConstraint!
    @IBOutlet weak var infoWidth: NSLayoutConstraint!
    var alphaView : UIView!;
    var dialogHeight : CGFloat = 583;
    var dialogWidth : CGFloat = 355;
    @IBAction func btnOKTap(_ sender: AnyObject) {
        self.delegate?.infoOK();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showInfoPopUp(_ targetView: UIViewController, alphaView: UIView){
        self.alphaView = alphaView;
        let statusBarOffset : CGFloat;
        let navigationBarSize = (targetView.navigationController?.navigationBar.frame.size)! as CGSize;
        let statusBarSize = UIApplication.shared.statusBarFrame.size;
        
        if(!UIApplication.shared.isStatusBarHidden){
            if(statusBarSize.width < statusBarSize.height){
                statusBarOffset = navigationBarSize.width + statusBarSize.height/2;
            }
            else{
                statusBarOffset = navigationBarSize.height+statusBarSize.height/2;
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
        
        self.view.frame = CGRect(x: targetView.view.frame.origin.x, y: targetView.view.frame.origin.y, width: width, height: height);
        self.view.frame.offsetBy(dx: offsetX, dy: offsetY);
        targetView.view.addSubview(self.view);
        infoHeight.constant = dialogHeight;
        infoWidth.constant = dialogWidth;
        
        infoView.frame = CGRect(x: (width-infoView.frame.size.width)/2, y: height, width: infoView.frame.size.width, height: infoView.frame.size.height);
        if(DeviceType.IS_IPHONE_4_OR_LESS){
            infoView.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            infoWidth.constant = infoWidth.constant + 85
        }
        if(DeviceType.IS_IPHONE_5){
            infoView.transform = CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85)
        }
        self.alphaView.alpha = 1;
        UIView.beginAnimations("", context: nil);
        UIView.setAnimationDuration(animationDuration);
        UIView.setAnimationCurve(.easeOut);
        infoView.frame = CGRect(x: (width-infoView.frame.size.width)/2, y: (height-infoView.frame.size.height)/2, width: infoView.frame.size.width, height: infoView.frame.size.height);
        self.alphaView.alpha = 0;
        
        UIView.commitAnimations();
        
        hyperlink.isEditable = false;
        hyperlink.dataDetectorTypes = .link;
        email.isEditable = false;
        email.dataDetectorTypes = .link;
    }
    
    func removeInfoPopUp(){
        UIView.beginAnimations("", context: nil);
        UIView.setAnimationDuration(animationDuration);
        UIView.setAnimationCurve(.easeIn);
        infoView.frame = CGRect(x: (self.view.frame.size.width-infoView.frame.size.width)/2, y: -self.view.frame.size.height, width: infoView.frame.size.width, height: infoView.frame.size.height);
        alphaView.alpha = 1;
        UIView.commitAnimations();
        self.view.perform(#selector(self.view.removeFromSuperview), with: nil, afterDelay: animationDuration);
        
    }
    
    func removeInfoPopUpInstantly(){
        self.view.removeFromSuperview();
    }
}

protocol InfoPopUpViewControllerDelegate : class{
    func infoOK();
}
