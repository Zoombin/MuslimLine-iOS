//
//  AudioPlayerMr.swift
//  Muslim

//  播放音乐

//  Created by LSD on 15/11/22.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class AudioPlayerMr: NSObject {
    var dataArray : NSMutableArray?
    var position:Int?
    var sura:Int?
    
    //单例化
    class func getInstance()->AudioPlayerMr{
        struct psSingle{
            static var onceToken:dispatch_once_t = 0;
            static var instance:AudioPlayerMr? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = AudioPlayerMr()
        })
        return psSingle.instance!
    }
    
    func setDataAndPlay(dataArray : NSMutableArray,position:Int,sura:Int){
        //本地通知
        
        //设置数据
        self.dataArray  = dataArray
        self.position = position
        self.sura = sura
        
        play()
    }
    
    func play(){
    
    }
    
    /**正在播放当前音频*/
    func isPlayCurrent(position:Int,sura:Int,isHead:Bool)->Bool{
        return true
    }
    
    //音频路径
    static func getAudioPath(quran : Quran) ->String{
        let folderPath :String = Constants.basePath + "/"+Constants.audioPath + "/"+Config.getCurrentReader() + "_v2"+"/"+String(quran.sura) + "/"
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
             try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = folderPath + getThreeInt(quran.sura!) + getThreeInt(quran.aya!) + ".mp3"
        return filePath
    }
    
    
    //音频路径
    static func getFirstAudioPath()->String {
        let folderPath :String = Config.getCurrentReader() + "_v2"+"/"+"1"+"/"
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
            try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = folderPath + "001001" + ".mp3"
        return filePath
    }
    
    //补齐3位数字
    static func  getThreeInt(i:Int) ->String{
        let formati : NSString = NSString(string: String(i))
        if(formati.length == 1){
            return "00"+String(i)
        }
        else if(formati.length == 2){
            return "0"+String(i)
        }else{
            return String(i)
        }
    }
}
