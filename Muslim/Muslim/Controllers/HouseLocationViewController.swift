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
    
    var compossView : CompossView!
    @IBOutlet weak var noticeLabel : UILabel!
    @IBOutlet weak var housePostion : UILabel!

    
    var locationButton : UIButton!
    var kabahLocation : CLLocation?
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
        
        let textAll = String(format: "%@:",NSLocalizedString("main_qibla_label", comment: ""))
        housePostion.text = textAll as String
        
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            self.locationManger.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        
        initView()
        refreshLocation()
        shouldShowLocationView()
    }
    
    override func refreshUserLocation() {
        refreshLocation()
    }
    
    func refreshLocation() {
        let cityName = Config.getCityName().isEmpty ? NSLocalizedString("main_location_set", comment: "") : Config.getCityName()
        locationButton.setTitle(cityName, forState: UIControlState.Normal)
        
        let location = CLLocation(latitude: Config.getLat().doubleValue, longitude: Config.getLng().doubleValue)
        if (Config.getLat() == 0 && Config.getLng() == 0) {
            return;
        }
        self.locationManger.startUpdatingHeading()
        needleAngle = self.setLatLonForDistanceAndAngle(location)
    }
    
    func initView() {
        if(PhoneUtils.screenWidth > 400){
            let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("CompossView_plus", owner: nil, options: nil)
            compossView = nibs.lastObject as! CompossView
        }else{
            let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("CompossView", owner: nil, options: nil)
            compossView = nibs.lastObject as! CompossView
        }
        self.view.addSubview(compossView)
        
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
        if(PhoneUtils.rightThemeStyle()){
            locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        }
        locationButton.addTarget(self, action: Selector.init("locationSet"), forControlEvents: UIControlEvents.TouchUpInside)
        settingLocationView.addSubview(locationButton)
        
        compossView.frame = CGRectMake((PhoneUtils.screenWidth - compossView.frame.size.width) / 2, (PhoneUtils.screenHeight - compossView.frame.size.height) / 2, compossView.frame.size.width, compossView.frame.size.height)
        
        if(PhoneUtils.screenWidth > 400){
            housePostion.font = UIFont.systemFontOfSize(22)
            noticeLabel.font = UIFont.systemFontOfSize(12)
        }
    }
    
    func locationSet() {
        showLocationView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - LocationManger Delegate
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

        let textLeft =  (NSLocalizedString("main_qibla_label", comment: "")) as NSString
        let textAll = String(format: "%@:%.0f°",textLeft, radiansBearing*180/M_PI)
        let attributeString = NSMutableAttributedString(string:textAll)
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(),
            range: NSMakeRange(0, textLeft.length))
        housePostion.attributedText = attributeString
        housePostion.adjustsFontSizeToFitWidth = true
        return radiansBearing
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
//        let needleDirection   = -newHeading.trueHeading;
        let compassDirection  = -newHeading.magneticHeading;
        
        let location = CLLocation(latitude: Config.getLat().doubleValue, longitude: Config.getLng().doubleValue)
        if (Config.getLat() == 0 && Config.getLng() == 0) {
            return;
        }
        needleAngle = self.setLatLonForDistanceAndAngle(location)
        
        compossView.needle.transform = CGAffineTransformMakeRotation(CGFloat(((Double(compassDirection) * M_PI) / 180.0) + needleAngle!))
        compossView.compass.transform = CGAffineTransformMakeRotation(CGFloat((Double(compassDirection) * M_PI) / 180.0))
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
