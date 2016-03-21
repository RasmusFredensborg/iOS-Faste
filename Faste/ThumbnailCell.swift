//
//  ViewCell.swift
//  Faste
//
//  Created by Emento on 24/02/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var viewLbl: UILabel!
    @IBOutlet var thumbnailImg: UIImageView!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var thumbWidth: NSLayoutConstraint!
    @IBOutlet weak var thumbHeight: NSLayoutConstraint!
}
