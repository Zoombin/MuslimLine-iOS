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

    static let PrayerName :NSInteger = 0
    static let FajrTime :NSInteger = 0
    static let SunriseTime :NSInteger = 0
    static let DhuhrTime :NSInteger = 0
    static let AsrTime :NSInteger = 0
    static let MaghribTime :NSInteger = 0
    static let IshaaTime :NSInteger = 0
    
    
    static let CalculationMethods :NSInteger = 0
    static let JuristicMethods :NSInteger = 0
    static let HighLatitude :NSInteger = 0
    static let Daylight :NSInteger = 0
    static let TimeFormat :NSInteger = 0
    static let SlinetMode :NSInteger = 0
    static let AutoSwitch :NSInteger = 0
    
    /**启动获取配置数据*/
    static func initData(){
        
    }
    /**清除配置数据*/
    static func cleanData(){
    
    }
    
    static func savePrayerName(pos:NSInteger) {
        UserDefaultsUtil.saveInt("PrayerName", value: pos)
    }
    
//    public static void saveFajrTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("FajrTime", pos);
//    FajrTime = pos;
//    
//    }
//    
//    public static void saveSunriseTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("SunriseTime", pos);
//    SunriseTime = pos;
//    
//    }
//    
//    public static void saveDhuhrTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("DhuhrTime", pos);
//    DhuhrTime = pos;
//    
//    }
//    
//    public static void saveAsrTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("AsrTime", pos);
//    AsrTime = pos;
//    
//    }
//    
//    public static void saveMaghribTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("MaghribTime", pos);
//    MaghribTime = pos;
//    
//    }
//    
//    public static void saveIshaaTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("IshaaTime", pos);
//    IshaaTime = pos;
//    
//    }
//    
//    public static void saveAsrCalculationjuristicMethod(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("CalculationjuristicMethod", pos);
//    CalculationMethods = pos;
//    }
//    
//    public static void savePrayerTimeConventions(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("PrayerTimeConventions", pos);
//    JuristicMethods = pos;
//    }
//    
//    public static void saveHighLatitudeAdjustment(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("HighLatitudeAdjustment", pos);
//    HighLatitude = pos;
//    }
//    
//    public static void saveDaylightSavingTime(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("DaylightSavingTime", pos);
//    Daylight = pos;
//    }
//    
//    public static void saveTimeFormat(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("TimeFormat", pos);
//    TimeFormat = pos;
//    }
//    
//    public static void saveSlientMode(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("SlientMode", pos);
//    SlinetMode = pos;
//    }
//    
//    public static void saveAutoSwitch(int pos) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveInt("AutoSwitch", pos);
//    AutoSwitch = pos;
//    }
//    
//    public static void saveCalenderSelection(boolean flag) {
//    PreferenceUitl.getInstance(MuslinApplication.getContext()).saveBoolean("Calender", flag);
//    IsIslamicCalendar = flag;
//    }
//    
//    public static int getFajrTime(Context context) {
//    return FajrTime = PreferenceUitl.getInstance(context).getInt("FajrTime", 60);
//    
//    
//    }
//    
//    public static int getSunriseTime(Context context) {
//    return SunriseTime = PreferenceUitl.getInstance(context).getInt("SunriseTime", 60);
//    
//    
//    }
//    
//    public static int getDhuhrTime(Context context) {
//    return DhuhrTime = PreferenceUitl.getInstance(context).getInt("DhuhrTime", 60);
//    
//    
//    }
//    
//    public static int getAsrTime(Context context) {
//    return AsrTime = PreferenceUitl.getInstance(context).getInt("AsrTime", 60);
//    
//    
//    }
//    
//    public static int getMaghribTime(Context context) {
//    return MaghribTime = PreferenceUitl.getInstance(context).getInt("MaghribTime", 60);
//    
//    
//    }
//    
//    public static int getIshaaTime(Context context) {
//    return IshaaTime = PreferenceUitl.getInstance(context).getInt("IshaaTime", 60);
//    
//    }
//    
//    public static int getAsrCalculationjuristicMethod(Context context) {
//    return CalculationMethods = PreferenceUitl.getInstance(context).getInt("CalculationjuristicMethod", 0);
//    }
//    
//    public static int getPrayerTimeConventions(Context context) {
//    return JuristicMethods = PreferenceUitl.getInstance(context).getInt("PrayerTimeConventions", 3);
//    
//    }
//    
//    public static int getHighLatitudeAdjustment(Context context) {
//    return HighLatitude = PreferenceUitl.getInstance(context).getInt("HighLatitudeAdjustment", 3);
//    
//    }
//    
//    public static int getDaylightSavingTime(Context context) {
//    return Daylight = PreferenceUitl.getInstance(context).getInt("DaylightSavingTime", 0);
//    
//    }
//    
//    public static int getTimeFormat(Context context) {
//    return TimeFormat = PreferenceUitl.getInstance(context).getInt("TimeFormat", 0);
//    }
//    
//    public static int getSlinetMode(Context context) {
//    return SlinetMode = PreferenceUitl.getInstance(context).getInt("SlientMode", 1);
//    }
//    
//    public static int getAutoSwitch(Context context) {
//    
//    return AutoSwitch = PreferenceUitl.getInstance(context).getInt("AutoSwitch", 0);
//    }
//    
//    public static boolean getCalenderSelection(Context context) {
//    return IsIslamicCalendar = PreferenceUitl.getInstance(context).getBoolean("Calender", true);
//    }
    
}
