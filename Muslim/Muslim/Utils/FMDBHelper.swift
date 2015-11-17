//
//  FMDBHelper.swift
//  Muslim
//
//  Created by LSD on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class FMDBHelper: NSObject {
    // 古兰经
    // 章节信息表
    let TB_CHAPTERS : String = "chapters"
    
    let dbPath:String
    let dbBase:FMDatabase
    
    
    //单例化
    class func getInstance()->FMDBHelper{
        struct psSingle{
            static var onceToken:dispatch_once_t = 0;
            static var instance:FMDBHelper? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = FMDBHelper()
        })
        return psSingle.instance!
    }
    
    
    //创建数据库
    override init() {
        let documentsFolder : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        var url : NSURL = NSURL.init(string: documentsFolder)!
        url = url.URLByAppendingPathComponent("MuslimLine.sqlite")
        self.dbPath = url.absoluteString
        //创建数据库
        dbBase =  FMDatabase(path: self.dbPath as String)

        print("path: ---- \(self.dbPath)")
    }
    
    
    //执行SQL语句
    func executeSQLs(sql:String) {
        dbBase.open()
        let sqlArray : [String] = sql.componentsSeparatedByString(";\n")
        for em in sqlArray {
            dbBase.executeStatements(em)
        }
        dbBase.close()
    }
    
    //操作单个语句
    func executeSQL(sql:String) {
        dbBase.open()
        dbBase.executeStatements(sql)
        dbBase.close()
    }
    
    //获取古兰经章节  Chapter
    func getChapters() ->NSMutableArray {
        let dbpath = NSBundle.mainBundle().pathForResource("quran_v2", ofType: "db") //直接读项目里面的db文件
        let dbChapter:FMDatabase =  FMDatabase(path: dbpath! as String)
        
        let sql:String = String(format:"SELECT * FROM %@", TB_CHAPTERS)
        dbChapter.open()
        let rs = try? dbChapter.executeQuery(sql, values: nil)
        let array : NSMutableArray = NSMutableArray()
        while rs!.next() {
            let chapter : Chapter = Chapter()
            chapter.sura = Int(rs!.intForColumn("sura"))
            chapter.ayas_count = Int(rs!.intForColumn("ayas_count"))
            chapter.first_aya_id = Int(rs!.intForColumn("first_aya_id"))
            chapter.name_arabic = rs!.stringForColumn("name_arabic")
            chapter.name_transliteration = rs!.stringForColumn("name_transliteration")
            chapter.type = rs!.stringForColumn("type")
            chapter.revelation_order = Int(rs!.intForColumn("revelation_order"))
            chapter.rukus = Int(rs!.intForColumn("rukus"))
            array.addObject(chapter)
        }
        dbChapter.close()
        return array
    }


}
