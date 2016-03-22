
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
            let device = UIDevice.currentDevice();
            let model = device.model;
            if(model == "iPad"){
                sectionInset.left = (UIScreen.mainScreen().bounds.width)/12
                sectionInset.right = sectionInset.left
                sectionInset.top = 10
                minimumInteritemSpacing = 10
                minimumLineSpacing = 10
            }
            else{
                sectionInset.left = 5
                sectionInset.right = sectionInset.left
                sectionInset.top = 5
                minimumInteritemSpacing = 5
                minimumLineSpacing = 5
            }
            
            var newItemSize = itemSize
            collectionView.backgroundColor = UIColor(red: 0xfa/255,green: 0xfa/255,blue: 0xfa/255,alpha: 1.0)
            // Always use an item count of at least 1 and convert it to a float to use in size calculations

            
            if(UIDevice.currentDevice().orientation.isLandscape){
                numberOfItemsPerRow = 3;
                let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
                let totalSpacing = minimumInteritemSpacing * (itemsPerRow - 1.0)
                sectionInset.left = -((itemsPerRow*(newItemSize.width+(totalSpacing-UIScreen.mainScreen().bounds.width)/itemsPerRow)))/2
                sectionInset.right = sectionInset.left
            }
            
            if(UIDevice.currentDevice().orientation.isPortrait){
                numberOfItemsPerRow = 2;
                let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
                let totalSpacing = minimumInteritemSpacing * (itemsPerRow - 1.0)
                newItemSize.width = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / itemsPerRow
            }
            
            itemSize = newItemSize
        }
    }
    
}