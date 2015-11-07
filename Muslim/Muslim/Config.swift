//
//  Config.swift
//  Muslim
//
//  Created by LSD on 15/11/6.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class Config: NSObject {
    // 什叶派
    static let FACTION_SHIA :NSInteger = 0;
    // 逊尼派
    static let FACTION_SUNI :NSInteger = 1;

    static var faction : Int = 0 //穆斯林派别
    static var PrayerName :Int = 0 //礼拜时间约定
    static var FajrTime :Int = 0
    static var SunriseTime :Int = 0
    static var DhuhrTime :Int = 0
    static var AsrTime :Int = 0
    static var MaghribTime :Int = 0
    static var IshaaTime :Int = 0
    static var IsIslamicCalendar:Int = 0//日历选择
    
    
    static var CalculationMethods :Int = 0 //祈祷时间算法
    static var JuristicMethods :Int = 0
    static var HighLatitude :Int = 0 //高纬度调整
    static var Daylight :Int = 0 //夏令日
    static var TimeFormat :Int = 0 //时间格式
    static var SlinetMode :Int = 0
    static var AutoSwitch :Int = 0
    
    /**启动获取配置数据*/
    static func initData(){
        getFaction()
        getAsrCalculationjuristicMethod()
        getPrayerName()
        getHighLatitudeAdjustment()
        getDaylightSavingTime()
        getTimeFormat()
        getCalenderSelection()
        getAutoSwitch()
        getSlientMode()
    }
    /**清除配置数据*/
    static func cleanData(){
    
    }
    
    /**穆斯林派别*/
    static func saveFaction(pos :Int){
        UserDefaultsUtil.saveInt("faction", value: pos)
        faction = pos
    }
    static func getFaction() ->Int{
        faction = UserDefaultsUtil.getInt("faction")
        return faction
    }
    
    /**祈祷时间算法*/
    static func saveAsrCalculationjuristicMethod(pos :Int) {
        UserDefaultsUtil.saveInt("CalculationjuristicMethod", value: pos)
        CalculationMethods = pos
    }
    static func getAsrCalculationjuristicMethod() -> Int{
        CalculationMethods = UserDefaultsUtil.getInt("CalculationjuristicMethod")
        return CalculationMethods
    }
    
    /**礼拜时间约定**/
    static func savePrayerName(pos :Int) {
        UserDefaultsUtil.saveInt("PrayerName", value: pos)
        PrayerName = pos
    }
    static func getPrayerName()-> Int {
        PrayerName = UserDefaultsUtil.getInt("PrayerName")
        return PrayerName
    }
    
    /**高纬度调整*/
    static func saveHighLatitudeAdjustment(pos :Int) {
        UserDefaultsUtil.saveInt("HighLatitudeAdjustment", value: pos)
        HighLatitude = pos
    }
    static func getHighLatitudeAdjustment()->Int {
        HighLatitude = UserDefaultsUtil.getInt("HighLatitudeAdjustment")
        return HighLatitude
    }
    
    /**夏令日*/
    static func saveDaylightSavingTime(pos :Int) {
        UserDefaultsUtil.saveInt("DaylightSavingTime", value: pos)
        Daylight = pos
    }
    static func getDaylightSavingTime()->Int {
        Daylight = UserDefaultsUtil.getInt("DaylightSavingTime")
        return Daylight
    }
    
    /**时间制式**/
    static func saveTimeFormat(pos :Int) {
        UserDefaultsUtil.saveInt("TimeFormat", value: pos)
        TimeFormat = pos
    }
    static func getTimeFormat()->Int {
        TimeFormat = UserDefaultsUtil.getInt("TimeFormat")
        return TimeFormat
    }
    
    /***日历选择*/
    static func saveCalenderSelection(pos :Int) {
        UserDefaultsUtil.saveInt("Calender", value: pos)
        IsIslamicCalendar = pos;
    }
    static func getCalenderSelection()->Int {
        IsIslamicCalendar  = UserDefaultsUtil.getInt("Calender")
        return IsIslamicCalendar
    }
    
    /**自动设置*/
    static func saveAutoSwitch(pos :Int) {
        UserDefaultsUtil.saveInt("AutoSwitch", value: pos)
        AutoSwitch = pos
    }
    static func getAutoSwitch() ->Int{
        AutoSwitch  = UserDefaultsUtil.getInt("AutoSwitch")
        return AutoSwitch
    }
    
    /**默认播放*/
    static func saveSlientMode(pos :Int) {
        UserDefaultsUtil.saveInt("SlientMode", value: pos)
        SlinetMode = pos
    }
    static func getSlientMode() ->Int{
        SlinetMode  = UserDefaultsUtil.getInt("SlientMode")
        return SlinetMode
    }
   
    
    
}
