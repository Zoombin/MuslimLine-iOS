//
//  DBConstants.swift
//  Muslim
//
//  Created by LSD on 15/11/17.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class DBConstants: NSObject {

    // 古兰经
    // 章节信息表
    static let TB_CHAPTERS :String = "chapters"
    // 卷信息表
    static let TB_JUZ :String = "juz"
    // 内容表（波斯文1）
    static let TB_QURAN_SIMPLE :String = "quran_simple"
    // 内容表（中文）
    static let TB_ZH_JIAN :String = "zh_jian"
    // 书签表
    static let TB_BOOKMARK :String = "bookmark"
    
    static let Field_SURA :String = "sura"
    static let Field_AYAS_COUNT :String = "ayas_count"
    static let Field_FIRST_AYA_ID :String = "first_aya_id"
    static let Field_NAME_ARABIC :String = "name_arabic"
    static let Field_NAME_TRANSLITERATION :String = "name_transliteration"
    static let Field_TYPE :String = "type"
    static let Field_REVELATION_ORDER :String = "revelation_order"
    static let Field_RUKUS :String = "rukus"
    static let Field_ID :String = "id"
    static let Field_AYA :String = "aya"
    static let Field_INDEX :String = "index"
    static let Field_TEXT :String = "text"
    static let Field_ADD_DATE :String = "add_date"
    
    // 附近位置
    // 位置表
    static let TB_LOCATIONS :String = "locations"
    
    static let FIELD_NAME :String = "name"
    static let FIELD_LATITUDE :String = "latitude"
    static let FIELD_LONGITUDE :String = "longitude"
    static let FIELD_ELEVATION :String = "elevation"
    static let FIELD_REGION :String = "region"
    static let FIELD_COUNTRY_CODE :String = "country_code"
    static let FIELD_COUNTRY_NAME :String = "country_name"
    static let FIELD_TIMEZONE :String = "timezone"
}
