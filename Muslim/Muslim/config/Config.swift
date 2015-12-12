    //
    //  Config.swift
    //  Muslim
    //
    //  Created by LSD on 15/11/6.
    //  Copyright © 2015年 ZoomBin. All rights reserved.
    //

    import UIKit

    class Config: NSObject {
        static let COUNTRY_IRAN : String = "Iran";
        static let COUNTRY_IRAQ : String = "Iraq";
        // 什叶派
        static let FACTION_SHIA :NSInteger = 0;
        // 逊尼派
        static let FACTION_SUNI :NSInteger = 1;
        
        static var faction : Int = 0 //穆斯林派别
        static var PrayerTimeConvention :Int = 0 //礼拜时间约定
        static var IsIslamicCalendar:Int = 0//日历选择
        static var CalculationMethods :Int = 0 //祈祷时间算法
        static var HighLatitude :Int = 0 //高纬度调整
        static var Daylight :Int = 0 //夏令日
        static var TimeFormat :Int = 0 //时间格式
        static var SlinetMode :Int = 0 //默认播放
        static var AutoSwitch :Int = 0 //自动设置
        
        static var Longitude :Double  = 0 //经度
        static var Latitude :Double = 0 //纬度
        static var CityName :NSString = "" //城市名称
        static var CountryCode :Int = 21; //国家代码
        static var Url : String = "" //默认url
        
        /**启动获取配置数据*/
        static func initData(){
            getFaction()
            getAsrCalculationjuristicMethod()
            getPrayerTimeConventions()
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
        
        /**删除首页的数据*/
        static func clearHomeValues() {
            UserDefaultsUtil.removeForKey("Timezone")
            UserDefaultsUtil.removeForKey("countryName")
            UserDefaultsUtil.removeForKey("cityName")
            UserDefaultsUtil.removeForKey("latValue")
            UserDefaultsUtil.removeForKey("lngValue")
        }
        
        /**保存时区*/
        static func saveTimeZone(zone : String) {
            UserDefaultsUtil.saveString("Timezone", value: zone)
        }
        
        /**获得时区*/
        static func getTimeZone() -> String {
            return UserDefaultsUtil.getString("Timezone")
        }
        
        /**保存国家名称*/
        static func savecountryName(countryName : String) {
            UserDefaultsUtil.saveString("countryName", value: countryName)
        }
        
        /**获取国家代码*/
        static func getcountryName() -> String {
            return UserDefaultsUtil.getString("countryName")
        }
        
        /**保存城市名*/
        static func saveCityName(cityName : String) {
            UserDefaultsUtil.saveString("cityName", value: cityName)
        }
        
        /**获得城市名*/
        static func getCityName() -> String {
            return UserDefaultsUtil.getString("cityName")
        }
        
        /**保存经度*/
        static func saveLat(lat : NSNumber) {
            UserDefaultsUtil.saveNumber("latValue", value: lat)
        }
        
        /**获取经度*/
        static func getLat() -> NSNumber {
            return UserDefaultsUtil.getNumber("latValue")
        }
        
        /**保存纬度*/
        static func saveLng(lng : NSNumber) {
            UserDefaultsUtil.saveNumber("lngValue", value: lng)
        }
        
        /**获取纬度*/
        static func getLng() -> NSNumber {
            return UserDefaultsUtil.getNumber("lngValue")
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
        static func savePrayerTimeConventions(pos :Int) {
            UserDefaultsUtil.saveInt("PrayerTimeConventions", value: pos)
            PrayerTimeConvention = pos
        }
        static func getPrayerTimeConventions()-> Int {
            PrayerTimeConvention = UserDefaultsUtil.getInt("PrayerTimeConventions")
            return PrayerTimeConvention
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
        
        static func getCalenderType() -> String{
            let selection : Int = self.getCalenderSelection()
            if (selection == 0) { //伊斯兰
                return NSCalendarIdentifierIslamicCivil
            } else { //波斯
                return NSCalendarIdentifierPersian
            }
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
        
        /**响礼调整时间*/ //-- 保存的是位置，时间需要减去默认值 60
        static func saveAdjustPray(mediaType:Int,pos :Int) {
            UserDefaultsUtil.saveInt(String(format: "AdjustPray_%d", mediaType),value: pos)
        }
        static func getAdjustPray(mediaType:Int) ->Int{
            return UserDefaultsUtil.getInt(String(format: "AdjustPray_%d", mediaType),defalt: 60)
        }
        
        /**最终设置的礼拜时间**/
        static func savePrayTime(mediaType:Int,time :String) {
            UserDefaultsUtil.saveString(String(format: "PrayTime_%d", mediaType),value: time)
        }
        static func getPrayTime(mediaType:Int) ->String{
            return UserDefaultsUtil.getString(String(format: "PrayTime_%d", mediaType))
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
        
        /**当前语言**/
        static func getCurrentLanguage() ->String{
            let currentLanguageIndex = getCurrentLanguageIndex()
            if(-1 == currentLanguageIndex){
                return ""
            }else{
                return QuranTranslationValues[currentLanguageIndex] as! String
            }
        }
        /**当前国家图标*/
        static func getCurrentCountryIcon() ->String{
            let currentLanguageIndex = getCurrentLanguageIndex()
            if(-1 == currentLanguageIndex){
                return "ic_global"
            }else{
                return QuranTranslationCountryIcon[getCurrentLanguageIndex()] as! String
            }
        }
        
        static func saveCurrentLanguageIndex(pos :Int){
            UserDefaultsUtil.saveInt("CurrentCountry", value: pos)
        }
        
        static func getCurrentLanguageIndex()->Int{
            return UserDefaultsUtil.getInt("CurrentCountry",defalt: -1)
        }
        
        static func getTextShouldToRight() -> Bool{
            let tranlateIDS = [4, 5, 15, 53, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 79, 100, 101, 102, 103, 104, 105, 106, 107]
            let currentId : Int = getCurrentLanguageIndex()
            if (currentId == -1) {
                return false
            }
            for (var i = 0; i < tranlateIDS.count; i++) {
                let id = tranlateIDS[i]
                if (id == currentId) {
                    return true
                }
            }
            return false
        }
        
        /**当前阅读的古兰经**/
        static func setCurrentRura(currentSura:Int) {
           UserDefaultsUtil.saveInt("CurrentRura", value: currentSura)
        }
        
        static func getCurrentRura()->Int{
            return UserDefaultsUtil.getInt("CurrentRura",defalt: -1)
        }
        
        /**当前阅读位置*/
        static func getCurrentPosition()->Int {
          return UserDefaultsUtil.getInt("currentPosition")
        }
        
        static func setCurrentPosition(currentPosition:Int) {
            UserDefaultsUtil.saveInt("currentPosition", value:currentPosition)
        }
        
        /**逊尼派响里闹钟声音*/
        static func getSunniAlarm(alarmType:Int)->Int {
            return UserDefaultsUtil.getInt(String(format: "SunniAlarm_%d", alarmType))
        }
        static func setSunniAlarm(alarmType:Int,select:Int) {
            UserDefaultsUtil.saveInt(String(format: "SunniAlarm_%d", alarmType), value:select)
        }
        
        /**什叶派响里闹钟声音*/
        static func getShiaAlarm(alarmType:Int)->Int {
            return UserDefaultsUtil.getInt(String(format: "ShiaAlarm_%d", alarmType))
        }
        static func setShiaAlarm(alarmType:Int,select:Int) {
            UserDefaultsUtil.saveInt(String(format: "ShiaAlarm_%d", alarmType), value:select)
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
            "Shahriar Parhizgar","Alafasy","Abdelbasset Abdessamad","Abdul Rahman Al_Sudais","Abdullah Ibn Ali Basfar","Ahmed Nuinaa","Ali Hajjaj Souissi","Fares Abbad","Ai Al Hudhaify","Hani Al Rifai",
            "Khalifa Al Tunaiji","Mahmoud Ali Al Banna","Mohammad Al Tablaway","Saad Al Ghamadi",
            "Saood ash Shuraym","Karim Masnsoori","Menshawi"
        ]
        
        /**什叶派读者*/
        static let QuranAudioReaderIran : NSArray  = [
            "Shahriar Parhizgar","Abdelbasset Abdessamad","Ahmed Nuinaa","Ali Hajjaj Souissi","Mohammad Al Tablaway",
            "Karim Masnsoori","Menshawi"
        ]
        
        /**逊尼派闹钟*/
        static let alarm_type_sunni : NSArray  = [
            NSLocalizedString("adhan_alarm_type_slient", comment:""),
            NSLocalizedString("adhan_alarm_type_default", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_AMF", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ADHAN", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_AAB", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ADHAN_EGYPT", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_AFMZ", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ADHAN_HALAB", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_AMFIVE", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ADHAN_MAKKAH", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ANAQ", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ADHAN_SALIMI", comment:""),
            NSLocalizedString("SETTINGS_PRAYER_ALARM_ADHAN_SHARIF", comment:""),
        ]
         static let alarm_type_files_sunni : NSArray  = [
            "",
            "",
            "adhan_fajr_madina_ios.mp3",
            "adhan_1_ios.mp3",
            "adhan_abdul_baset_ios.mp3",
            "adhan_egypt_ios.mp3",
            "adhan_fajr_mansour_zahrani_ios.mp3",
            "adhan_halab_ios.mp3",
            "adhan_madina_1952_ios.mp3",
            "adhan_makkah_ios.mp3",
            "adhan_nasser_al_qatami_ios.mp3",
            "adhan_salimi_ios.mp3",
            "adhan_sharif_ios.mp3"
        ]
        
        /**什叶派闹钟*/
        static let alarm_type_shia : NSArray  = [
            NSLocalizedString("adhan_alarm_type_slient", comment:""),
            NSLocalizedString("adhan_alarm_type_default", comment:""),
            "Aghati",
            "Adhan Entezar",
            "Hazin",
            "karami",
            "Rahim Moazenzadeh",
            "Saeidyan",
            "Salim Moazenzadeh",
            "Seyed Abas Mirdamad",
            "Sobhdel",
            "Tasvieh Chi",
            "Tukhi"
        ]
         static let alarm_type_files_shia : NSArray  = [
            "",
            "",
            "aghati_ios.mp3",
            "adhan_entezar_ios.mp3",
            "hazin_ios.mp3",
            "karami_ios.mp3",
            "rahim_moazenzadeh_ios.mp3",
            "saeidyan_ios.mp3",
            "salim-moazenzadeh_ios.mp3",
            "seyed_abas_mirdamad_ios.mp3",
            "sobhdel_ios.mp3",
            "tasvieh_chi_ios.mp3",
            "tukhi_ios.mp3"
        ]
        
        
        
        /***--------------------------- 译文 ------------------------------***/
        //start
        static let QuranTranslationActors : NSArray  = [
            "Efendi Nahi",
            "Feti Mehdiu",
            "Sherif Ahmeti",
            "At Mensur",
            "تفسير الجلالين",
            "تفسير المیسر",
            "ሳዲቅ & ሳኒ ሐቢብ",
            "Məmmədəliyev & Bünyadov",
            "Musayev",
            "জহুরুল হক",
            "মুহিউদ্দীন খান",
            "Korkut",
            "Mlivo",
            "Теофанов",
            "Ma Jian",
            "محمد صالح",
            "Ma Jian (Traditional)",
            "Hrbek",
            "Nykl",
            "Keyzer",
            "Leemhuis",
            "Siregar",
            "Ahmed Ali",
            "Ahmed Raza Khan",
            "Arberry",
            "Daryabadi",
            "Hilali & Khan",
            "Itani",
            "Maududi",
            "Mubarakpuri",
            "Pickthall",
            "Qarai",
            "Qaribullah & Darwish",
            "Saheeh International",
            "Sarwar",
            "Shakir",
            "Transliteration",
            "Wahiduddin Khan",
            "Yusuf Ali",
            "Hamidullah",
            "Abu Rida",
            "Bubenheim & Elyas",
            "Khoury",
            "Zaidan",
            "Gumi",
            "फ़ारूक़ ख़ान & अहमद",
            "फ़ारूक़ ख़ान & नदवी",
            "Bahasa Indonesia",
            "Quraish Shihab",
            "Tafsir Jalalayn",
            "Piccardo",
            "未知の作家",
            "알 수없는 저자",
            "ته‌فسیری ئاسان",
            "Basmeih",
            "Muhammad Farooq Khan",
            "Suhel Farooq Khan",
            "Einar Berg",
            "الهی قمشه‌ای",
            "انصاریان",
            "آیتی",
            "بهرام پور",
            "خرمدل",
            "خرمشاهی",
            "صادقی تهرانی",
            "فولادوند",
            "مجتبوی",
            "معزی",
            "مکارم شیرازی",
            "Bielawskiego",
            "El-Hayek",
            "Grigore",
            "Абу Адель",
            "Аль-Мунтахаб",
            "Крачковский",
            "Кулиев",
            "Османов",
            "Порохова",
            "Саблуков",
            "امروٽي",
            "Abduh",
            "Bornez",
            "Cortes",
            "Garcia",
            "Al-Barwani",
            "Bernström",
            "Оятӣ",
            "ஜான் டிரஸ்ட்",
            "Yakub Ibn Nugman",
            "ภาษาไทย",
            "Abdulbakî Gölpınarlı",
            "Alİ Bulaç",
            "Çeviriyazı",
            "Diyanet İşleri",
            "Diyanet Vakfı",
            "Edip Yüksel",
            "Elmalılı Hamdi Yazır",
            "Öztürk",
            "Suat Yıldırım",
            "Süleyman Ateş",
            "ابوالاعلی مودودی",
            "احمد رضا خان",
            "احمد علی",
            "جالندہری",
            "طاہر القادری",
            "علامہ جوادی",
            "محمد جوناگڑھی",
            "محمد حسین نجفی",
            "Мухаммад Содик"
        ]
        
        
        static let QuranTranslationEntries : NSArray  = [
            "Shqiptar",
            "Shqiptar",
            "Shqiptar",
            "Amazigh",
            "عربي",
            "عربي",
            "Amharic",
            "Azərbaycan",
            "Azərbaycan",
            "বাঙালি",
            "বাঙালি",
            "Bosanski",
            "Bosanski",
            "български",
            "简体中文",
            "Uyghur",
            "繁體中文",
            "čeština",
            "čeština",
            "nederlands",
            "nederlands",
            "nederlands",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "English",
            "français",
            "Deutsch",
            "Deutsch",
            "Deutsch",
            "Deutsch",
            "Hausa",
            "हिंदी",
            "हिंदी",
            "Bahasa Indonesia",
            "Bahasa Indonesia",
            "Bahasa Indonesia",
            "Italiano",
            "日本語",
            "한국어",
            "Kurdish",
            "Malay",
            "Malayalam",
            "Malayalam",
            "Norsk",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "فارسی",
            "Polish",
            "Português",
            "Română",
            "Русский",
            "Русский",
            "Русский",
            "Русский",
            "Русский",
            "Русский",
            "Русский",
            "Sindhi",
            "Somali",
            "Español",
            "Español",
            "Español",
            "Swahili",
            "Svensk",
            "тоҷик",
            "தமிழ்",
            "Tatar",
            "ภาษาไทย",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "Türkçe",
            "اردو",
            "اردو",
            "اردو",
            "اردو",
            "اردو",
            "اردو",
            "اردو",
            "اردو",
            "Uzbek"
        ]
        
        static let QuranTranslationValues : NSArray  = [
            "sq_nahi",
            "sq_mehdiu",
            "sq_ahmeti",
            "ber_mensur",
            "ar_jalalayn",
            "ar_muyassar",
            "am_sadiq",
            "az_mammadaliyev",
            "az_musayev",
            "bn_hoque",
            "bn_bengali",
            "bs_korkut",
            "bs_mlivo",
            "bg_theophanov",
            "zh_jian",
            "ug_saleh",
            "zh_majian",
            "cs_hrbek",
            "cs_nykl",
            "nl_keyzer",
            "nl_leemhuis",
            "nl_siregar",
            "en_ahmedali",
            "en_ahmedraza",
            "en_arberry",
            "en_daryabadi",
            "en_hilali",
            "en_itani",
            "en_maududi",
            "en_mubarakpuri",
            "en_pickthall",
            "en_qarai",
            "en_qaribullah",
            "en_sahih",
            "en_sarwar",
            "en_shakir",
            "en_transliteration",
            "en_wahiduddin",
            "en_yusufali",
            "fr_hamidullah",
            "de_aburida",
            "de_bubenheim",
            "de_khoury",
            "de_zaidan",
            "ha_gumi",
            "hi_farooq",
            "hi_hindi",
            "id_indonesian",
            "id_muntakhab",
            "id_jalalayn",
            "it_piccardo",
            "ja_japanese",
            "ko_korean",
            "ku_asan",
            "ms_basmeih",
            "ml_abdulhameed",
            "ml_karakunnu",
            "no_berg",
            "fa_ghomshei",
            "fa_ansarian",
            "fa_ayati",
            "fa_bahrampour",
            "fa_khorramdel",
            "fa_khorramshahi",
            "fa_sadeqi",
            "fa_fooladvand",
            "fa_mojtabavi",
            "fa_moezzi",
            "fa_makarem",
            "pl_bielawskiego",
            "pt_elhayek",
            "ro_grigore",
            "ru_abuadel",
            "ru_muntahab",
            "ru_krachkovsky",
            "ru_kuliev",
            "ru_osmanov",
            "ru_porokhova",
            "ru_sablukov",
            "sd_amroti",
            "so_abduh",
            "es_bornez",
            "es_cortes",
            "es_garcia",
            "sw_barwani",
            "sv_bernstrom",
            "tg_ayati",
            "ta_tamil",
            "tt_nugman",
            "th_thai",
            "tr_golpinarli",
            "tr_bulac",
            "tr_transliteration",
            "tr_diyanet",
            "tr_vakfi",
            "tr_yuksel",
            "tr_yazir",
            "tr_ozturk",
            "tr_yildirim",
            "tr_ates",
            "ur_maududi",
            "ur_kanzuliman",
            "ur_ahmedali",
            "ur_jalandhry",
            "ur_qadri",
            "ur_jawadi",
            "ur_junagarhi",
            "ur_najafi",
            "uz_sodik"
        ]
        
        
        static let QuranTranslationCountryIcon : NSArray  = [
        "albanian",
        "albanian",
        "albanian",
        "amazigh",
        "arabic",
        "arabic",
        "amharic",
        "azerbaijani",
        "azerbaijani",
        "bengali",
        "bengali",
        "bosnian",
        "bosnian",
        "bulgarian",
        "chinese",
        "chinese",
        "china",
        "czech",
        "czech",
        "dutch",
        "dutch",
        "dutch",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "english",
        "french",
        "german",
        "german",
        "german",
        "german",
        "hausa",
        "hindi",
        "hindi",
        "indonesian",
        "indonesian",
        "indonesian",
        "italian",
        "japanese",
        "korean",
        "kurdish",
        "malay",
        "malayalam",
        "malayalam",
        "norwegian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "persian",
        "polish",
        "portuguese",
        "romanian",
        "russian",
        "russian",
        "russian",
        "russian",
        "russian",
        "russian",
        "russian",
        "sindhi",
        "somali",
        "spanish",
        "spanish",
        "spanish",
        "swahili",
        "swedish",
        "tajik",
        "tamil",
        "tatar",
        "thai",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "turkish",
        "urdu",
        "urdu",
        "urdu",
        "urdu",
        "urdu",
        "urdu",
        "urdu",
        "urdu",
        "uzbek"
        ]
         //end
        
    }
