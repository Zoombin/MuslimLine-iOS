//
//  HouseLocationViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/2.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class HouseLocationViewController: UIViewController, AMapLocationManagerDelegate {
    let locationManager : AMapLocationManager = AMapLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_qibla_label", comment:"")
        self.view.backgroundColor = UIColor.whiteColor()
        
        locationManager.delegate = self
        configLocationManager()
        
        locationManager.startUpdatingLocation()
//        locationManager.requestLocationWithReGeocode(true, completionBlock: nil)
    }
    
    func configLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didUpdateLocation location: CLLocation!) {
        print("%f %f获取到地址!", location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didFailWithError error: NSError!) {
        print("地址获取失败")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
