//
//  ManlDetailResult.swift
//  Muslim
//
//  Created by 颜超 on 15/11/8.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ManlDetailResult: NSObject {
    var place : NSArray?
    var count : NSNumber?
    var start : NSNumber?
    var total : NSNumber?
    
    func initValues(dictionary : NSDictionary) {
        if (dictionary["place"] != nil) {
            place = dictionary["place"] as? NSArray
        }
        if (dictionary["count"] != nil) {
            count = dictionary["count"] as? NSNumber
        }
        if (dictionary["start"] != nil) {
            start = dictionary["start"] as? NSNumber
        }
        if (dictionary["total"] != nil) {
            total = dictionary["total"] as? NSNumber
        }
    }
}
