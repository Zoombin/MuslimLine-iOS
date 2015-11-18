//
//  ZipUtils.swift
//  Muslim
//
//  Created by LSD on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
//zip操作类
class ZipUtils: NSObject {
    
    /***读取zip文件*/
    static func readZipFile(zipPath:String)->String{
        let path = unZipFile(zipPath)
        return FileUtils.readFile(path as String)
      }
    
    /**解压文件*/
    static func unZipFile(zipPath:String)->String{
        guard let unzipPath = unZipPath() else {
            return ""
        }
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unzipPath)
        if !success {
            return ""
        }
        var items: [String]
        do {
            items = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(unzipPath)
            return unzipPath+"/"+items[0]
        } catch {
            return ""
        }
    }
    
    /***解压文件到制定路径*/
    static func unZipFile(zipPath:String,unzipPath:String)->String{
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unzipPath)
        if !success {
            return ""
        }
        return unzipPath
    }

    
    static func unZipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
}
