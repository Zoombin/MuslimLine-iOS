//
//  MSLHttpClient.swift
//  Muslim
//
//  Created by 颜超 on 15/11/4.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MSLHttpClient: NSObject {

    static func getTimezoneAndCountryName(lat : Double, lng : Double) {
        let urlString : String = String(format:"http://api.geonames.org/timezoneJSON?lat=%f&lng=%f&username=daiye", lat, lng)
        let manager = AFHTTPRequestOperationManager()
        manager.GET(urlString, parameters: nil, success:
            { (operation, responseObject) -> Void in
                print("成功 %@", responseObject)
//                let countryInfo : CountryInfo = CountryInfo()
//                countryInfo.initValues(responseObject as! NSDictionary)
//                print(countryInfo.description)
            }) { (operation, error) -> Void in
             print("失败")
        }
    }
}
