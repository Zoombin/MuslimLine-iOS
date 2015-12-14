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
        for index in 0...5{
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
            return Config.getShiaAlarm(mediaType)
        }else{
            //逊尼派
            return Config.getSunniAlarm(mediaType)
        }
    }
    
    /***获取选择的闹钟音乐*/
    static func getPrayMedia(mediaType:Int)->String{
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            let select = Config.getShiaAlarm(mediaType)
            if(select == 0){
                return "0" //静音
            }else if(select == 1){
                return "1" //默认
            }else if(select == 2){
                return "2" //aghati_ios.mp3
            }else{
                return Config.alarm_type_files_shia[select] as! String
            }
        } else{
            //逊尼派
            let select = Config.getSunniAlarm(mediaType)
            if(select == 0){
                return "0"
            }else if(select == 1){
                return "1"
            }else{
                return Config.alarm_type_files_sunni[select] as! String
            }
        }
    }
    
    
    static func getParyTimeLeft()->Int{
        var leftTime = -1
        let current = getCurrentPrayTime()
        let next :Int
        if(current  == 5){
            next = 0
        }else{
            next = current + 1
        }
        var nextTime = Config.getPrayTime(next) as NSString
        if(!nextTime.isEqualToString("")){
            if(nextTime.rangeOfString("PM").location != NSNotFound){
                nextTime = nextTime.stringByReplacingOccurrencesOfString("PM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let arr = nextTime.componentsSeparatedByString(":")
                let hourValue = Int(arr[0])
                let hour = hourValue! == 12 ? hourValue : hourValue!+12 //要处理下PM 12的情况
                nextTime = String(format: "%d:%@", hour!,arr[1])
            }
            if(nextTime.rangeOfString("AM").location != NSNotFound){
                nextTime = nextTime.stringByReplacingOccurrencesOfString("AM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            let nextTimeArr = nextTime.componentsSeparatedByString(":")
            
            
            let zone = Config.getTimeZone()
            let timeZone = NSTimeZone.init(name: zone)
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "HH:mm"
            dateFormat.timeZone = timeZone
            dateFormat.locale = NSLocale.init(localeIdentifier: "en_US")
            let cDate = dateFormat.stringFromDate(NSDate())
            let cDateArr = cDate.componentsSeparatedByString(":")
            
            if(current == 5){
                leftTime = (23 - Int(cDateArr[0])!) * 3600 + (60 - Int(cDateArr[1])!) * 60 + Int(nextTimeArr[0])! * 3600 + Int(nextTimeArr[1])! * 60
            }else{
                leftTime = (Int(nextTimeArr[0])! - Int(cDateArr[0])!) * 3600 + (Int(nextTimeArr[1])! - Int(cDateArr[1])!) * 60
            }
        }
        return leftTime
    }
    
    
    static func getNextTimeTotal()->Int{
        var leftTime = -1
        var current = getCurrentPrayTime()
        let next : Int
        if(current == -1){
            //24点以后，晨礼之前
            current = 5
        }
        if(current  == 5){
            next = 0
        }else{
            next = current+1
        }
        var currentTime = Config.getPrayTime(current) as NSString
        if(!currentTime.isEqualToString("")){
            if(currentTime.rangeOfString("PM").location != NSNotFound){
                currentTime = currentTime.stringByReplacingOccurrencesOfString("PM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let arr = currentTime.componentsSeparatedByString(":")
                let hourValue = Int(arr[0])
                let hour = hourValue! == 12 ? hourValue : hourValue!+12 //要处理下PM 12的情况
                currentTime = String(format: "%d:%@", hour!,arr[1])
            }
            if(currentTime.rangeOfString("AM").location != NSNotFound){
                currentTime = currentTime.stringByReplacingOccurrencesOfString("AM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            let currentTimeArr = currentTime.componentsSeparatedByString(":")
            
            
            var nextTime = Config.getPrayTime(next) as NSString
            if(nextTime.rangeOfString("PM").location != NSNotFound){
                nextTime = nextTime.stringByReplacingOccurrencesOfString("PM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let arr = nextTime.componentsSeparatedByString(":")
                let hourValue = Int(arr[0])
                let hour = hourValue! == 12 ? hourValue : hourValue!+12 //要处理下PM 12的情况
                nextTime = String(format: "%d:%@", hour!,arr[1])
            }
            if(nextTime.rangeOfString("AM").location != NSNotFound){
                nextTime = nextTime.stringByReplacingOccurrencesOfString("AM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            let nextTimeArr = nextTime.componentsSeparatedByString(":")
            
            if(current == 5){
                leftTime = (23 - Int(currentTimeArr[0])!) * 3600 + (60 - Int(currentTimeArr[1])!) * 60 + Int(nextTimeArr[0])! * 3600 + Int(nextTimeArr[1])!*60
            }else{
                leftTime = (Int(nextTimeArr[0])! - Int(currentTimeArr[0])!) * 3600 + (Int(nextTimeArr[1])! - Int(currentTimeArr[1])!) * 60
            }
            
        }
        return leftTime
    }

    
    
    
    /**获取当前礼拜时间*/
    static func getCurrentPrayTime() ->Int{
        let dataArray:NSMutableArray = getPrayTimes()
        var index  = -1
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "HH:mm"
        dateFormat.timeZone = timeZone
        dateFormat.locale = NSLocale.init(localeIdentifier: "en_US")
        let cDate = dateFormat.stringFromDate(NSDate())
        let cDateArr = cDate.componentsSeparatedByString(":")
        
        var sH :String = ""
        var cH :String = ""
        if(dataArray.count > 0){
            for var i = dataArray.count-1 ; i >= 0; i-- {
                var date = dataArray[i]
                if(date.rangeOfString("PM").location != NSNotFound){
                    date = date.stringByReplacingOccurrencesOfString("PM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let arr = date.componentsSeparatedByString(":")
                    let hourValue = Int(arr[0])
                    let hour = hourValue! == 12 ? hourValue : hourValue!+12 //要处理下PM 12的情况
                    date = String(format: "%d:%@", hour!,arr[1])
                }
                if(date.rangeOfString("AM").location != NSNotFound){
                    date = date.stringByReplacingOccurrencesOfString("AM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                }
                
                let saveDateArr = date.componentsSeparatedByString(":")
                sH = saveDateArr[0]
                let sM :String = saveDateArr[1]
                
                cH  = cDateArr[0]
                let cM :String = cDateArr[1]
                if(Int(cH) > Int(sH)){
                    index = i
                    break
                }else if(Int(cH) == Int(sH)){
                    if(Int(cM) >= Int(sM)){
                        index = i
                        break
                    }
                }
            }
        }
        return index
    }
    
    /**获取礼拜时间算法*/
    static func getPrayTime()->NSMutableArray{
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
        
        
        let currentTime : Double = NSDate().timeIntervalSince1970
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
        return prayTimes
    }

}
