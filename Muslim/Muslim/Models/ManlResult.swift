//
//  ManlResult.swift
//  Muslim
//
//  Created by 颜超 on 15/11/8.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ManlResult: NSObject {
    var places : ManlDetailResult?
    
    func initValues(dictionary : NSDictionary) {
        if (dictionary["places"] != nil) {
            let plc : ManlDetailResult = ManlDetailResult()
            plc.initValues((dictionary["places"] as? NSDictionary)!)
            places = plc
        }
    }
}

//class CountryInfo: NSObject {
//    var countryCode : NSString?
//    var countryName : NSString?
//    var dstOffset : NSNumber?
//    var gmtOffset : NSNumber?
//    var lat : NSNumber?
//    var lng : NSNumber?
//    var rawOffset : NSNumber?
//    var sunrise : NSString?
//    var sunset : NSString?
//    var time : NSString?
//    var timezoneId : NSString?
//    
//    func initValues(dictionary : NSDictionary) {
//        if ((dictionary["countryCode"]) != nil) {
//            countryCode = dictionary["countryCode"] as? NSString
//        }
//        if ((dictionary["countryName"]) != nil) {
//            countryName = dictionary["countryName"] as? NSString
//        }
//        if ((dictionary["dstOffset"]) != nil) {
//            dstOffset = dictionary["dstOffset"] as? NSNumber
//        }
//        if ((dictionary["gmtOffset"]) != nil) {
//            gmtOffset = dictionary["gmtOffset"] as? NSNumber
//        }
//        if ((dictionary["lat"]) != nil) {
//            lat = dictionary["lat"] as? NSNumber
//        }
//        if ((dictionary["lng"]) != nil) {
//            lng = dictionary["lng"] as? NSNumber
//        }
//        if ((dictionary["rawOffset"]) != nil) {
//            rawOffset = dictionary["rawOffset"] as? NSNumber
//        }
//        if ((dictionary["sunrise"]) != nil) {
//            sunrise = dictionary["sunrise"] as? NSString
//        }
//        if ((dictionary["sunset"]) != nil) {
//            sunset = dictionary["sunset"] as? NSString
//        }
//        if ((dictionary["time"]) != nil) {
//            time = dictionary["time"] as? NSString
//        }
//        if ((dictionary["timezoneId"]) != nil) {
//            timezoneId = dictionary["timezoneId"] as? NSString
//        }
//    }
//}

//{
//    places =     {
//        count = 3;
//        place =         (
//            {
//                admin1 = Jiangsu;
//                "admin1 attrs" =                 {
//                    code = "CN-32";
//                    type = Province;
//                    woeid = 12577994;
//                };
//                admin2 = Suzhou;
//                "admin2 attrs" =                 {
//                    code = "";
//                    type = Prefecture;
//                    woeid = 26198274;
//                };
//                admin3 = Suzhou;
//                "admin3 attrs" =                 {
//                    code = "";
//                    type = County;
//                    woeid = 20071126;
//                };
//                areaRank = 3;
//                boundingBox =                 {
//                    northEast =                     {
//                        latitude = "31.3384";
//                        longitude = "120.648117";
//                    };
//                    southWest =                     {
//                        latitude = "31.2784";
//                        longitude = "120.575508";
//                    };
//                };
//                centroid =                 {
//                    latitude = "31.3092";
//                    longitude = "120.613121";
//                };
//                country = China;
//                "country attrs" =                 {
//                    code = CN;
//                    type = Country;
//                    woeid = 23424781;
//                };
//                lang = "en-US";
//                locality1 = Suzhou;
//                "locality1 attrs" =                 {
//                    type = Town;
//                    woeid = 2137082;
//                };
//                locality2 = "";
//                name = Suzhou;
//                placeTypeName = Town;
//                "placeTypeName attrs" =                 {
//                    code = 7;
//                };
//                popRank = 11;
//                postal = 2150;
//                "postal attrs" =                 {
//                    type = "Postal Code";
//                    woeid = 12712501;
//                };
//                timezone = "Asia/Shanghai";
//                "timezone attrs" =                 {
//                    type = "Time Zone";
//                    woeid = 56043597;
//                };
//                uri = "http://where.yahooapis.com/v1/place/2137082";
//                woeid = 2137082;
//            },
//            {
//                admin1 = Gansu;
//                "admin1 attrs" =                 {
//                    code = "CN-62";
//                    type = Province;
//                    woeid = 12578005;
//                };
//                admin2 = Jiuquan;
//                "admin2 attrs" =                 {
//                    code = "";
//                    type = Prefecture;
//                    woeid = 26198132;
//                };
//                admin3 = Jiuquan;
//                "admin3 attrs" =                 {
//                    code = "";
//                    type = County;
//                    woeid = 12686530;
//                };
//                areaRank = 2;
//                boundingBox =                 {
//                    northEast =                     {
//                        latitude = "39.751888";
//                        longitude = "98.52423899999999";
//                    };
//                    southWest =                     {
//                        latitude = "39.733711";
//                        longitude = "98.500603";
//                    };
//                };
//                centroid =                 {
//                    latitude = "39.742802";
//                    longitude = "98.512421";
//                };
//                country = China;
//                "country attrs" =                 {
//                    code = CN;
//                    type = Country;
//                    woeid = 23424781;
//                };
//                lang = "en-US";
//                locality1 = Suzhou;
//                "locality1 attrs" =                 {
//                    type = Town;
//                    woeid = 2145440;
//                };
//                locality2 = "";
//                name = Suzhou;
//                placeTypeName = Town;
//                "placeTypeName attrs" =                 {
//                    code = 7;
//                };
//                popRank = 9;
//                postal = 7350;
//                "postal attrs" =                 {
//                    type = "Postal Code";
//                    woeid = 12714037;
//                };
//                timezone = "Asia/Shanghai";
//                "timezone attrs" =                 {
//                    type = "Time Zone";
//                    woeid = 56043597;
//                };
//                uri = "http://where.yahooapis.com/v1/place/2145440";
//                woeid = 2145440;
//            },
//            {
//                admin1 = Anhui;
//                "admin1 attrs" =                 {
//                    code = "CN-34";
//                    type = Province;
//                    woeid = 12578022;
//                };
//                admin2 = Suzhou;
//                "admin2 attrs" =                 {
//                    code = "";
//                    type = Prefecture;
//                    woeid = 26198330;
//                };
//                admin3 = Suzhou;
//                "admin3 attrs" =                 {
//                    code = "";
//                    type = County;
//                    woeid = 12685368;
//                };
//                areaRank = 2;
//                boundingBox =                 {
//                    northEast =                     {
//                        latitude = "33.6381";
//                        longitude = "117.012428";
//                    };
//                    southWest =                     {
//                        latitude = "33.619919";
//                        longitude = "116.990593";
//                    };
//                };
//                centroid =                 {
//                    latitude = "33.629009";
//                    longitude = "117.001511";
//                };
//                country = China;
//                "country attrs" =                 {
//                    code = CN;
//                    type = Country;
//                    woeid = 23424781;
//                };
//                lang = "en-US";
//                locality1 = Suzhou;
//                "locality1 attrs" =                 {
//                    type = Town;
//                    woeid = 2127874;
//                };
//                locality2 = "";
//                name = Suzhou;
//                placeTypeName = Town;
//                "placeTypeName attrs" =                 {
//                    code = 7;
//                };
//                popRank = 10;
//                postal = 2340;
//                "postal attrs" =                 {
//                    type = "Postal Code";
//                    woeid = 12712570;
//                };
//                timezone = "Asia/Shanghai";
//                "timezone attrs" =                 {
//                    type = "Time Zone";
//                    woeid = 56043597;
//                };
//                uri = "http://where.yahooapis.com/v1/place/2127874";
//                woeid = 2127874;
//            }
//        );
//        start = 0;
//        total = 3;
//    };
//}
