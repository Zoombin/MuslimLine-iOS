//
//  LocationSettingView.swift
//  Muslim
//
//  Created by 颜超 on 15/11/25.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

protocol LocationSettingDelegate : NSObjectProtocol {
    func refreshUserLocation()
}

class LocationSettingView: UIView, UITableViewDelegate, UITableViewDataSource, httpClientDelegate, CLLocationManagerDelegate {
    
    var delegate : LocationSettingDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var manView: UIView!
    @IBOutlet weak var autoView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var loadingView : UIActivityIndicatorView!
    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var rightLineLabel: UILabel!
    @IBOutlet weak var cityNameLabel : UILabel!
    
    let locationManager = CLLocationManager()
    var manlResultArray : NSMutableArray = NSMutableArray()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    var http : MSLHttpClient = MSLHttpClient()
    let auto : NSInteger = 0
    let manl : NSInteger = 1
    let city : NSInteger = 2
    
    var timeZone : String!
    var countryName : String!
    var lat : NSNumber!
    var lng : NSNumber!
    var currentCity : String!
    
    func initView() {
        searchBar.placeholder = NSLocalizedString("dlg_prayer_search_edit_text_hint", comment: "")
        okButton.layer.cornerRadius = 6.0
        okButton.layer.masksToBounds = true
        okButton.setTitle(NSLocalizedString("ok", comment: ""), forState: UIControlState.Normal)
        manButton.setTitle(NSLocalizedString("dlg_prayer_location_menu_manual", comment: ""), forState: UIControlState.Normal)
        autoButton.setTitle(NSLocalizedString("dlg_prayer_location_menu_auto", comment: ""), forState: UIControlState.Normal)
        
        http.delegate = self;
        configLocationManager()
    }
    
    @IBAction func bkgButtonClicked() {
        self.hidden = true
    }
    
    func configLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Log.printLog("获取到地址")
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        let location = locations.last!
        //TODO: 测试用，两伊的经纬度
//        let location = CLLocation(latitude: 31.323466, longitude: 48.649984)
        self.http.getTimezoneAndCountryName(location.coordinate.latitude, lng: location.coordinate.longitude, tag: self.auto)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //获取地址失败
        Log.printLog("获取地址失败")
    }
    
    @IBAction func okButtonClicked() {
        Config.saveTimeZone(timeZone)
        Config.saveLat(lat)
        Config.savecountryName(countryName)
        Config.saveLng(lng)
        Config.saveCityName(currentCity)
        self.hidden = true
        if (self.delegate != nil) {
            PrayTimeUtil.getPrayTime() //获取默认礼拜时间
            self.delegate!.refreshUserLocation()
        }
    }
    
    //获取用户位置
    func getUserLocation() {
        searchBar.text = ""
        clearPreResults()
        rightButtonClicked()
        cityNameLabel.text = ""
        loadingView.hidden = false
        okButton.hidden = true
        loadingView.startAnimating()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func succssResult(result: NSObject, tag : NSInteger) {
        self.hideToastActivity()
        if (tag == manl) {
            Log.printLog(result)
            let manlResult : ManlResult = ManlResult()
            manlResult.initValues(result as! NSDictionary)
            if (manlResult.places == nil) {
                self.makeToast(message: NSLocalizedString("dlg_prayer_search_none", comment: ""))
                clearPreResults()
                return
            }
            if (manlResult.places!.count!.integerValue > 0) {
                manlResultArray.removeAllObjects()
                manlResultArray.addObjectsFromArray(manlResult.places?.place as! [AnyObject])
                tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                tableView.reloadData()
            } else {
                self.makeToast(message: NSLocalizedString("dlg_prayer_search_none", comment: ""))
                clearPreResults()
            }
        } else if (tag == auto) {
            Log.printLog(result)
            let countryInfo : CountryInfo = CountryInfo()
            countryInfo.initValues(result as! NSDictionary)
            timeZone = countryInfo.timezoneId as! String
            countryName = countryInfo.countryName as! String
            lat = countryInfo.lat
            lng = countryInfo.lng
            
            Log.printLog(countryInfo.gmtOffset!)
            self.http.getCityName((countryInfo.lat?.doubleValue)!, lng: (countryInfo.lng?.doubleValue)!, tag: self.city)
        } else if (tag == city) {
            loadingView.stopAnimating()
            loadingView.hidden = true
            let query = (result as! NSDictionary)["query"]
            if (query!["count"] as! Int != 0) {
                let results = query!["results"]
                let result = results!["Result"]
                let cityName = result!["city"]
                currentCity = cityName as! String
                cityNameLabel.text = cityName as? String
                okButton.hidden = false
            } else {
                Log.printLog("定位失败")
            }
        }
    }
    
    func clearPreResults() {
        manlResultArray.removeAllObjects()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.reloadData()
    }
    
    func errorResult(error : NSError, tag : NSInteger) {
        self.hideToastActivity()
        if (tag == manl) {
            self.makeToast(message: NSLocalizedString("dlg_prayer_search_none", comment: ""))
            clearPreResults()
        } else if (tag == auto) {
            Log.printLog(error)
            Config.clearHomeValues()
        } else if (tag == city) {
            Log.printLog(error)
            Config.clearHomeValues()
        }
    }
    
    @IBAction func leftButtonClicked() {
        manButton.backgroundColor = UIColor.whiteColor()
        leftLineLabel.backgroundColor = Colors.greenColor
        
        autoButton.backgroundColor = Colors.searchGray
        rightLineLabel.backgroundColor = Colors.searchGray
        
        manView.hidden = false
        autoView.hidden = true
    }
    
    @IBAction func rightButtonClicked() {
        manButton.backgroundColor = Colors.searchGray
        leftLineLabel.backgroundColor = Colors.searchGray
        
        autoButton.backgroundColor = UIColor.whiteColor()
        rightLineLabel.backgroundColor = Colors.greenColor
        
        manView.hidden = true
        autoView.hidden = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manlResultArray.count
    }
    
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let info : NSDictionary = manlResultArray[indexPath.row] as! NSDictionary
        let province : NSString = info["admin1"] as! NSString
        let cityName : NSString = info["name"] as! NSString
        let countryInfo : NSDictionary = info["country attrs"] as! NSDictionary
        let countryCode : NSString = countryInfo["code"] as! NSString
        
        let cellTxt : NSString = String(format: "%@ %@ %@", cityName, province, countryCode)
        cell.textLabel?.text = String(cellTxt)
        return cell
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let info : NSDictionary = manlResultArray[indexPath.row] as! NSDictionary
        Log.printLog(info)
        
        let cityName : NSString = info["name"] as! NSString
        let timeZone : NSString = info["timezone"] as! NSString
        let country : NSString = info["country"] as! NSString
        let centroid : NSDictionary = info["centroid"] as! NSDictionary
        let latitude : NSNumber = centroid["latitude"] as! NSNumber
        let longitude : NSNumber = centroid["longitude"] as! NSNumber
        
        Config.saveTimeZone(timeZone as String)
        Config.saveLat(latitude)
        Config.savecountryName(country as String)
        Config.saveLng(longitude)
        Config.saveCityName(cityName as String)
        self.hidden = true
        if (self.delegate != nil) {
            PrayTimeUtil.getPrayTime() //获取默认礼拜时间
            self.delegate?.refreshUserLocation()
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.makeToastActivity()
        self.http.searchLocationByName(searchBar.text!, tag: self.manl)
    }
    
}
