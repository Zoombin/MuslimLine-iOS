//
//  MSLHttpClient.swift
//  Muslim
//
//  Created by 颜超 on 15/11/4.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

protocol httpClientDelegate : NSObjectProtocol {
    func succssResult(result : NSDictionary, tag : NSInteger)
    func errorResult(error : NSError, tag : NSInteger)
}

class MSLHttpClient: NSObject {
    
    static var httpClient : MSLHttpClient!
    var delegate : httpClientDelegate?
    
    func getNearByForServer(lat : Double, lng : Double, keywords : NSString, tag : NSInteger) {
        let urlString : String = "http://www.csufo.com:8002/Interface"
        let manager = AFHTTPRequestOperationManager()
        let params : NSMutableDictionary = NSMutableDictionary()
        params["Action"] = "1004"
        params["lat"] = lat
        params["lng"] = lng
        params["range"] = "15000"
        params["Lang"] = "EN"
        params["keywords"] = keywords
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
    
    func searchLocationByName(cityName : String, tag : NSInteger) {
        print(cityName)
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
}
