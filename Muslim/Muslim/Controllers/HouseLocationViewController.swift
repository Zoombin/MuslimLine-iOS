//
//  HouseLocationViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/2.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

func DegreesToRadians (value:Double) -> Double {
    return value * M_PI / 180.0
}

func RadiansToDegrees (value:Double) -> Double {
    return value * 180.0 / M_PI
}

class HouseLocationViewController: BaseViewController , CLLocationManagerDelegate {
    
    var needleAngle : Double?
    
    @IBOutlet weak var composs: UIImageView!
    @IBOutlet weak var needle: UIImageView!
    @IBOutlet weak var compossView : UIView!
    @IBOutlet weak var noticeLabel : UILabel!
    @IBOutlet weak var housePostion : UILabel!

    
    var locationButton : UIButton!
    var kabahLocation : CLLocation?
    var latitude  : Double?
    var longitude : Double?
    var distanceFromKabah : Double?
    
    let locationManger = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.houseColor
        title = NSLocalizedString("main_qibla_label", comment: "")
        //title右边菜单
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("showOrHidePopView"))
        
        
        noticeLabel.text = NSLocalizedString("qibla_warning_text", comment: "")
        kabahLocation = CLLocation(latitude: 21.42 , longitude: 39.83)
        
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            self.locationManger.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        
        self.locationManger.startUpdatingLocation()
        self.locationManger.startUpdatingHeading()
        
        initView()
    }
    
    func initView() {
        let settingLocationView : UIView = UIView(frame: CGRectMake(0, 64, PhoneUtils.screenWidth, 30))
        settingLocationView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(settingLocationView)
        
        let startX : CGFloat = (PhoneUtils.screenWidth - 100) / 2
        locationButton = UIButton.init(type: UIButtonType.Custom)
        locationButton.frame = CGRectMake(startX, 0, 100, 30)
        locationButton.setImage(UIImage(named: "green_loaction"), forState: UIControlState.Normal)
        locationButton.setTitle(NSLocalizedString("main_location_set", comment: ""), forState: UIControlState.Normal)
        locationButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        locationButton.setTitleColor(Colors.greenColor, forState: UIControlState.Normal)
        locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        locationButton.addTarget(self, action: Selector.init("locationSet"), forControlEvents: UIControlEvents.TouchUpInside)
        settingLocationView.addSubview(locationButton)
        
         compossView.frame = CGRectMake((PhoneUtils.screenWidth - compossView.frame.size.width) / 2, (PhoneUtils.screenHeight - compossView.frame.size.height) / 2, compossView.frame.size.width, compossView.frame.size.height)
    }
    
    func locationSet() {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - LocationManger Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.latitude = location?.coordinate.latitude
        self.longitude = location?.coordinate.longitude
        self.locationManger.startUpdatingLocation()
        needleAngle     = self.setLatLonForDistanceAndAngle(location!)
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
       
    }
    
    func setLatLonForDistanceAndAngle(userlocation: CLLocation) -> Double
    {
        let lat1 = DegreesToRadians(userlocation.coordinate.latitude)
        let lon1 = DegreesToRadians(userlocation.coordinate.longitude)
        let lat2 = DegreesToRadians(kabahLocation!.coordinate.latitude)
        let lon2 = DegreesToRadians(kabahLocation!.coordinate.longitude)
        
        distanceFromKabah = userlocation.distanceFromLocation(kabahLocation!)
        let dLon = lon2 - lon1;
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var radiansBearing = atan2(y, x)
        if(radiansBearing < 0.0) {
            radiansBearing += 2*M_PI;
        }

        housePostion.text = String(format: "%@:%.0f°", NSLocalizedString("main_qibla_label", comment: ""), radiansBearing*180/M_PI)
        return radiansBearing
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let needleDirection   = -newHeading.trueHeading;
        let compassDirection  = -newHeading.magneticHeading;
        
        self.needle.transform = CGAffineTransformMakeRotation(CGFloat(((Double(needleDirection) * M_PI) / 180.0) + needleAngle!))
        self.composs.transform = CGAffineTransformMakeRotation(CGFloat((Double(compassDirection) * M_PI) / 180.0))
    }
    
    override func viewDidAppear(animated: Bool) {
        needleAngle = 0.0
        self.locationManger.startUpdatingHeading()
        kabahLocation = CLLocation(latitude: 21.42 , longitude: 39.83)
        self.locationManger.delegate = self
        
    }
    override func viewDidDisappear(animated: Bool) {
        self.locationManger.delegate = nil
    }
    

}
