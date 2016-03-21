//
//  DescriptionLayout.swift
//  Faste
//
//  Created by Emento on 15/03/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class DescriptionLayout: UICollectionViewFlowLayout {
    
    var numberOfItemsPerRow: Int = 1 {
        didSet {
            invalidateLayout()
        }
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        if let collectionView = self.collectionView {
            var device = UIDevice.currentDevice().model
            
            if(device == "iPad"){
                minimumLineSpacing = 20
            }
            
            var newItemSize = itemSize
            collectionView.backgroundColor = UIColor(red: 0xf8/255,green: 0xf8/255,blue: 0xf8/255,alpha: 1.0)
            // Always use an item count of at least 1 and convert it to a float to use in size calculations
            let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
            
            // Calculate the sum of the spacing between cells
            let totalSpacing = minimumInteritemSpacing * (itemsPerRow - 1.0)
            
            // Calculate how wide items should be
            newItemSize.width = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / itemsPerRow
            
            // Set the new item size
            itemSize = newItemSize
        }
    }
    
}