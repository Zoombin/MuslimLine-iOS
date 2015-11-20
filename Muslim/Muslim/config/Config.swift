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
        
        /**当前语言**/
        static func getCurrentLanguage() ->String{
            return QuranTranslationValues[getCurrentLanguageIndex()] as! String
        }
        /**当前国家图标*/
        static func getCurrentCountryIcon() ->String{
              return QuranTranslationCountryIcon[getCurrentLanguageIndex()] as! String
        }
        
        static func saveCurrentLanguageIndex(pos :Int){
            UserDefaultsUtil.saveInt("CurrentCountry", value: pos)
        }
        
        static func getCurrentLanguageIndex()->Int{
            return UserDefaultsUtil.getInt("CurrentCountry",defalt: 0)
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
        
        
        
        /***--------------------------- 译文 ------------------------------***/
        //start
        static let QuranTranslationActors : NSArray  = [
            "Efendi Nahi",
            "Feti Mehdiu",
            "Sherif Ahmeti",
            "At Mensur",
            "تفسير الجلالين",
            "تفسير المیسر",
            "ሳዲቅ &amp; ሳኒ ሐቢብ",
            "Məmmədəliyev &amp; Bünyadov",
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
            "Hilali &amp; Khan",
            "Itani",
            "Maududi",
            "Mubarakpuri",
            "Pickthall",
            "Qarai",
            "Qaribullah &amp; Darwish",
            "Saheeh International",
            "Sarwar",
            "Shakir",
            "Transliteration",
            "Wahiduddin Khan",
            "Yusuf Ali",
            "Hamidullah",
            "Abu Rida",
            "Bubenheim &amp; Elyas",
            "Khoury",
            "Zaidan",
            "Gumi",
            "फ़ारूक़ ख़ान &amp; अहमद",
            "फ़ारूक़ ख़ान &amp; नदवी",
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