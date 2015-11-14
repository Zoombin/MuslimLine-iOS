//
//  NearbyViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/13.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class NearbyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, httpClientDelegate {

    let forServer : NSInteger = 0
    let forGoogle : NSInteger = 1
    
    var locationButton : UIButton!
    var locationTableView : UITableView!
    var httpClient : MSLHttpClient = MSLHttpClient()
    
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
//        31.3207416422,120.6286643729
        searchBYType(0)
    }
    
    func succssResult(result: NSDictionary, tag: NSInteger) {
        print("成功 %@", result)
    }
    
    func errorResult(error: NSError, tag: NSInteger) {
        print("失败")
    }
    
    func searchBYType(type : NSInteger) {
        httpClient.getNearByForServer(31.3207416422, lng: 120.6286643729, keywords: "饭店", tag: 0)
    }
    
    func locationSet() {
        print("设置位置")
    }
    
    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return dataArray.count
        return 100
    }
    
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nearbyCell : NearbyCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NearbyCell
        return nearbyCell
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
