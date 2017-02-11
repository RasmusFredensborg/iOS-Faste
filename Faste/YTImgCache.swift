//
//  GridDataHelper.swift
//  Faste
//
//  Created by Rasmus Fredensborg Jensen on 13/04/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit
import CoreData

class YTImgCache
{
    var YTVideosArray: Array<YTVideo> = []
    
    enum ErrorHandler:Error
    {
        case errorFetchingResults
    }
    
    func load_image(_ urlString:String, imageview:UIImageView, index:NSInteger)
    {
        
        let url:URL = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.downloadTask(with: url, completionHandler: {
            (
            location, response, error) in
            
            guard let _:URL = location, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let imageData = try? Data(contentsOf: location!)
            
            DispatchQueue.main.async(execute: {
                
                
                self.YTVideosArray[index].thumbnailImage = UIImage(data: imageData!)
                self.save(index,image: self.YTVideosArray[index].thumbnailImage!)
                
                imageview.image = self.YTVideosArray[index].thumbnailImage
                return
            })
            
            
        }) 
        
        task.resume()
        
        
    }
    
    
    
    
    func read() throws
    {
        
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            if(fetchedResults.count != YTVideosArray.count)
            {
                for i in 0 ..< fetchedResults.count
                {
                    managedContext.delete(fetchedResults[i] as! NSManagedObject)
                }
                
                return
            }
            
            for i in 0 ..< fetchedResults.count
            {
                let single_result = fetchedResults[i]
                let index = (single_result as AnyObject).value(forKey: "index") as! NSInteger
                let img: Data? = (single_result as AnyObject).value(forKey: "image") as? Data
                
                YTVideosArray[index].thumbnailImage = UIImage(data: img!)
                
            }
            
        }
        catch
        {
            print("error")
            throw ErrorHandler.errorFetchingResults
        }
        
    }
    
    func save(_ id:Int,image:UIImage)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Images",
                                                       in: managedContext)
        let options = NSManagedObject(entity: entity!,
                                      insertInto:managedContext)
        
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
