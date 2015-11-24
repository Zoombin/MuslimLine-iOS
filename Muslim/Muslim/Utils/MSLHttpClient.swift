//
//  MSLHttpClient.swift
//  Muslim
//
//  Created by 颜超 on 15/11/4.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

protocol httpClientDelegate : NSObjectProtocol {
    func succssResult(result : NSObject, tag : NSInteger)
    func errorResult(error : NSError, tag : NSInteger)
}

class MSLHttpClient: NSObject {
    let defalturl:String = "http://www.muslimsline.com/config/website.json"
    
    static var httpClient : MSLHttpClient!
    var delegate : httpClientDelegate?
    
    func getNearByForGoogle(lat : Double, lng : Double, keyword : NSString, tag : NSInteger) {
        let urlString : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let params : NSMutableDictionary = NSMutableDictionary()
        params["Action"] = "1004"
        params["location"] = String(format: "%f,%f", lat,lng)
        params["radius"] = "15000"
        params["key"] = "AIzaSyChdMgSqJNgAZCrGmP_9UhkGFW9f7FOVCs"
        params["keyword"] = keyword
        let manager = AFHTTPRequestOperationManager()
        manager.GET(urlString, parameters: params, success:
            { (operation, responseObject) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.succssResult(responseObject as! NSDictionary, tag: tag)
                }
            }) { (operation, error) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.errorResult(error, tag: tag)
                }
        }
        
    }
    
    func getNearByForServer(lat : Double, lng : Double, keyword : NSString, tag : NSInteger) {
//        let urlString : String = Config.getUrl()
//        if (urlString.isEmpty) {
//            let urlString : String = "http://www.muslimsline.com/config/website.json"
//            let manager = AFHTTPRequestOperationManager()
//            manager.GET(urlString, parameters: nil, success:
//                { (operation, responseObject) -> Void in
//                    let urls = (responseObject as! NSDictionary)["urls"]
//                    if (urls == nil) {
//                        return
//                    }
//                    let arrayCount : NSInteger = urls!.count
//                    for index in 0...arrayCount - 1 {
//                        let info : NSDictionary = urls![index] as! NSDictionary
//                        if (info["name"] as! String == "defualt") {
//                            let url : String =  info["url"] as! String
//                            Config.saveUrl(url)
//                            self.getNear(url, lat: lat, lng: lng, keyword: keyword, tag: tag)
//                        }
//                    }
//                }) { (operation, error) -> Void in
//                    if (self.delegate != nil) {
//                        self.delegate!.errorResult(error, tag: tag)
//                    }
//            }
//            return
//        }
//        getNear(urlString, lat: lat, lng: lng, keyword: keyword, tag: tag)
    }
    
    func getNear(urlString : String, lat : Double, lng : Double, keyword : NSString, tag : NSInteger) {
        let manager = AFHTTPRequestOperationManager()
        
        //TODO: 下面这句话一定要加，不然会失败
        manager.responseSerializer.acceptableContentTypes = NSSet.init(object: "text/html") as Set<NSObject>
        let params : NSMutableDictionary = NSMutableDictionary()
        //        lat = 31.323466;
        //        lng = 48.649984;
        params["Action"] = "1004"
        params["lat"] = lat
        params["lng"] = lng
        params["range"] = 15000
        params["Lang"] = "EN"
        params["keywords"] = keyword
        
        manager.POST(urlString, parameters: params, success:
            { (operation, responseObject) -> Void in
            if (self.delegate != nil) {
                self.delegate!.succssResult(responseObject as! NSDictionary, tag: tag)
            }
            }) { (operation, error) -> Void in
                if (self.delegate != nil) {
                self.delegate!.errorResult(error, tag: tag)
                }
        }
    }

    func getTimezoneAndCountryName(lat : Double, lng : Double, tag : NSInteger) {
        let urlString : String = String(format:"http://api.geonames.org/timezoneJSON?lat=%f&lng=%f&username=daiye", lat, lng)
        let manager = AFHTTPRequestOperationManager()
        manager.GET(urlString, parameters: nil, success:
            { (operation, responseObject) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.succssResult(responseObject as! NSDictionary, tag: tag)
                }
            }) { (operation, error) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.errorResult(error, tag: tag)
                }
        }
    }
    
    func getCityName(lat : Double, lng : Double, tag : NSInteger) {
        let urlString : String = "http://query.yahooapis.com/v1/public/yql"
        let params : NSMutableDictionary = NSMutableDictionary()
        params["format"] = "json"
        params["q"] = String(format: "select city from geo.placefinder where text=\"%f,%f\"  and gflags=\"R\"", lat, lng)
        
        let manager = AFHTTPRequestOperationManager()
        manager.POST(urlString, parameters: params, success:
            { (operation, responseObject) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.succssResult(responseObject as! NSDictionary, tag: tag)
                }
            }) { (operation, error) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.errorResult(error, tag: tag)
                }
        }
    }
    
    func searchLocationByName(cityName : String, tag : NSInteger) {
        var urlString : String = "http://where.yahooapis.com/v1/places.q(%22cityName%22%2A);count=10"
        urlString = urlString.stringByReplacingOccurrencesOfString("cityName", withString: cityName)
        
        let manager = AFHTTPRequestOperationManager()
        let params : NSMutableDictionary = NSMutableDictionary()
        params["format"] = "json"
        params["lang"] = "en-US"
        params["appid"] = "dj0yJmk9cHlhcHpjcTZhYVhoJmQ9WVdrOVdGTklXRmhoTlRRbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0wZA--"
        
        manager.GET(urlString, parameters: params, success:
            { (operation, responseObject) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.succssResult(responseObject as! NSDictionary, tag: tag)
                }
            }) { (operation, error) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.errorResult(error, tag: tag)
                }
        }
    }
    
    /**反馈*/
    func sendFeedback(message:String,tag:NSInteger){
        var urlString :String = Config.getUrl()
        if(urlString.isEmpty){
            urlString = defalturl
        }
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet.init(object: "text/html") as Set<NSObject>
        let params : NSMutableDictionary = NSMutableDictionary()
        params["Action"] = "1003"
        params["imsi"] = "" //获取设备IMSI
        params["imei"] = "" //获取设备IMEI
        params["model"] = "" //获取设备型号
        params["display"] = "" //获取系统版本号
        params["device"] = "" //获取设备名称
        params["message"] = message
        manager.POST(urlString, parameters: params, success:
            { (operation, responseObject) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.succssResult(responseObject as! NSDictionary, tag: tag)
                }
            }) { (operation, error) -> Void in
                if (self.delegate != nil) {
                    self.delegate!.errorResult(error, tag: tag)
                }
        }
    }
    
    func downloadDocument(url : String,outPath:String) {
        let configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manager : AFURLSessionManager = AFURLSessionManager.init(sessionConfiguration: configuration)
        
        let URL : NSURL = NSURL.init(string: url)!
        let request : NSURLRequest = NSURLRequest(URL: URL)
        
        let downloadTask : NSURLSessionDownloadTask = manager.downloadTaskWithRequest(request, progress: nil, destination: { (targetPath, response) -> NSURL in
            if(outPath.isEmpty){
                let documentsDirectoryURL : NSURL = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
                return documentsDirectoryURL.URLByAppendingPathComponent(response.suggestedFilename!)
            }else{
                return NSURL.init(fileURLWithPath: String(format: "%@%@", outPath, response.suggestedFilename!))
            }
            }) { (response, filePath, error) -> Void in
                if(error != nil){
                    if (self.delegate != nil) {
                        self.delegate!.errorResult(error!, tag: 0)
                    }
                }else{
                    if (self.delegate != nil) {
                        self.delegate!.succssResult(filePath!.absoluteString, tag: 0)
                    }
                }
        }
        downloadTask.resume()
    }
}
