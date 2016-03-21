
//
//  CustomLayout.swift
//  Faste
//
//  Created by Emento on 09/03/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    var numberOfItemsPerRow: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }

    override func prepareLayout() {
        super.prepareLayout()
        
        if let collectionView = self.collectionView {
            var device = UIDevice.currentDevice().model
            
            if(device == "iPad"){
                sectionInset.left = (UIScreen.mainScreen().bounds.width)/15
                sectionInset.right = sectionInset.left
                sectionInset.top = sectionInset.left/4
                minimumInteritemSpacing = 10
                minimumLineSpacing = 10
            }
            
            var newItemSize = itemSize
            collectionView.backgroundColor = UIColor(red: 0xfa/255,green: 0xfa/255,blue: 0xfa/255,alpha: 1.0)
            // Always use an item count of at least 1 and convert it to a float to use in size calculations
            let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
            
            // Calculate the sum of the spacing between cells
            let totalSpacing = minimumInteritemSpacing * (itemsPerRow - 1.0)
            
            // Calculate how wide items should be
            newItemSize.width = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / itemsPerRow
            // Use the aspect ratio of the current item size to determine how tall the items should be
            if itemSize.height > 0 {
                let itemAspectRatio = itemSize.width / itemSize.height
                newItemSize.height = newItemSize.width / itemAspectRatio
            }
            // Set the new item size
            itemSize = newItemSize
        }
    }
    
}