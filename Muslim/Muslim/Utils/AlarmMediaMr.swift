//
//  AlarmMediaMr.swift
//  Muslim

//  响礼闹钟处理

//
//  Created by LSD on 15/11/25.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import AVFoundation

protocol mAlarmMediaDelegate : NSObjectProtocol {
    func loading(position:Int)
    func loadingfinish(position:Int)
    func loadFail(position:Int)
}
class AlarmMediaMr: NSObject ,httpClientDelegate{
    var isPlaying :Bool  = false //正在播放
    var audioPlayer : AVAudioPlayer! //播放器
    
    var delegate : mAlarmMediaDelegate?
    var httpClient : MSLHttpClient =  MSLHttpClient() //网络请求
    var mediaIndex = 0
    
    //单例
    class func getInstance()->AlarmMediaMr{
        struct psSingle{
            static var onceToken:dispatch_once_t = 0;
            static var instance:AlarmMediaMr? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = AlarmMediaMr()
        })
        return psSingle.instance!
    }
    
    //初始化
    override init() {
        super.init()
        httpClient.delegate = self
    }
    
    /***  下载闹钟声音回调    ****/
    func succssResult(result : NSObject, tag : NSInteger) {
        var path = result as? String
        path = path!.stringByReplacingOccurrencesOfString("file://", withString: "")
        print("downAlam = " + path!)
        if(delegate != nil){
            delegate?.loadingfinish(mediaIndex)
        }
        
    }
    func errorResult(error : NSError, tag : NSInteger) {
        if(delegate != nil){
            delegate?.loadFail(mediaIndex)
        }
    }
    
    func play(path:String){
        play(0, path: path)
    }
    
    
    func play(mediaIndex:Int,path:String){
        self.mediaIndex = mediaIndex
        //指定音乐路径
        let url = NSURL(fileURLWithPath: path)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.numberOfLoops = 0
        //设置音乐播放次数，-1为循环播放
        audioPlayer.volume = 1
        //设置音乐音量，可用范围为0~1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        isPlaying = true
    }
    
    func stop(){
        isPlaying = false
        if(audioPlayer != nil && audioPlayer.playing){
            audioPlayer.stop()
        }
    }
    
    func loadNewAlarmMedia(mediaIndex:Int){
        self.mediaIndex = mediaIndex
        let mapArray :NSArray = getMp3Data()
        let fileName:String = mapArray[mediaIndex] as! String
        let url = Constants.downloadSoundUri + fileName
        let outPath :String = AlarmMediaMr.getAlarmMediaPath()
        if(delegate != nil){
            delegate?.loading(mediaIndex)
        }
        Log.printLog("alarm url = "+url)
        Log.printLog("outPath = "+outPath)
        httpClient.downloadDocument(url,outPath: outPath)
    }
    
    static func getAlarmMediaPath()->String {
        let folderPath :String = Constants.basePath + "/"+Constants.audioPath + "/" + Constants.alarmPath + "/"
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
            try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        return folderPath
    }
    
    static func getAlarmMediaLocalPath(name:String)->String {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "")
        return path!
    }

    
    func getMp3Data()->NSArray{
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            return Config.alarm_type_files_shia
        }else{
            //逊尼派)
            return Config.alarm_type_files_sunni
        }
    }
    
    

}
