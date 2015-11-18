//
//  FMDBHelper.swift
//  Muslim
//
//  Created by LSD on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class FMDBHelper: NSObject {
    var dbPath:String
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
//        let documentsFolder : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        var url : NSURL = NSURL.init(string: documentsFolder)!
//        url = url.URLByAppendingPathComponent("MuslimLine.sqlite")
//        self.dbPath = url.absoluteString
        
        let path = FileUtils.documentsDirectory() + "/" + DBConstants.DB_NAME
        //是否存在
        if(!NSFileManager.defaultManager().fileExistsAtPath (path)){
            let dbZipPath = NSBundle.mainBundle().pathForResource(DBConstants.DB_ZIP_NAME, ofType: "zip")
            //解压zip包
            ZipUtils.unZipFile(dbZipPath!, unzipPath: FileUtils.documentsDirectory())
        }
        self.dbPath = path
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
        let sql:String = String(format:"SELECT * FROM %@", DBConstants.TB_CHAPTERS)
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        let array : NSMutableArray = NSMutableArray()
        while rs!.next() {
            let chapter : Chapter = Chapter()
            chapter.sura = Int(rs!.intForColumn(DBConstants.Field_SURA))
            chapter.ayas_count = Int(rs!.intForColumn(DBConstants.Field_AYAS_COUNT))
            chapter.first_aya_id = Int(rs!.intForColumn(DBConstants.Field_FIRST_AYA_ID))
            chapter.name_arabic = rs!.stringForColumn(DBConstants.Field_NAME_ARABIC)
            chapter.name_transliteration = rs!.stringForColumn(DBConstants.Field_NAME_TRANSLITERATION)
            chapter.type = rs!.stringForColumn(DBConstants.Field_TYPE)
            chapter.revelation_order = Int(rs!.intForColumn(DBConstants.Field_REVELATION_ORDER))
            chapter.rukus = Int(rs!.intForColumn(DBConstants.Field_RUKUS))
            array.addObject(chapter)
        }
        dbBase.close()
        return array
    }
    
    //获取书签数据
    func getBookmarks()->NSMutableArray{
        let sql:String = "select a.id, a.sura, a.aya, a.add_date, b.name_arabic, b.name_transliteration " +
            "from bookmark a left join chapters b " +
            "on a.[sura] = b.[sura] " +
        "order by a.add_date desc"
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        let array : NSMutableArray = NSMutableArray()
        while rs!.next() {
            let bookmark : Bookmark = Bookmark()
            bookmark.id = Int(rs!.intForColumnIndex(0))
            bookmark.suraId = Int(rs!.intForColumnIndex(1))
            bookmark.ayaId = Int(rs!.intForColumnIndex(2))
            bookmark.add_date = NSNumber(long: rs!.longForColumnIndex(3))
            bookmark.suraName = rs!.stringForColumnIndex(4)
            bookmark.transliteration = rs!.stringForColumnIndex(5)
            array.addObject(bookmark)
        }
        dbBase.close()
        return array
    }


}
