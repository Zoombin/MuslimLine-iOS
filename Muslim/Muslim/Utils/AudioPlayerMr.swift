//
//  AudioPlayerMr.swift
//  Muslim

//  播放音乐

//  Created by LSD on 15/11/22.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


protocol mAudioPlayerDelegate : NSObjectProtocol {
    func finishPlaying()
    func startPlaying(position:Int)
    func pausePlaying(position:Int)
    func loading(position:Int)
    func loadFail()
    func loadNext(sura:Int)
}

class AudioPlayerMr: NSObject,AVAudioPlayerDelegate,httpClientDelegate{
    var delegate : mAudioPlayerDelegate?
    var playingMusicInfoDic: [String : NSObject] = Dictionary()
    var translated_sura_titles : NSArray = NSArray() //翻译列表
    
    var dataArray : NSMutableArray = NSMutableArray()
    var position:Int = 0
    var sura:Int?
    
    var isPlaying :Bool  = false //正在播放
    var isPause :Bool = false
    var audioPlayer : AVAudioPlayer! //播放器
    
    var httpClient : MSLHttpClient =  MSLHttpClient() //网络请求
    
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
    
    //初始化
    override init() {
        super.init()
        httpClient.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("translated_sura_titles", ofType: "plist") //翻译
        translated_sura_titles = NSArray(contentsOfFile: path!)!
    }
    
    /***  下载音频回调    ****/
    func succssResult(result : NSObject, tag : NSInteger) {
        var path = result as? String
        path = path!.stringByReplacingOccurrencesOfString("file://", withString: "")
        print("downFile = " + path!)
        
        play(path!)
    }
    func errorResult(error : NSError, tag : NSInteger) {
        if(delegate != nil){
            delegate?.loadFail()
        }
    }
    
    
    /**播放完成回调**/
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        stop()
        if(delegate != nil){
            delegate?.finishPlaying()
        }
        next(position)
    }
    
    func loadDataAndPlay(dataArray : NSMutableArray,position:Int,sura:Int,isHead:Bool){
        //设置数据
        self.dataArray  = dataArray
        self.position = position
        self.sura = sura
        
        if(isHead){
            loadNewHeadAudio()
        }else{
            let quran :Quran = dataArray[position] as! Quran
            loadNewAudio(quran, position: position)
        }
    }
    
    
    func setDataAndPlay(dataArray : NSMutableArray,position:Int,sura:Int,isHead:Bool){
        //设置数据
        self.dataArray  = dataArray
        self.position = position
        self.sura = sura
        
        var audioPath :String = ""
        if(isHead){
            audioPath = AudioPlayerMr.getFirstAudioPath() + AudioPlayerMr.getFirstAudioName()
        }else{
            let quran :Quran = dataArray[position] as! Quran
            audioPath = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
        }
        
        play(audioPath)
    }
    
    func play(path:String){
        //指定音乐路径
        let url = NSURL(fileURLWithPath: path)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.delegate = self
        audioPlayer.numberOfLoops = 0
        //设置音乐播放次数，-1为循环播放
        audioPlayer.volume = 1
        //设置音乐音量，可用范围为0~1
        audioPlayer.prepareToPlay()
        
        //设置背景播放信息
        let duration = audioPlayer?.duration
        let artWork = MPMediaItemArtwork(image: UIImage(named:"ic_audio_bk_bg")!)
        playingMusicInfoDic[MPMediaItemPropertyTitle] = NSLocalizedString("main_quran_label", comment:"")
        playingMusicInfoDic[MPMediaItemPropertyArtwork] = artWork
        
        var artist=""
        if(position >= 0){
            artist = String(format: "%d.%@  %@(%d)", sura!,(translated_sura_titles[sura!-1] as! String),NSLocalizedString("verse", comment:""),(position+1))
        }else{
            artist = String(format: "%d.%@", sura!,(translated_sura_titles[sura!-1] as! String))
        }
        playingMusicInfoDic[MPMediaItemPropertyArtist] = artist
        playingMusicInfoDic[MPMediaItemPropertyPlaybackDuration] = NSNumber(double: duration!)
        playingMusicInfoDic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer?.currentTime
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = playingMusicInfoDic
        /*
        // MPMediaItemPropertyAlbumTitle
        // MPMediaItemPropertyAlbumTrackCount
        // MPMediaItemPropertyAlbumTrackNumber
        // MPMediaItemPropertyArtist
        // MPMediaItemPropertyArtwork
        // MPMediaItemPropertyComposer
        // MPMediaItemPropertyDiscCount
        // MPMediaItemPropertyDiscNumber
        // MPMediaItemPropertyGenre
        // MPMediaItemPropertyPersistentID
        // MPMediaItemPropertyPlaybackDuration
        // MPMediaItemPropertyTitle
        */


        play()
    }
    
    func stop(){
        isPlaying = false
        isPause = false
        if(audioPlayer != nil && audioPlayer.playing){
            audioPlayer.stop()
        }
    }
    
    func play(){
        if(audioPlayer == nil){
            return
        }
        isPlaying = true
        if(delegate != nil){
            delegate?.startPlaying(position)
        }
        isPause = false
        audioPlayer.play()
    }
    
    func pause(){
        isPlaying = false
        isPause = true
        if(delegate != nil){
            delegate?.pausePlaying(position)
        }
        audioPlayer.pause()
    }
    
    /**下一个*/
    func next(curentPosition:Int){
        if(dataArray.count == 0){
            return
        }
        stop()
        if(curentPosition < dataArray.count-1){
            position = curentPosition+1;
            
            let quran :Quran = dataArray[position] as! Quran
            let audioPath :String = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
            //已经存在
            if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
                play(audioPath)
            }else{
                loadNewAudio(quran, position: position)
            }
        }else{
            //下一章节
            if(sura > FMDBHelper.getInstance().getMaxSura()){
                return
            }
            let tempSura = sura!+1
            let quranArray : NSMutableArray = FMDBHelper.getInstance().getQurans(tempSura)
            if(quranArray.count>0){
                if(delegate != nil){
                    delegate?.loadNext(tempSura)
                }
                var isHead: Bool = false;
                if((tempSura) != 1 && (tempSura) != 9){
                    isHead = true
                }else{
                    isHead = false
                }
                var audioPath :String = ""
                if(isHead){
                    audioPath = AudioPlayerMr.getFirstAudioPath() + AudioPlayerMr.getFirstAudioName()
                }else{
                    let quran :Quran = quranArray[0] as! Quran
                    audioPath  = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
                }
                if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
                    setDataAndPlay(quranArray, position: isHead ? -1 : 0, sura: tempSura, isHead: isHead)
                }else{
                    loadDataAndPlay(quranArray, position: isHead ? -1 : 0, sura: tempSura, isHead: isHead)
                }
            }else{
                //所有章节已读完
            }
        }
    }
    
    //上一个(有待完善)
    func previous(curentPosition:Int){
        if(dataArray.count == 0){
            return
        }
        stop()
        var minPosition = 0
        if((sura) != 1 && (sura) != 9){
            minPosition = -1
        }else{
            minPosition = 0
        }
        if(curentPosition > minPosition){
            position = curentPosition-1;
            var audioPath :String = ""
            if(position == -1){
                audioPath = AudioPlayerMr.getFirstAudioPath() + AudioPlayerMr.getFirstAudioName()
            }else{
                let quran :Quran = dataArray[position] as! Quran
                audioPath  = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
            }
            //已经存在
            if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
                play(audioPath)
            }else{
                if(position == -1){
                    loadNewHeadAudio()
                }else{
                    loadNewAudio((dataArray[position] as! Quran), position: position)
                }
            }
        }else{
            //上一章节
            if(sura <= FMDBHelper.getInstance().getMinSura()){
                return
            }
            let tempSura = sura!-1
            let quranArray : NSMutableArray = FMDBHelper.getInstance().getQurans(tempSura)
            if(quranArray.count>0){
                if(delegate != nil){
                    delegate?.loadNext(tempSura)
                }
                var audioPath :String = ""
                let quran :Quran = quranArray[quranArray.count-1] as! Quran
                audioPath  = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
                if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
                    setDataAndPlay(quranArray, position:quranArray.count-1, sura: tempSura, isHead: false)
                }else{
                    loadDataAndPlay(quranArray, position:quranArray.count-1, sura: tempSura, isHead: false)
                }
            }else{
                //已经是第一个了
            }
        }
    }
    
    func loadNewAudio(quran:Quran,position:Int){
        if(delegate != nil){
            delegate?.loading(position)
        }
        //下载
        let fileName:String = AudioPlayerMr.getAudioUrl(quran) + AudioPlayerMr.getAudioName(quran)
        let url = Constants.downloadBaseUri + fileName.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let outPath :String = AudioPlayerMr.getAudioPath(quran)
        
        httpClient.downloadDocument(url,outPath: outPath)
    }
    
    func loadNewHeadAudio(){
        if(delegate != nil){
            delegate?.loading(position)
        }
        let fileName:String = AudioPlayerMr.getFirstAudioUrl() + AudioPlayerMr.getFirstAudioName()
        let url = Constants.downloadBaseUri + fileName.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let outPath :String = AudioPlayerMr.getFirstAudioPath()
        httpClient.downloadDocument(url,outPath: outPath)
    }
    
    /**正在播放当前音频*/
    func isPlayCurrent(position:Int,sura:Int,isHead:Bool)->Bool{
        if(!isPlaying){
            return false
        }
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
        var folderPath :String = FileUtils.documentsDirectory() + "/" + Constants.audioPath + "/" + getAudioUrl(quran)
        folderPath = folderPath.stringByReplacingOccurrencesOfString(" ", withString: "_")
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
            try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        return folderPath
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
        var folderPath :String = Constants.basePath + "/"+Constants.audioPath + "/" + getFirstAudioUrl()
        folderPath = folderPath.stringByReplacingOccurrencesOfString(" ", withString: "_")
        if(!NSFileManager.defaultManager().fileExistsAtPath (folderPath)){
            try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        return folderPath
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
