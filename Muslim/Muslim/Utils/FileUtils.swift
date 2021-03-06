//
//  FileUtils.swift
//  Muslim
//
//  Created by LSD on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class FileUtils: NSObject {
    
    /**APP documents路径*/
    static func documentsDirectory() ->String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths.first! as String
        return documentsDirectory
    }
    
    /**读取路径下的文件内容*/
    static func readFile(path:String) ->String{
        let str : String = try! String(contentsOfFile: path)
        return str 
    }
    

}
