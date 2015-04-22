//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by JD Guzman on 4/17/15.
//  Copyright (c) 2015 JD Guzman. All rights reserved.
//

import Foundation

class AudioMeta: NSObject {
    
    var title: String!
    var path: NSURL!
    
    init(fileTitle: String, filePath: NSURL) {
        self.title = fileTitle
        self.path = filePath
        super.init()
    }
   
}
