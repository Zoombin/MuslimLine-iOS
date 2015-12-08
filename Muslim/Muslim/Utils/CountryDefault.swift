//
//  CountryDefault.swift
//  Muslim
//
//  Created by LSD on 15/12/7.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class CountryDefault: NSObject {
    static let TEHRAN : NSArray = ["Iran", "Iraq"]
    static let ISNA: NSArray = ["Canada","United States"]
    static let MWL: NSArray = ["Russia", "Turkey", "Belgium","Morocco"]
    static let EGYPT: NSArray = ["Egypt",  "Algeria",   "Syria", "Lebanon", "Malaysia","Indonesia","Singapore"]
    static let KARACHI: NSArray = ["Pakistan", "Afghanistan", "Bangladesh", "India","Kuwait"]
    static let MAKKAH: NSArray = [ "Oman","Qatar", "Bahrain","Saudi Arabia", "United Arab Emirates"]
    
    static func test() {
        for name in TEHRAN {
            print(name)
        }
    }
    
    static func saveDefaultMethod(countryName : String) ->Int{
        let key :String = countryName;
        for str in TEHRAN {
            if (str.lowercaseString == key.lowercaseString) {
                Config.saveAsrCalculationjuristicMethod(0);
                Config.savePrayerTimeConventions(6);
                Config.saveHighLatitudeAdjustment(3);
                Config.saveDaylightSavingTime(0);
                Config.saveCalenderSelection(1);
                Config.saveAutoSwitch(1);
                return 0;
            }
        }

    
        for str in EGYPT {
            if (str.lowercaseString == key.lowercaseString) {
                Config.saveAsrCalculationjuristicMethod(0);
                Config.savePrayerTimeConventions(5);
                Config.saveHighLatitudeAdjustment(3);
                Config.saveDaylightSavingTime(0);
                Config.saveCalenderSelection(0);
                Config.saveAutoSwitch(1);
                return 0;
            }
        }

        for str in KARACHI {
            if (str.lowercaseString == key.lowercaseString) {
                Config.saveAsrCalculationjuristicMethod(0);
                Config.savePrayerTimeConventions(1);
                Config.saveHighLatitudeAdjustment(3);
                Config.saveDaylightSavingTime(0);
                Config.saveCalenderSelection(0);
                Config.saveAutoSwitch(1);
                return 0;
            }
        }
    
        for str in MWL {
            if (str.lowercaseString == key.lowercaseString) {
                Config.saveAsrCalculationjuristicMethod(0);
                Config.savePrayerTimeConventions(3);
                Config.saveHighLatitudeAdjustment(3);
                Config.saveDaylightSavingTime(0);
                Config.saveCalenderSelection(0);
                Config.saveAutoSwitch(1);
                return 0;
            }
        }
        
        for str in ISNA {
            if (str.lowercaseString == key.lowercaseString) {
                Config.saveAsrCalculationjuristicMethod(0);
                Config.savePrayerTimeConventions(2);
                Config.saveHighLatitudeAdjustment(3);
                Config.saveDaylightSavingTime(0);
                Config.saveCalenderSelection(0);
                Config.saveAutoSwitch(1);
                return 0;
            }
        }
        
         for str in ISNA {
            if (str.lowercaseString == key.lowercaseString) {
                Config.saveAsrCalculationjuristicMethod(0);
                Config.savePrayerTimeConventions(4);
                Config.saveHighLatitudeAdjustment(3);
                Config.saveDaylightSavingTime(0);
                Config.saveCalenderSelection(0);
                Config.saveAutoSwitch(1);
                return 0;
            }
        }
        Config.savePrayerTimeConventions(3);
        Config.saveCalenderSelection(0);
        Config.saveAutoSwitch(0);
        return 0;
    }

}
