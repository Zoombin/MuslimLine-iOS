//
//  PrayTimeUtil.swift
//  Muslim
//
//  Created by LSD on 15/11/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PrayTimeUtil: NSObject {
    var dataArray:NSMutableArray = NSMutableArray()
    let dateFormat = NSDateFormatter()
    
    //初始化
    override init() {
        super.init()
        getPrayTimes()
        
        dateFormat.dateFormat = "HH:mm"
    }
    
    func getCurrentPrayTime() ->Int{
        var index  = 0
        let cDate = dateFormat.stringFromDate(NSDate())
        let cDateArr = cDate.componentsSeparatedByString(":")
        
        var sH :String = ""
        var cH :String = ""
        if(dataArray.count > 0){
            for i in 0...dataArray.count-1 {
                let date = dataArray[i]
                let saveDateArr = date.componentsSeparatedByString(":")
                sH = saveDateArr[0]
                let sM :String = saveDateArr[1]
                
                cH  = cDateArr[0]
                let cM :String = cDateArr[1]
                
                if(Int(cH) > Int(sH)){
                }else if(Int(cH) == Int(sH)){
                    if(Int(cM) <= Int(sM)){
                        index = i
                    }
                }else{
                    index = i
                }
            }
        }
        if(index == 0){
             if(Int(cH) > Int(sH)){
                index = dataArray.count-1
            }
        }
        return index
    }
    
    
    /**获取保存的时间*/
    func getPrayTimes(){
        for index in 0...5{
            let paryTime = Config.getPrayTime(index)
            if(paryTime.isEmpty){
                continue
            }
            dataArray.addObject(paryTime)
        }
    }
    
    /**获取礼拜时间算法*/
    static func getPrayTime()->NSMutableArray{
        let prayTimes : NSMutableArray = NSMutableArray()
        let prayTime = PrayTime();
        prayTime.setCalcMethod(Int32(3))
        prayTime.setAsrMethod(Int32(Config.getAsrCalculationjuristicMethod()))
        prayTime.setTimeFormat(Config.getTimeFormat() == 0 ? Int32(prayTime.Time24) : Int32(prayTime.Time12))
        prayTime.setHighLatsMethod(Int32(prayTime.AngleBased))
        
        let date = NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)
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
        
        let times : NSMutableArray = prayTime.getPrayerTimes(components, andLatitude: lat, andLongitude: lng, andtimeZone: Double(Config.getTimeZone())!) as NSMutableArray
        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(times as [AnyObject])
        if (prayTimes.count == 7) {
            //TODO:删除sunset
            prayTimes.removeObjectAtIndex(4)
        }
        
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let adjustArray : NSMutableArray = NSMutableArray()
        //手动调整
        
        for index in 0...prayTimes.count-1 {
            let pray = prayTimes[index]
            let date : NSDate = dateFormat.dateFromString(pray as! String)!
            let adjust = Config.getAdjustPray(index) //获取手动调整时间
            let newDate =  NSDate(timeInterval: Double(( adjust - 60 )*60), sinceDate: date)//保存的是位置，时间要减去60
            let newPray = dateFormat.stringFromDate(newDate)
            Config.savePrayTime(index, time: newPray)//保存最终设置的礼拜时间
            adjustArray.addObject(newPray)
        }

        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(adjustArray as [AnyObject])
        return prayTimes
    }

}
