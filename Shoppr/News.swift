//
//  News.swift
//  Shoppr
//
//  Created by Mohd Adam on 18/08/2017.
//  Copyright © 2017 Mohd Adam. All rights reserved.
//

import Foundation

class News {
    
    var urlToImage: String?
    
    init?(dictionary: [String:Any], source: String? = nil) {
        self.urlToImage = dictionary["urlToImage"] as? String  ?? "N/A"
    }
    
}
