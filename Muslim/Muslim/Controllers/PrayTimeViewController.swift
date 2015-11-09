//
//  PrayTimeViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/9.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PrayTimeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView!
    var locationButton : UIButton!
    let prayNames : NSArray = [NSLocalizedString("prayer_names_generic_1", comment: ""), NSLocalizedString("prayer_names_generic_2", comment: ""), NSLocalizedString("prayer_names_generic_3", comment: ""), NSLocalizedString("prayer_names_generic_4", comment: ""), NSLocalizedString("prayer_names_generic_5", comment: ""), NSLocalizedString("prayer_names_generic_6", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_pray_label", comment:"")
        initView()
    }
    
    let cellIdentifier = "myCell"
    func initView() {
        let settingLocationView : UIView = UIView(frame: CGRectMake(0, 64, Constants.screenWidth, 30))
        self.view.addSubview(settingLocationView)
        
        let startX : CGFloat = (Constants.screenWidth - 100) / 2
        locationButton = UIButton.init(type: UIButtonType.Custom)
        locationButton.frame = CGRectMake(startX, 0, 100, 30)
        locationButton.setImage(UIImage(named: "green_loaction"), forState: UIControlState.Normal)
        locationButton.setTitle(NSLocalizedString("main_location_set", comment: ""), forState: UIControlState.Normal)
        locationButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        locationButton.setTitleColor(Colors.greenColor, forState: UIControlState.Normal)
        locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        locationButton.addTarget(self, action: Selector.init("locationSet"), forControlEvents: UIControlEvents.TouchUpInside)
        settingLocationView.addSubview(locationButton)
        
        let calendarScrollView : UIScrollView = UIScrollView(frame: CGRectMake(0, CGRectGetMaxY(settingLocationView.frame), Constants.screenWidth, 200))
        calendarScrollView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(calendarScrollView)
        
        tableView = UITableView(frame: CGRectMake(0, CGRectGetMaxY(calendarScrollView.frame), Constants.screenWidth, Constants.screenHeight - settingLocationView.frame.size.height - calendarScrollView.frame.size.height - 64), style: UITableViewStyle.Plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        //注册ListView的adapter
        tableView!.registerNib(UINib(nibName: "PrayTimeCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func locationSet() {
       print("设置地址")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayNames.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let prayCell : PrayTimeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PrayTimeCell
        let prayName : String = prayNames[indexPath.row] as! String
        prayCell.prayNameLabel.text = prayName
        if (indexPath.row == 1) {
            prayCell.praySunImg.hidden = false
        }
        return prayCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
