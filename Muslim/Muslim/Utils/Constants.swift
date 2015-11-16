//
//  Constants.swift
//  Muslim
//
//  Created by 颜超 on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let APIKey = "84cb993da727c58b8ce7911e7678e9ae"
    
    static let ADJUSTTIME : Int = 60; //默认时间调整
    
    static let downloadBaseUri = "http://www.csufo.com:8001/Public/res/quran/" //base下载地址
    static let downloadTranslationUri = downloadBaseUri + "translation/" //译文下载地址
}
