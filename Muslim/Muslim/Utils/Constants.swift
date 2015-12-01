//
//  Constants.swift
//  Muslim
//
//  Created by 颜超 on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let ADJUSTTIME : Int = 60; //默认时间调整
    static let downloadBaseUri = "http://www.csufo.com:8001/Public/res/quran/" //base下载地址
    static let downloadTranslationUri = downloadBaseUri + "translation/" //译文下载地址
    static let downloadSoundUri = downloadBaseUri + "adhan/" //响礼闹钟音乐下载地址
    
    static let basePath = FileUtils.documentsDirectory() //document路径
    static let audioPath = "audio" //播放音频文件夹
    static let alarmPath = "alarm" //响里闹钟文件夹
    static let quranPath = "quran" //古兰经译文文件夹
}
