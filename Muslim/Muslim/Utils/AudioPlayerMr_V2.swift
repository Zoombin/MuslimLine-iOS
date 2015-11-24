//
//  AudioPlayerMr.swift
//  Muslim

//  播放音乐

//  Created by LSD on 15/11/22.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerMr_V2: NSObject {
    var dataArray : NSMutableArray?
    var position:Int?
    var sura:Int?
    
    var isPlaying :Bool  = false //正在播放
    var audioPlayer : AVAudioPlayer! //播放器
    
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
        
        //play()
    }
    
    func play(path:String){
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
        audioPlayer.stop()
    }
    
    /**正在播放当前音频*/
    func isPlayCurrent(position:Int,sura:Int,isHead:Bool)->Bool{
        if(isHead){
            if(sura == self.sura){
                return true
            }else{
                return false
            }
        }else{
            if(position == self.position && sura == self.sura){
                return true
            }else{
                return false
            }
        }
    }
    
    //音频路径
    static func getAudioPath(quran : Quran) ->String{
        let folderPath :String = Constants.basePath + "/"+Constants.audioPath + "/" + getAudioUrl(quran)
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
             try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName:String = getAudioName(quran)
        return folderPath + fileName
    }
    //url
    static func getAudioUrl(quran : Quran) ->String{
        let url :String = Config.getCurrentReader() + "_v2"+"/"+String(quran.sura!) + "/"
        return url
    }
    //音频名称
    static func getAudioName(quran : Quran) ->String{
        return getThreeInt(quran.sura!) + getThreeInt(quran.aya!) + ".mp3"
    }
    
    
    //音频路径
    static func getFirstAudioPath()->String {
        let folderPath :String = Constants.basePath + "/"+Constants.audioPath + "/" + getFirstAudioUrl()
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
            try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName:String = getFirstAudioName()
        Log.print(folderPath)
        return folderPath + fileName
    }
    //url
    static func getFirstAudioUrl()->String {
        let url :String = Config.getCurrentReader() + "_v2"+"/"+"1"+"/"
        return url
    }
    //音频名称
    static func getFirstAudioName()->String {
        return "001001" + ".mp3"
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
