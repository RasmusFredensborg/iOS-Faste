//
//  YTVideo.swift
//  Faste
//
//  Created by Emento on 15/03/16.
//  Copyright © 2016 Emento. All rights reserved.
//

import UIKit

class YTVideo {
    var title : String
    var ID : String
    var description : String
    var viewCount : Int
    var duration : String
    var thumbnail : String
    var thumbnailWidth : Int
    var thumbnailHeight : Int
    var likeCount : String
    var playlist : Array<String>
    init(){
        self.title = ""
        self.ID = ""
        self.description = ""
        self.viewCount = 0
        self.duration = ""
        self.thumbnail = ""
        self.thumbnailWidth = 0
        self.thumbnailHeight = 0
        self.likeCount = ""
        self.playlist = []
    }
}
