//
//  NearbyViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/13.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class NearbyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, httpClientDelegate {
    
    let KEYWORD_MOSQUE : String = "mosque";
    let KEYWORD_RESTAURANT : String = "restaurant";
    let KEYWORD_STORE : String  = "store";

    let forServer : NSInteger = 0
    let forGoogle : NSInteger = 1
    
    var locationButton : UIButton!
    var locationTableView : UITableView!
    var httpClient : MSLHttpClient = MSLHttpClient()
    var resultArray : NSMutableArray = NSMutableArray()
    var currentLng : Double = 0
    var currentLat : Double = 0
    var menuView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("main_nearby_label", comment: "")
        // Do any additional setup after loading the view.
        initView()
    }

    let cellIdentifier = "myCell"
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
        
        locationTableView = UITableView.init(frame: CGRectMake(0, CGRectGetMaxY(settingLocationView.frame), PhoneUtils.screenWidth, PhoneUtils.screenHeight - 64 - settingLocationView.frame.size.height), style: UITableViewStyle.Plain)
        locationTableView.delegate = self;
        locationTableView.dataSource = self;
        locationTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        locationTableView.layer.borderWidth = 0.5
        self.view.addSubview(locationTableView)
        
        //注册ListView的adapter
        locationTableView!.registerNib(UINib(nibName: "NearbyCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        httpClient.delegate = self

        currentLat = 31.3207416422
        currentLng = 120.6286643729
        
        searchBYType(KEYWORD_MOSQUE)
        
        let rightImage : UIImage =  UIImage(named: "mosque")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("menuButtonClicked"))
        
        initMenuView()
    }
    
    func menuButtonClicked() {
        menuView.hidden = !menuView.hidden
    }
    
    //菜单界面
    func initMenuView(){
        let itemHight:CGFloat = 50
        let menuWidth:CGFloat = 180
        let menuHight:CGFloat = itemHight * 5
        let menuX :CGFloat = PhoneUtils.screenWidth - menuWidth;
        let menuY :CGFloat = 64;
        menuView = UIView(frame: CGRectMake(menuX, menuY, menuWidth, menuHight))
        menuView.backgroundColor = UIColor.whiteColor()
        menuView.hidden = true;

        let imgs : [String] = ["mosque", "noodles", "store"]
        let titles : [String] = [NSLocalizedString("keyword_mosque", comment:""), NSLocalizedString("keyword_restaurant", comment:""),
            NSLocalizedString("keyword_store", comment:"")]
        
        var item :CGFloat = 0
        for index in 0...titles.count - 1 {
            let button : UIButton = UIButton()
            let itemY :CGFloat = (item * itemHight)
            button.frame = CGRectMake(0, itemY, menuWidth, itemHight)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
            button.layer.borderWidth = 0.5 //设置边框的宽度
            button.layer.borderColor = UIColor.lightGrayColor().CGColor //设置边框的颜色
            button.addTarget(self, action: Selector.init("menuClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = index
            button.setTitle(titles[index], forState:UIControlState.Normal)
            menuView.addSubview(button)
            
            let iconImage : UIImageView = UIImageView(frame: CGRectMake(5.0, 2.5, itemHight - 5, itemHight - 5))
            iconImage.image = UIImage(named: imgs[index])
            button.addSubview(iconImage)
            item++
        }
        self.view.addSubview(menuView)
        
    }
    
    //菜单点击事件
    func menuClick(item : UIButton){
        menuView.hidden = true;
        let tag : NSInteger = item.tag
        let types : NSArray = [KEYWORD_MOSQUE, KEYWORD_RESTAURANT, KEYWORD_STORE]
        searchBYType(types[tag] as! String)
    }
    
    func succssResult(result: NSObject, tag: NSInteger) {
        self.view.hideToastActivity()
        resultArray.removeAllObjects()
        let arr = (result as! NSDictionary)["results"]
        if (arr != nil) {
            resultArray.addObjectsFromArray(arr as! [AnyObject])
        }
        locationTableView.reloadData()
    }
    
    func errorResult(error: NSError, tag: NSInteger) {
        self.view.hideToastActivity()
    }
    
    func searchBYType(type : String) {
        self.view.makeToastActivity()
//        getNearByForServer
//        getNearByForGoogle
        httpClient.getNearByForGoogle(currentLat, lng: currentLng, keyword: type, tag: 0)
    }
    
    func locationSet() {

    }
    
    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nearbyCell : NearbyCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NearbyCell
        let dictionary : NSDictionary = resultArray[indexPath.row] as! NSDictionary
        nearbyCell.locationNameLabel.text = dictionary["name"] as? String
        nearbyCell.addressLabel.text = dictionary["vicinity"] as? String
        let geometry : NSDictionary = dictionary["geometry"] as! NSDictionary
        nearbyCell.nearLabel.text = String(format: "%.2fKM", getDistance(geometry["location"] as! NSDictionary))
        return nearbyCell
    }
    
    func getDistance(location : NSDictionary) -> Double{
        let lat : NSNumber = location["lat"] as! NSNumber
        let lng : NSNumber = location["lng"] as! NSNumber
        let location : CLLocation = CLLocation(latitude: lat.doubleValue, longitude: lng.doubleValue)
        let currentLocation : CLLocation = CLLocation(latitude: currentLat, longitude: currentLng)
        let distance : CLLocationDistance = currentLocation.distanceFromLocation(location)
        return distance / 1000
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let dictionary : NSDictionary = resultArray[indexPath.row] as! NSDictionary
        let geometry : NSDictionary = dictionary["geometry"] as! NSDictionary
        let location : NSDictionary = geometry["location"] as! NSDictionary
        let lat : NSNumber = location["lat"] as! NSNumber
        let lng : NSNumber = location["lng"] as! NSNumber
        let url : String = String(format: "http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", currentLat, currentLng, lat.doubleValue, lng.doubleValue)
        let webVC : WebViewController = WebViewController()
        webVC.url = url
        self.navigationController?.pushViewController(webVC, animated: true)
        menuView.hidden = true
    }
    
    func searchButtonClicked() {
        let guljSearchViewController = GuLJSearchViewController()
        self.navigationController?.pushViewController(guljSearchViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
