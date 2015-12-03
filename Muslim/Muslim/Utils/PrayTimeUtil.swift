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
    func getPrayMediaStatu(mediaType:Int) ->Int{
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            return Config.getShiaAlarm(mediaType)
        }else{
            //逊尼派
            return Config.getSunniAlarm(mediaType)
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
                let hour = Int(arr[0])!+12
                nextTime = String(hour)+":"+arr[1]
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
        let current = getCurrentPrayTime()
        let next : Int
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
                let hour = Int(arr[0])!+12
                currentTime = String(hour)+":"+arr[1]
            }
            if(currentTime.rangeOfString("AM").location != NSNotFound){
                currentTime = currentTime.stringByReplacingOccurrencesOfString("AM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            let currentTimeArr = currentTime.componentsSeparatedByString(":")
            
            
            var nextTime = Config.getPrayTime(next) as NSString
            if(nextTime.rangeOfString("PM").location != NSNotFound){
                nextTime = nextTime.stringByReplacingOccurrencesOfString("PM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let arr = nextTime.componentsSeparatedByString(":")
                let hour = Int(arr[0])!+12
                nextTime = String(hour)+":"+arr[1]
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
                    let hour = Int(arr[0])!+12
                    date = String(hour)+":"+arr[1]
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
        prayTime.setCalcMethod(Int32(3))
        prayTime.setAsrMethod(Int32(Config.getAsrCalculationjuristicMethod()))
        prayTime.setTimeFormat(Config.getTimeFormat() == 0 ? Int32(prayTime.Time24) : Int32(prayTime.Time12))
        prayTime.setHighLatsMethod(Int32(prayTime.AngleBased))
        
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
        let zone = Double((timeZone?.secondsFromGMT)! / 3600)
        let times : NSMutableArray = prayTime.getPrayerTimes(components, andLatitude: lat, andLongitude: lng, andtimeZone: zone) as NSMutableArray
        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(times as [AnyObject])
        if (prayTimes.count == 7) {
            //TODO:删除sunset
            prayTimes.removeObjectAtIndex(4)
        }
        
        //手动调整
        //start
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let adjustArray : NSMutableArray = NSMutableArray()
        for index in 0...prayTimes.count-1 {
            var pray :NSString = (prayTimes[index].uppercaseString)  as NSString
            var replaceType = 0
            if(pray.rangeOfString("PM").location != NSNotFound){
                replaceType = 1
                pray = pray.stringByReplacingOccurrencesOfString("PM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let arr = pray.componentsSeparatedByString(":")
                let hour = Int(arr[0])!+12
                pray = String(hour)+":"+arr[1]
            }
            if(pray.rangeOfString("AM").location != NSNotFound){
                replaceType = 3
                pray = pray.stringByReplacingOccurrencesOfString("AM", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            let date : NSDate = dateFormat.dateFromString(pray as String)!
            let adjust = Config.getAdjustPray(index) //获取手动调整时间
            let newDate =  NSDate(timeInterval: Double(( adjust - 60 ) * 60), sinceDate: date)//保存的是位置，时间要减去60
            var newPray = dateFormat.stringFromDate(newDate)
            if(replaceType == 1){
                let arr = newPray.componentsSeparatedByString(":")
                let hour = Int(arr[0])!-12
                newPray = String(hour)+":"+arr[1]+" PM"
            }
            if(replaceType == 3){
                newPray = newPray + " AM"
            }
            Config.savePrayTime(index, time: newPray)//保存最终设置的礼拜时间
            adjustArray.addObject(newPray)
        }
        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(adjustArray as [AnyObject])
        //end
        
        return prayTimes
    }

}
