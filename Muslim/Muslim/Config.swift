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
    static var IsIslamicCalendar:Int = 0//日历选择
    static var CalculationMethods :Int = 0 //祈祷时间算法
    static var HighLatitude :Int = 0 //高纬度调整
    static var Daylight :Int = 0 //夏令日
    static var TimeFormat :Int = 0 //时间格式
    static var SlinetMode :Int = 0 //默认播放
    static var AutoSwitch :Int = 0 //自动设置
    
    static var FajrTime :Int = 60     // 手动更正 成礼(计算的时候 - 60)
    static var SunriseTime :Int = 60  // 日出
    static var DhuhrTime :Int = 60    // 响礼
    static var AsrTime :Int = 60      // 普礼
    static var MaghribTime :Int = 60  //昏礼
    static var IshaaTime :Int = 60    //宵礼
    
    static var Longitude :Double  = 0 //经度
    static var Latitude :Double = 0 //纬度
    static var CityName :NSString = "" //城市名称
    static var CountryCode :Int = 21; //国家代码
    static var Url : String = "" //默认url
    
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
        
        getFajrTime()
        getSunriseTime()
        getDhuhrTime()
        getAsrTime()
        getMaghribTime()
        getIshaaTime()
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
    
    /**成礼*/
    static func saveFajrTime(pos :Int) {
        UserDefaultsUtil.saveInt("FajrTime", value: pos)
        FajrTime = pos
    }
    static func getFajrTime() ->Int{
        FajrTime  = UserDefaultsUtil.getInt("FajrTime",defalt: 60)
        return FajrTime
    }
    
    /**日出*/
    static func saveSunriseTime(pos :Int) {
        UserDefaultsUtil.saveInt("SunriseTime", value: pos)
        SunriseTime = pos
    }
    static func getSunriseTime() ->Int{
        SunriseTime  = UserDefaultsUtil.getInt("SunriseTime",defalt: 60)
        return SunriseTime
    }
    
    /**响礼*/
    static func saveDhuhrTime(pos :Int) {
        UserDefaultsUtil.saveInt("DhuhrTime", value: pos)
        DhuhrTime = pos
    }
    static func getDhuhrTime() ->Int{
        DhuhrTime  = UserDefaultsUtil.getInt("DhuhrTime",defalt: 60)
        return DhuhrTime
    }
    
    /**普礼*/
    static func saveAsrTime(pos :Int) {
        UserDefaultsUtil.saveInt("AsrTime", value: pos)
        AsrTime = pos
    }
    static func getAsrTime() ->Int{
        AsrTime  = UserDefaultsUtil.getInt("AsrTime",defalt: 60)
        return AsrTime
    }
    
    /**昏礼*/
    static func saveMaghribTime(pos :Int) {
        UserDefaultsUtil.saveInt("MaghribTime", value: pos)
        MaghribTime = pos
    }
    static func getMaghribTime() ->Int{
        MaghribTime  = UserDefaultsUtil.getInt("MaghribTime",defalt: 60)
        return MaghribTime
    }
    
    /**宵礼*/
    static func saveIshaaTime(pos :Int) {
        UserDefaultsUtil.saveInt("IshaaTime", value: pos)
        IshaaTime = pos
    }
    static func getIshaaTime() ->Int{
        IshaaTime  = UserDefaultsUtil.getInt("IshaaTime",defalt: 60)
        return IshaaTime
    }
    
    /**默认url*/
    static func saveUrl(url : String) {
        UserDefaultsUtil.saveString("defaultUrl", value: url)
        Url = url
    }
    static func getUrl() -> String {
        Url = UserDefaultsUtil.getString("defaultUrl")
        return Url
    }
    
    
    /**获取当前读者*/
    static func getCurrentReader() ->String{
        if(faction == FACTION_SHIA){
            return QuranAudioReaderIran[getCurrentReaderIndex()] as! String
        }else{
            return QuranAudioReader[getCurrentReaderIndex()] as! String
        }
    }
    
    static func saveCurrentReaderIndex(pos :Int){
        if(faction == FACTION_SHIA){
            UserDefaultsUtil.saveInt("CurrentReader_shia", value: pos)
        }else{
            UserDefaultsUtil.saveInt("CurrentReader_suni", value: pos)
        }
    }
    
    static func getCurrentReaderIndex()->Int{
        if(faction == FACTION_SHIA){
            return UserDefaultsUtil.getInt("CurrentReader_shia",defalt: 0)
        }else{
            return UserDefaultsUtil.getInt("CurrentReader_suni",defalt: 0)
        }
    }
    
    
    
    
    
    /**祈祷时间数组*/
    static let PrayNameArray : NSArray  = [
        NSLocalizedString("prayer_names_generic_1", comment:""),
        NSLocalizedString("prayer_names_generic_2", comment:""),
        NSLocalizedString("prayer_names_generic_3", comment:""),
        NSLocalizedString("prayer_names_generic_4", comment:""),
        NSLocalizedString("prayer_names_generic_5", comment:""),
        NSLocalizedString("prayer_names_generic_6", comment:"")
    ]
    
    /**午后祈祷（Asr）计算*/
    static let CalculationMethodsArray : NSArray  = [
        NSLocalizedString("SETTINGS_ASR_JURISTIC_HANAFI", comment:""),
        NSLocalizedString("SETTINGS_ASR_JURISTIC_STANDARD", comment:"")
    ]
    
    /***礼拜时间约定数组*/
    static let PrayerNameArray : NSArray  = [
        NSLocalizedString("SETTINGS_CALCULATION_IA", comment:""),
        NSLocalizedString("SETTINGS_CALCULATION_UISK", comment:""),
        NSLocalizedString("SETTINGS_CALCULATION_ISNA", comment:""),
        NSLocalizedString("SETTINGS_CALCULATION_WML", comment:""),
        NSLocalizedString("SETTINGS_CALCULATION_UAQM", comment:""),
        NSLocalizedString("SETTINGS_CALCULATION_EGAS", comment:""),
        NSLocalizedString("SETTINGS_CALCULATION_IGUT", comment:"")
    ]
    
    /**高维度调整数组*/
    static let HighLatitudeArray : NSArray  = [
        NSLocalizedString("setting_higher_latitude_dlg_none", comment:""),
        NSLocalizedString("setting_higher_latitude_dlg_middle_night", comment:""),
        NSLocalizedString("setting_higher_latitude_dlg_seven", comment:""),
        NSLocalizedString("setting_higher_latitude_dlg_angle_based", comment:"")
    ]
    
    /**时间格式数组*/
    static let TimeFormatArray : NSArray  = [
        NSLocalizedString("setting_time_format_Twenty_four", comment:""),
        NSLocalizedString("setting_time_format_twelve", comment:"")
    ]

    /**日历数组*/
    static let IslamicCalendarArray : NSArray  = [
        NSLocalizedString("islamic_calendar", comment:""),
        NSLocalizedString("persian_calendar", comment:"")
    ]
    
    /**逊尼派读者*/
    static let QuranAudioReader : NSArray  = [
        "Alafasy","Abdelbasset Abdessamad","Abdul Rahman Al_Sudais","Abdullah Ibn Ali Basfar",
        "Ahmed Nuinaa","Ali Hajjaj Souissi","Fares Abbad","Ai Al Hudhaify","Hani Al Rifai",
        "Khalifa Al Tunaiji","Mahmoud Ali Al Banna","Mohammad Al Tablaway","Saad Al Ghamadi",
        "Saood ash Shuraym","Shahriar Parhizgar","Karim Masnsoori","Menshawi"
    ]
    
    /**什叶派读者*/
    static let QuranAudioReaderIran : NSArray  = [
       "Abdelbasset Abdessamad","Ahmed Nuinaa","Ali Hajjaj Souissi","Mohammad Al Tablaway",
        "Shahriar Parhizgar","Karim Masnsoori","Menshawi"
    ]
    
    /***真主姓名*/
    static let AllahNames : NSArray  = [
        NSLocalizedString("allah_name1", comment:""),
        NSLocalizedString("allah_name2", comment:""),
        NSLocalizedString("allah_name3", comment:""),
        NSLocalizedString("allah_name4", comment:""),
        NSLocalizedString("allah_name5", comment:""),
        NSLocalizedString("allah_name6", comment:""),
        NSLocalizedString("allah_name7", comment:""),
        NSLocalizedString("allah_name8", comment:""),
        NSLocalizedString("allah_name9", comment:""),
        NSLocalizedString("allah_name10", comment:""),
        NSLocalizedString("allah_name11", comment:""),
        NSLocalizedString("allah_name12", comment:""),
        NSLocalizedString("allah_name13", comment:""),
        NSLocalizedString("allah_name14", comment:""),
        NSLocalizedString("allah_name15", comment:""),
        NSLocalizedString("allah_name16", comment:""),
        NSLocalizedString("allah_name17", comment:""),
        NSLocalizedString("allah_name18", comment:""),
        NSLocalizedString("allah_name19", comment:""),
        NSLocalizedString("allah_name20", comment:""),
        NSLocalizedString("allah_name21", comment:""),
        NSLocalizedString("allah_name22", comment:""),
        NSLocalizedString("allah_name23", comment:""),
        NSLocalizedString("allah_name24", comment:""),
        NSLocalizedString("allah_name25", comment:""),
        NSLocalizedString("allah_name26", comment:""),
        NSLocalizedString("allah_name27", comment:""),
        NSLocalizedString("allah_name28", comment:""),
        NSLocalizedString("allah_name29", comment:""),
        NSLocalizedString("allah_name30", comment:""),
        NSLocalizedString("allah_name31", comment:""),
        NSLocalizedString("allah_name32", comment:""),
        NSLocalizedString("allah_name33", comment:""),
        NSLocalizedString("allah_name34", comment:""),
        NSLocalizedString("allah_name35", comment:""),
        NSLocalizedString("allah_name36", comment:""),
        NSLocalizedString("allah_name37", comment:""),
        NSLocalizedString("allah_name38", comment:""),
        NSLocalizedString("allah_name39", comment:""),
        NSLocalizedString("allah_name40", comment:""),
        NSLocalizedString("allah_name41", comment:""),
        NSLocalizedString("allah_name42", comment:""),
        NSLocalizedString("allah_name43", comment:""),
        NSLocalizedString("allah_name44", comment:""),
        NSLocalizedString("allah_name45", comment:""),
        NSLocalizedString("allah_name46", comment:""),
        NSLocalizedString("allah_name47", comment:""),
        NSLocalizedString("allah_name48", comment:""),
        NSLocalizedString("allah_name49", comment:""),
        NSLocalizedString("allah_name50", comment:""),
        NSLocalizedString("allah_name51", comment:""),
        NSLocalizedString("allah_name52", comment:""),
        NSLocalizedString("allah_name53", comment:""),
        NSLocalizedString("allah_name54", comment:""),
        NSLocalizedString("allah_name55", comment:""),
        NSLocalizedString("allah_name56", comment:""),
        NSLocalizedString("allah_name57", comment:""),
        NSLocalizedString("allah_name58", comment:""),
        NSLocalizedString("allah_name59", comment:""),
        NSLocalizedString("allah_name60", comment:""),
        NSLocalizedString("allah_name61", comment:""),
        NSLocalizedString("allah_name62", comment:""),
        NSLocalizedString("allah_name63", comment:""),
        NSLocalizedString("allah_name64", comment:""),
        NSLocalizedString("allah_name65", comment:""),
        NSLocalizedString("allah_name66", comment:""),
        NSLocalizedString("allah_name67", comment:""),
        NSLocalizedString("allah_name68", comment:""),
        NSLocalizedString("allah_name69", comment:""),
        NSLocalizedString("allah_name70", comment:""),
        NSLocalizedString("allah_name71", comment:""),
        NSLocalizedString("allah_name72", comment:""),
        NSLocalizedString("allah_name73", comment:""),
        NSLocalizedString("allah_name74", comment:""),
        NSLocalizedString("allah_name75", comment:""),
        NSLocalizedString("allah_name76", comment:""),
        NSLocalizedString("allah_name77", comment:""),
        NSLocalizedString("allah_name78", comment:""),
        NSLocalizedString("allah_name79", comment:""),
        NSLocalizedString("allah_name80", comment:""),
        NSLocalizedString("allah_name81", comment:""),
        NSLocalizedString("allah_name82", comment:""),
        NSLocalizedString("allah_name83", comment:""),
        NSLocalizedString("allah_name84", comment:""),
        NSLocalizedString("allah_name85", comment:""),
        NSLocalizedString("allah_name86", comment:""),
        NSLocalizedString("allah_name87", comment:""),
        NSLocalizedString("allah_name88", comment:""),
        NSLocalizedString("allah_name89", comment:""),
        NSLocalizedString("allah_name90", comment:""),
        NSLocalizedString("allah_name91", comment:""),
        NSLocalizedString("allah_name92", comment:""),
        NSLocalizedString("allah_name93", comment:""),
        NSLocalizedString("allah_name94", comment:""),
        NSLocalizedString("allah_name95", comment:""),
        NSLocalizedString("allah_name96", comment:""),
        NSLocalizedString("allah_name97", comment:""),
        NSLocalizedString("allah_name98", comment:""),
        NSLocalizedString("allah_name99", comment:""),
    ]

    
}
