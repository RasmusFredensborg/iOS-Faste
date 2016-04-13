//
//  PersonView.swift
//  Faste
//
//  Created by Rasmus Fredensborg Jensen on 13/04/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class PersonView: UIView
{
    @IBOutlet weak var nameLabel : UILabel?
    @IBOutlet weak var descriptionLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}