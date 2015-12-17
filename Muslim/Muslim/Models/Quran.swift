//
//  Quran.swift
//  Muslim
//
//  Created by LSD on 15/11/19.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class Quran: NSObject {
    var sura:Int?
    var aya:Int?
    var text:String?
    var text_zh:String?
    var progress:Int?
    var isbookmark:Bool?
    var unSelectedHeight : CGFloat = 0
    var selectedHeight : CGFloat = 0
    var hasCalulateHeight = false
    var alignmentToRight = Config.getTextShouldToRight()
    
    /**** 界面需要的额外参数**/
    //选中 - 需要变换高度
    var isSelected :Bool?
    //音频状态
    var audioStatus :Int = 0  //0:未播放 ， 1：播放中 -1：下载中
}
