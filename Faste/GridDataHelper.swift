//
//  GridDataHelper.swift
//  Faste
//
//  Created by Rasmus Fredensborg Jensen on 13/04/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit
import CoreData

class GridDataHelper
{
    var YTVideosArray: Array<YTVideo> = []
    
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        
        var imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.YTVideosArray[index].thumbnailImage = UIImage(data: data!)
                    self.save(index,image: self.YTVideosArray[index].thumbnailImage!)
                    
                    imageview.image = self.YTVideosArray[index].thumbnailImage
                }
        })
        
    }
    
    
    
    
    func read()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Images")
        
        var error: NSError?
        do{
            
            let fetchedResults = try managedContext!.executeFetchRequest(fetchRequest)
                as [AnyObject]?
            
            if let results = fetchedResults
            {
                for i in 0 ..< results.count
                {
                    let single_result = results[i]
                    let index = single_result.valueForKey("index") as! NSInteger
                    let img: NSData? = single_result.valueForKey("image") as? NSData
                    
                    YTVideosArray[index].thumbnailImage = UIImage(data: img!)
                    
                }
            }
        }
        catch _{
            
        }
    }
    
    func save(id:Int,image:UIImage)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Images",
                                                       inManagedObjectContext: managedContext)
        let options = NSManagedObject(entity: entity!,
                                      insertIntoManagedObjectContext:managedContext)
        
        let newImageData = UIImageJPEGRepresentation(image,1)
        
        options.setValue(id, forKey: "index")
        options.setValue(newImageData, forKey: "image")
        
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
    }
}
