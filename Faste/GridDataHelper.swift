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
    
    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }
    
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        
        let url:NSURL = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(url) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let imageData = NSData(contentsOfURL: location!)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
                self.YTVideosArray[index].thumbnailImage = UIImage(data: imageData!)
                self.save(index,image: self.YTVideosArray[index].thumbnailImage!)
                
                imageview.image = self.YTVideosArray[index].thumbnailImage
                return
            })
            
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    func read() throws
    {
        
        do
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "Images")
            
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
            
            for i in 0 ..< fetchedResults.count
            {
                let single_result = fetchedResults[i]
                let index = single_result.valueForKey("index") as! NSInteger
                let img: NSData? = single_result.valueForKey("image") as? NSData
                
                YTVideosArray[index].thumbnailImage = UIImage(data: img!)
                
            }
            
        }
        catch
        {
            print("error")
            throw ErrorHandler.ErrorFetchingResults
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
        
        do {
            try managedContext.save()
        } catch
        {
            print("error")
        }
        
    }
}
