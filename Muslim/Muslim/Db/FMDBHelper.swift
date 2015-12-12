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
        let path = FileUtils.documentsDirectory() + "/" + DBConstants.DB_NAME
        //是否存在
        if(!NSFileManager.defaultManager().fileExistsAtPath (path)){
            let dbZipPath = NSBundle.mainBundle().pathForResource(DBConstants.DB_ZIP_NAME, ofType: "zip")
            //解压zip包
            ZipUtils.unZipFile(dbZipPath!, unzipPath: FileUtils.documentsDirectory())
        }
        self.dbPath = path
        Log.printLog(dbPath)
        //创建数据库
        dbBase =  FMDatabase(path: self.dbPath as String)
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
    
    //根据id获取古兰经章节
    func getChapter(sura:Int) ->Chapter? {
        let sql:String = String(format:"SELECT * FROM %@ WHERE sura=%d", DBConstants.TB_CHAPTERS,sura)
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
        if(array.count > 0){
            return array[0] as? Chapter
        }
        return nil
    }
    
    //获取古兰经
    func searchQurans(str : String,chapterSectionNumber : NSMutableArray) ->NSMutableArray{
        let chapterNum:Int = chapterSectionNumber[0] as! Int
        let sectionNum:Int = chapterSectionNumber[1] as! Int
        
        let replaceStr:String = str.stringByReplacingOccurrencesOfString("\'", withString: "")
        let curLanguage :NSString = Config.getCurrentLanguage()
        
        var sql : String!
        if( chapterNum != -1 && sectionNum == -1){
            // 显示全部小节
             if(curLanguage.length == 0){
                sql = "select a.aya, a.sura, a.text, '' as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.sura  =" + String(chapterNum)
            } else {
                sql = "select a.aya, a.sura, a.text, b.[text] as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a left join " + String(curLanguage) + " b on a.[sura]=b.sura and a.aya=b.aya " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.sura  =" + String(chapterNum)
            }
        }else if(chapterNum != -1 && sectionNum != -2){
            // 不显示全部
            if(curLanguage.length == 0){
                sql = "select a.aya, a.sura, a.text, '' as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.sura  =" + String(chapterNum) + " and a.aya = " + String(sectionNum)
            }else{
                sql = "select a.aya, a.sura, a.text, b.[text] as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a left join " + String(curLanguage) + " b on a.[sura]=b.sura and a.aya=b.aya " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.sura  =" + String(chapterNum) + " and a.aya = " + String(sectionNum)
            }
        }else if(chapterNum != -1 && sectionNum >= 1){
            // 正常搜索小节
            if(curLanguage.length == 0){
                sql = "select a.aya, a.sura, a.text, '' as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.sura  =" + String(chapterNum) + " and a.aya = " + String(sectionNum)
            }else{
                sql = "select a.aya, a.sura, a.text, b.[text] as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a left join " + String(curLanguage) + " b on a.[sura]=b.sura and a.aya=b.aya " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.sura  =" + String(chapterNum) + " and a.aya = " + String(sectionNum)
            }
        }else if(chapterNum == -1 && sectionNum == -1){
            // 正常搜索全部字符
            if(curLanguage.length == 0){
                sql = "select a.aya, a.sura, a.text, '' as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.text  like '%" + replaceStr + "%'"
            }else{
                sql = "select a.aya, a.sura, a.text, b.[text] as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a left join " + String(curLanguage) + " b on a.[sura]=b.sura and a.aya=b.aya " +
                    " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                    "where a.text  like '%" + replaceStr + "%' or b.text like '%" + replaceStr + "%'";
            }
        }
        
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        let array : NSMutableArray = NSMutableArray()
        if(rs != nil){
            while rs!.next() {
                let quran : Quran = Quran()
                quran.aya = Int(rs!.intForColumnIndex(0))
                quran.sura = Int(rs!.intForColumnIndex(1))
                quran.text = rs!.stringForColumnIndex(2)
                quran.text_zh = rs!.stringForColumnIndex(3)
                quran.isbookmark = rs!.intForColumnIndex(4) == 1 ? true : false
                array.addObject(quran)
            }
        }
        dbBase.close()
        return array
    }
    
    /**根据id获取古兰经*/
    func getQurans(sura:Int) ->NSMutableArray{
        let curLanguage :NSString = Config.getCurrentLanguage()
        var sql:String = ""
        if(curLanguage.length == 0){
            sql = "select a.aya, a.text, '' as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a " +
                " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                "where a.sura=" + String(sura)
        }else{
            sql = "select a.aya, a.text, b.[text] as text, case when c.id >0 then 1 else 0 end  as abc from quran_simple a left join " + String(curLanguage) + " b on a.[sura]=b.sura and a.aya=b.aya " +
                " left join bookmark c on a.[sura]=c.[sura] and a.aya=c.aya " +
                "where a.sura=" + String(sura)
        }
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        let array : NSMutableArray = NSMutableArray()
        while rs!.next() {
            let quran : Quran = Quran()
            quran.aya = Int(rs!.intForColumnIndex(0))
            quran.sura = Int(sura)
            quran.text = rs!.stringForColumnIndex(1)
            quran.text_zh = rs!.stringForColumnIndex(2)
            quran.isbookmark = rs!.intForColumnIndex(3) == 1 ? true : false
            array.addObject(quran)
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
    
    //是否有书签
    func isBookmark(sura:Int,aya:Int)->Bool{
        let sql:String = "select * from " + DBConstants.TB_BOOKMARK + " where sura=" + String(sura) + " and aya=" + String(aya)
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        while rs!.next() {
            dbBase.close()
            return true
        }
        dbBase.close()
        return false
    }
    
    //删除书签
    func deleteBookmark(sura:Int,aya:Int){
        let sql:String = "DELETE FROM "
            + DBConstants.TB_BOOKMARK
            + " WHERE " + DBConstants.Field_SURA + "=" + String(sura) + " AND " + DBConstants.Field_AYA + "=" + String(aya)
        dbBase.open()
        dbBase.executeStatements(sql)
        dbBase.close()
    }
    

    //插入书签
    func insertBookmark(sura:Int,aya:Int){
        let sql:String =  "INSERT INTO "
            + DBConstants.TB_BOOKMARK
            + "(" + DBConstants.Field_SURA + "," + DBConstants.Field_AYA + "," + DBConstants.Field_ADD_DATE + ") VALUES ("+String(sura)+","+String(aya)+","+String(Double(NSDate().timeIntervalSince1970 * 1000))+")"
        dbBase.open()
        dbBase.executeStatements(sql)
        dbBase.close()
    }
    

    //最小章节id
    func getMinSura() ->Int{
        let sql :String = String(format: "SELECT min(sura) FROM %@", DBConstants.TB_QURAN_SIMPLE)
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        while rs!.next() {
            let min = Int(rs!.intForColumnIndex(0))
            dbBase.close()
            return min
        }
        dbBase.close()
        return -1;
    }
    
    //最大章节id
    func getMaxSura() ->Int{
        let sql :String = String(format: "SELECT max(sura) FROM %@", DBConstants.TB_QURAN_SIMPLE)
        dbBase.open()
        let rs = try? dbBase.executeQuery(sql, values: nil)
        while rs!.next() {
            let max = Int(rs!.intForColumnIndex(0))
            dbBase.close()
            return max
        }
        dbBase.close()
        return -1;
    }

    

}
