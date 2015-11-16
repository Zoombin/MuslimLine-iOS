//
//  FMDBHelper.swift
//  Muslim
//
//  Created by LSD on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class FMDBHelper: NSObject {
    
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
    
    }


}
