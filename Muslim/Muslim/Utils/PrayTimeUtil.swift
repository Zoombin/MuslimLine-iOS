//
//  PrayTimeUtil.swift
//  Muslim
//
//  Created by LSD on 15/11/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PrayTimeUtil: NSObject {
    
    /**获取保存的时间*/
    static func getPrayTimes()->NSMutableArray{
        let dataArray:NSMutableArray = NSMutableArray()
        for index in 0...6{
            let paryTime = Config.getPrayTime(index)
            if(paryTime.isEmpty){
                continue
            }
            dataArray.addObject(paryTime)
        }
        return dataArray
    }
    
    /**获取需要提醒的状态*/
    static func getPrayMediaStatu(mediaType:Int) ->Int{
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            var config = Config.getShiaAlarm(mediaType)
            //默认时处理
            if(-1 == config){
                if(mediaType == 0){
                    config = 1 //默认铃声
                }else if(mediaType == 1){
                    config = 1 //默认铃声
                }else if(mediaType == 3){
                    config = 1 //默认铃声
                }else{
                    config = 2
                }
            }
            return config
        }else{
            //逊尼派 sunni
            var config = Config.getSunniAlarm(mediaType)
            //默认时处理
            if(-1 == config){
                if(mediaType == 1){
                    //sunrise
                    config = 0 //静音
                }else{
                    config = 1 //默认铃声
                }
            }
            return config
        }
    }
    
    /***获取选择的闹钟音乐*/
    static func getPrayMedia(mediaType:Int)->String{
        let select = getPrayMediaStatu(mediaType)
        if(select == 0){
            return "0" //静音
        }else{
            if(Config.FACTION_SHIA == Config.getFaction()){
                //什叶派
                return Config.alarm_type_files_shia[select] as! String
            } else{
                //逊尼派
                return Config.alarm_type_files_sunni[select] as! String
            }
        }
    }
    
    static func getParyTimeLeft()->Double{
        var leftTime :Double = -1
        var current = getCurrentPrayTime()
        var next :Int
        if(current == 6){
            //24点之前
            current = 5
            next = 6
        }else if(current == -1){
            //24点之后
            current = 6
            next = 0
        }else{
            next = current+1
        }
        
        let currentTime = getSimpleDateFormat2().stringFromDate(NSDate()) as String
        let nextTime = Config.getPrayTime(next) as String
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let currentYearMonthDay = dateFormat.stringFromDate(NSDate())
        
        let dateCurrent : NSDate = getSimpleDateFormat2().dateFromString(currentTime)! as NSDate
        var dateNext : NSDate
        if(next == 6){
            dateNext = getSimpleDateFormat2().dateFromString(currentYearMonthDay + " " + nextTime)! as NSDate
        }else{
            dateNext = getSimpleDateFormat1().dateFromString(currentYearMonthDay + " " + nextTime)! as NSDate
        }
        leftTime = dateNext.timeIntervalSince1970 - dateCurrent.timeIntervalSince1970
        if(leftTime < 0){
            leftTime = leftTime + (24 * 3600)
        }
        return leftTime
    }
    
    static func getNextTimeTotal()->Double{
        var totalTime : Double = -1
        var current = getCurrentPrayTime()
        var next : Int
        if(current == 6){
            //24点之前
            current = 5
            next = 6
        }else if(current == -1){
            //24点之后
            current = 6
            next = 0
        }else{
            next = current+1
        }
        
        let currentTime = Config.getPrayTime(current) as String
        let nextTime = Config.getPrayTime(next) as String
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let currentYearMonthDay = dateFormat.stringFromDate(NSDate())
        
        var dateCurrent : NSDate
        if(current == 6){
            dateCurrent = getSimpleDateFormat2().dateFromString(currentYearMonthDay + " " + currentTime)! as NSDate
        }else{
            dateCurrent = getSimpleDateFormat1().dateFromString(currentYearMonthDay + " " + currentTime)! as NSDate
        }
        
        var dateNext : NSDate
        if(next == 6){
            dateNext = getSimpleDateFormat2().dateFromString(currentYearMonthDay + " " + nextTime)! as NSDate
        }else{
            dateNext = getSimpleDateFormat1().dateFromString(currentYearMonthDay + " " + nextTime)! as NSDate
        }
        totalTime = dateNext.timeIntervalSince1970 - dateCurrent.timeIntervalSince1970
        if(totalTime < 0){
            totalTime = totalTime + (24 * 3600)
        }
        return totalTime
    }
        
    /**获取当前礼拜时间*/
    static func getCurrentPrayTime() ->Int{
        let dataArray:NSMutableArray = getPrayTimes()
        let df : NSDateFormatter  = getSimpleDateFormat()
        let now :String = df.stringFromDate(NSDate())
        if(dataArray.count <= 0){
            return -1
        }
        for var i=0 ; i < dataArray.count ; i++ {
            if (i < dataArray.count - 1) {
                let beforetime : String = dataArray[i] as! String
                let nexttime : String = dataArray[i+1] as! String
                
                let dateFormat = NSDateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                let currentYearMonthDay = dateFormat.stringFromDate(NSDate())
                
                let dateFormatter  = getSimpleDateFormat1()
                let dateNow : NSDate = dateFormatter.dateFromString(currentYearMonthDay + " " + now)! as NSDate
                let dateBefore : NSDate = dateFormatter.dateFromString(currentYearMonthDay + " " + beforetime)! as NSDate
                let dateNext : NSDate
                if(i+1 == 6){
                    //24点之前 多存的那个
                    dateNext = getSimpleDateFormat2().dateFromString(currentYearMonthDay + " " + nexttime)! as NSDate
                }else{
                    dateNext = dateFormatter.dateFromString(currentYearMonthDay + " " + nexttime)! as NSDate
                }
                if (dateNow.timeIntervalSince1970 < dateBefore.timeIntervalSince1970 && i == 0) {
                    return -1
                }
                
                if (dateNow.timeIntervalSince1970 >= dateBefore.timeIntervalSince1970 && dateNow.timeIntervalSince1970 < dateNext.timeIntervalSince1970) {
                    return i
                }
            }else{
                return -1
            }
        }
        return -1
    }
    
    /**获取礼拜时间算法*/
    static func getPrayTime(curTime : Double)->NSMutableArray{
        let prayTimes:NSMutableArray = NSMutableArray()
        let prayTime = PrayTime();
        prayTime.setCalcMethod(Int32(Config.getPrayerTimeConventions()))
        prayTime.setAsrMethod(Int32(Config.getAsrCalculationjuristicMethod()))
        prayTime.setTimeFormat(Config.getTimeFormat() == 0 ? Int32(prayTime.Time24) : Int32(prayTime.Time12))
        prayTime.setHighLatsMethod(Int32(Config.getHighLatitudeAdjustment()))
        
        //手动调整
        if(Config.Daylight == 0){
            let offsets : NSMutableDictionary = NSMutableDictionary()
            offsets.setObject(Config.getAdjustPray(0) - 60, forKey: "fajr")
            offsets.setObject(Config.getAdjustPray(1) - 60, forKey: "sunrise")
            offsets.setObject(Config.getAdjustPray(2) - 60, forKey: "dhuhr")
            offsets.setObject(Config.getAdjustPray(3) - 60, forKey: "asr")
            offsets.setObject(0, forKey: "sunset")
            offsets.setObject(Config.getAdjustPray(4) - 60, forKey: "maghrib")
            offsets.setObject(Config.getAdjustPray(5) - 60, forKey: "isha")
            prayTime.tune(offsets)
        }
        if(Config.Daylight == 1){
            let offsets : NSMutableDictionary = NSMutableDictionary()
            offsets.setObject(Config.getAdjustPray(0), forKey: "fajr")
            offsets.setObject(Config.getAdjustPray(1), forKey: "sunrise")
            offsets.setObject(Config.getAdjustPray(2), forKey: "dhuhr")
            offsets.setObject(Config.getAdjustPray(3), forKey: "asr")
            offsets.setObject(0, forKey: "sunset")
            offsets.setObject(Config.getAdjustPray(4), forKey: "maghrib")
            offsets.setObject(Config.getAdjustPray(5), forKey: "isha")
            prayTime.tune(offsets)
        }
        if(Config.Daylight == 2){
            let offsets : NSMutableDictionary = NSMutableDictionary()
            offsets.setObject(Config.getAdjustPray(0) - 120, forKey: "fajr")
            offsets.setObject(Config.getAdjustPray(1) - 120, forKey: "sunrise")
            offsets.setObject(Config.getAdjustPray(2) - 120, forKey: "dhuhr")
            offsets.setObject(Config.getAdjustPray(3) - 120, forKey: "asr")
            offsets.setObject(0, forKey: "sunset")
            offsets.setObject(Config.getAdjustPray(4) - 120, forKey: "maghrib")
            offsets.setObject(Config.getAdjustPray(5) - 120, forKey: "isha")
            prayTime.tune(offsets)
        }
        
        var currentTime : Double = 0
        if(curTime <= 0){
            currentTime = NSDate().timeIntervalSince1970
        }else{
            currentTime = curTime
        }
        let date = NSDate(timeIntervalSince1970: currentTime)
        let calendar = NSCalendar.currentCalendar()
        
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        NSLog("%ld月%ld日%ld时%ld分" ,components.month, components.day, components.hour, components.minute)
        
        let lat : Double = Config.getLat().doubleValue
        let lng : Double = Config.getLng().doubleValue
        if (lat == 0 && lng == 0) {
            prayTimes.removeAllObjects()
            return prayTimes
        }
        let timeZoneString = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: timeZoneString)
        let zone = Double((timeZone?.secondsFromGMT)!) / Double(3600)
        let times : NSMutableArray = prayTime.getPrayerTimes(components, andLatitude: lat, andLongitude: lng, andtimeZone: zone) as NSMutableArray
        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(times as [AnyObject])
        if (prayTimes.count == 7) {
            //TODO:删除sunset
            prayTimes.removeObjectAtIndex(4)
        }
        //保存最终数据
        for index in 0...5{
            Config.savePrayTime(index, time: prayTimes[index] as! String)
        }
        //多存一个 24点 （方便计算）
        if (Config.TimeFormat == 0) {
            Config.savePrayTime(6, time: "23:59:59")
        } else {
            Config.savePrayTime(6, time: "11:59:59 PM")
        }
        return prayTimes
    }
    
    
    static func getSimpleDateFormat() -> NSDateFormatter {
        let dateFormat = NSDateFormatter()
        
        if (Config.TimeFormat == 0) {
            dateFormat.dateFormat = "HH:mm"
        }else{
            dateFormat.dateFormat = "hh:mm aaa"
        }
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        dateFormat.timeZone  = timeZone
        dateFormat.locale = NSLocale.init(localeIdentifier: "en_US")
        return dateFormat
    }
    
    static func getSimpleDateFormat1() -> NSDateFormatter {
        let dateFormat = NSDateFormatter()
        
        if (Config.TimeFormat == 0) {
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        }else{
            dateFormat.dateFormat = "yyyy-MM-dd hh:mm aaa"
        }
        
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        dateFormat.timeZone  = timeZone
        dateFormat.locale = NSLocale.init(localeIdentifier: "en_US")
        return dateFormat
    }
    
    static func getSimpleDateFormat2() -> NSDateFormatter {
        let dateFormat = NSDateFormatter()
        
        if (Config.TimeFormat == 0) {
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss aaa"
        }
        
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        dateFormat.timeZone  = timeZone
        dateFormat.locale = NSLocale.init(localeIdentifier: "en_US")
        return dateFormat
    }
    
    static func getSimpleDateFormat3() -> NSDateFormatter {
        let dateFormat = NSDateFormatter()
        
        if (Config.TimeFormat == 0) {
            dateFormat.dateFormat = "HH:mm:ss"
        }else{
            dateFormat.dateFormat = "hh:mm:ss aaa"
        }
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        dateFormat.timeZone  = timeZone
        dateFormat.locale = NSLocale.init(localeIdentifier: "en_US")
        return dateFormat
    }
    
    static func get24Time()->String{
        var time = ""
        if (Config.TimeFormat == 0) {
            time = "23:59:59"
        } else {
            time = "11:59:59 PM"
        }
        return time;
    }
    
    static func isBefor24()->Bool{
        let dateFormatter  = getSimpleDateFormat3()
        let dateNow : NSDate = dateFormatter.dateFromString(dateFormatter.stringFromDate(NSDate()))! as NSDate
        let date24 : NSDate = dateFormatter.dateFromString(get24Time())! as NSDate
        if (dateNow.timeIntervalSince1970 < date24.timeIntervalSince1970) {
            return true
        }
        return false
    }

}
