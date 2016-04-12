//
//  DescriptionView.swift
//  Faste
//
//  Created by Rasmus Fredensborg Jensen on 12/04/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class DescriptionView: UIView
{
    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var descriptionLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
