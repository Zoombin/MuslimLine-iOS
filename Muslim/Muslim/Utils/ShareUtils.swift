//
//  ShareUtils.swift
//  Muslim
//
//  Created by 颜超 on 15/12/1.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

protocol ShareUtilsDelegate : NSObjectProtocol {
    func appShareContent(content : String)
    func getAppShareContentFail()
}
class ShareUtils: NSObject, httpClientDelegate {
    
    var delegate : ShareUtilsDelegate?
    static var shareUtils : ShareUtils?
    let feedback = 0
    var httpClient : MSLHttpClient = MSLHttpClient()
    
    static func shared() -> ShareUtils {
        if (shareUtils == nil) {
            shareUtils = ShareUtils()
        }
        return shareUtils!
    }
    
    func getShareContent() {
        httpClient.delegate = self
        httpClient.getFeedBack(feedback)
    }
    
    func succssResult(result: NSObject, tag: NSInteger) {
        Log.printLog(result)
        if (tag == feedback) {
           let resultDict = result as! NSDictionary
            if (resultDict["retcode"]?.integerValue != 0) {
                if (self.delegate != nil) {
                    self.delegate?.getAppShareContentFail()
                }
                return
            }
           let appUrl = resultDict["url"] as! String
           let content = String(format: "%@%@%@", NSLocalizedString("share_text", comment: ""), NSLocalizedString("share_downloadtext", comment: ""), appUrl)
            if (self.delegate != nil) {
                self.delegate?.appShareContent(content)
            }
        }
    }
    
    func errorResult(error: NSError, tag: NSInteger) {
        if (tag == feedback) {
            if (self.delegate != nil) {
                self.delegate?.getAppShareContentFail()
            }
        }
    }
}
