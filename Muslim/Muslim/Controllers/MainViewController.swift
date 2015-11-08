//
//  ViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/10/21.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, AMapLocationManagerDelegate, UISearchBarDelegate, httpClientDelegate, UITableViewDelegate, UITableViewDataSource {
    var menuView : UIView!
    let locationManager : AMapLocationManager = AMapLocationManager()
    let topSearchView : UIView = UIView()
    
    var httpClient : MSLHttpClient = MSLHttpClient()
    var manlResultArray : NSMutableArray = NSMutableArray()
    let auto : NSInteger = 0
    let manl : NSInteger = 1
    
    @IBOutlet weak var manlTableView: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var locationSettingsBkgView: UIView!
    
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var manButton: UIButton!

    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var rightLineLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //注: 设置title
        title = NSLocalizedString("app_name", comment:"");
        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = Colors.greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        self.view.backgroundColor = Colors.greenColor
        
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("menuButtonClicked"))
        
        initTopView()
        initBottomView()
        initMenuView()
        self.view.bringSubviewToFront(locationSettingsBkgView)

        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: Selector.init("settingsBkgClicked"))
        locationSettingsBkgView.addGestureRecognizer(tapGesture)
        
        httpClient.delegate = self
    }
    
    func succssResult(result: NSDictionary, tag : NSInteger) {
        if (tag == manl) {
            print("手动数据返回了!")
            print(result)
            let manlResult : ManlResult = ManlResult()
            manlResult.initValues(result)
            if (manlResult.places!.count!.integerValue > 0) {
               manlResultArray.removeAllObjects()
               manlResultArray.addObjectsFromArray(manlResult.places?.place as! [AnyObject])
               manlTableView.reloadData()
            }
        } else if (tag == auto) {
            print("自动数据返回了!")
            print(result)
        }
    }
    
    func errorResult(error : NSError, tag : NSInteger) {
        if (tag == manl) {
            print("手动数据错误!")
        } else if (tag == auto) {
            print("自动数据错误!")
        }
    }
    
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    //获取用户位置
    func getUserLocation() {
        locationManager.requestLocationWithReGeocode(true) { (location, code, error) -> Void in
            if (code != nil) {
                print(code.formattedAddress)
                self.httpClient.getTimezoneAndCountryName(location.coordinate.latitude, lng: location.coordinate.longitude, tag: self.manl)
            }
        }
    }
    
    func settingsBkgClicked() {
        locationSettingsBkgView.hidden = !locationSettingsBkgView.hidden
        if (!locationSettingsBkgView.hidden) {
            getUserLocation()
        } else {
            locationSearchBar.resignFirstResponder()
        }
    }
    
    func menuButtonClicked() {
        //这样写就行
        menuView.hidden = !menuView.hidden
    }
    
    //菜单界面
    func initMenuView(){
        let itemHight:CGFloat = 40
        let menuWidth:CGFloat = 150
        let menuHight:CGFloat = itemHight * 5
        let menuX :CGFloat = PhoneUtils.screenWidth - menuWidth;
        let menuY :CGFloat = 64;
        menuView = UIView(frame: CGRectMake(menuX, menuY, menuWidth, menuHight))
        menuView.backgroundColor = UIColor.whiteColor()
        menuView.hidden = true;
        
        let titles : [String] = [NSLocalizedString("upgrade_dialog_title", comment:""), NSLocalizedString("share", comment:""),
            NSLocalizedString("settings_title", comment:""), NSLocalizedString("about", comment:""),
            NSLocalizedString("feedback", comment:"")]
        
        var item :CGFloat = 0
        for index in 0...4 {
            let button : UIButton = UIButton()
            let itemY :CGFloat = (item * itemHight)
            button.frame = CGRectMake(0, itemY, menuWidth, itemHight)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center//居中
            button.layer.borderWidth = 0.5 //设置边框的宽度
            button.layer.borderColor = UIColor.lightGrayColor().CGColor //设置边框的颜色
            button.addTarget(self, action: Selector.init("menuClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = index
            button.setTitle(titles[index], forState:UIControlState.Normal)
            menuView.addSubview(button)
            item++
        }
        self.view.addSubview(menuView)
        
    }
    
    //菜单点击事件
    func menuClick(item : UIButton){
        menuView.hidden = true;
        let tag : NSInteger = item.tag
        if (tag == 0) {
            //升级
        }
        else if (tag == 1) {
            //分享
        }
        else if (tag == 2) {
            //设置
            let settingsViewController = SettingsViewController()
            self.navigationController?.pushViewController(settingsViewController, animated: true)
        }
        else if (tag == 3) {
            //关于
            let aboutviewController = AboutViewController()
            self.navigationController?.pushViewController(aboutviewController, animated: true)
        }
        else if (tag == 4) {
            //反馈
            let feedbackviewController = FeedbackViewController()
            self.navigationController?.pushViewController(feedbackviewController, animated: true)
        }
    }
    
    func initTopView() {
        topSearchView.frame = CGRectMake(0, 64, Constants.screenWidth, Constants.screenHeight / 2 - 64)
        self.view.addSubview(topSearchView)
        
        let bkgButton : UIButton = UIButton()
        bkgButton.frame = CGRectMake(0, 0, topSearchView.frame.size.width, topSearchView.frame.size.height)
        bkgButton.addTarget(self, action: Selector.init("settingsBkgClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        bkgButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, topSearchView.frame.size.height / 4, 0)
        bkgButton.setImage(UIImage(named: "earth"), forState: UIControlState.Normal)
        topSearchView.addSubview(bkgButton)
        
        let settingsButton : UIButton = UIButton()
        settingsButton.setImage(UIImage(named: "location"), forState: UIControlState.Normal)
        settingsButton.setTitle(NSLocalizedString("main_location_set", comment: ""), forState: UIControlState.Normal)
        settingsButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        settingsButton.backgroundColor = UIColor.clearColor()
        settingsButton.frame = CGRectMake((topSearchView.frame.size.width - 100) / 2, topSearchView.frame.size.height - topSearchView.frame.size.height / 4, 100, 20)
        settingsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        topSearchView.addSubview(settingsButton)
        
        manButton.addTarget(self, action: Selector.init("leftButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        autoButton.addTarget(self, action: Selector.init("rightButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        
        locationSearchBar.placeholder = NSLocalizedString("dlg_prayer_search_edit_text_hint", comment: "")
        locationSearchBar.delegate = self
        
        manButton.setTitle(NSLocalizedString("dlg_prayer_location_menu_manual", comment: ""), forState: UIControlState.Normal)
        autoButton.setTitle(NSLocalizedString("dlg_prayer_location_menu_auto", comment: ""), forState: UIControlState.Normal)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.httpClient.searchLocationByName(searchBar.text!, tag: self.manl)
    }
    
    func leftButtonClicked() {
        manButton.backgroundColor = UIColor.whiteColor()
        leftLineLabel.backgroundColor = Colors.greenColor
        
        autoButton.backgroundColor = Colors.searchGray
        rightLineLabel.backgroundColor = Colors.searchGray
        
        leftView.hidden = false
        rightView.hidden = true
    }
    
    func rightButtonClicked() {
        manButton.backgroundColor = Colors.searchGray
        leftLineLabel.backgroundColor = Colors.searchGray
        
        autoButton.backgroundColor = UIColor.whiteColor()
        rightLineLabel.backgroundColor = Colors.greenColor
        
        leftView.hidden = true
        rightView.hidden = false
    }
    
    func initBottomView() {
        //注: var 和 let的区别， var是变量 let是常量
        //let Object : 类型 比如CGFloat NSInterger等等
        let width : CGFloat = Constants.screenWidth
        let height : CGFloat = Constants.screenHeight
        let buttonWidth = width / 3
        let buttonHeight = height / 4;
        //第几行
        var row : CGFloat = 0
        //第几个
        var position : CGFloat = 0
        
        //定义数组 [String] 代表数组里面的String的
        let label1 :String = NSLocalizedString("main_quran_label", comment:"");
        let label2 :String = NSLocalizedString("main_qibla_label", comment:"");
        let label3 :String = NSLocalizedString("main_pray_label", comment:"");
        let label4 :String = NSLocalizedString("main_nearby_label", comment:"");
        let label5 :String = NSLocalizedString("main_holiday_label", comment:"");
        let label6 :String = NSLocalizedString("main_names_label", comment:"");
        let titles : [String] = [label1, label2, label3, label4, label5, label6]
        let actions : [String] = ["clickGuLj", "clickTianFFX", "clickLiBSJ", "clickFuJWZ", "clickRiL", "clickZunZXM"]
        let imageNames : [String] = ["quran", "qibla", "prayer", "nearby", "calenlar", "names"]
        
        for index in 0...5 {
            if (index % 3 == 0 && index != 0) {
                row++
                position = 0
            }
            let button : UIButton = UIButton()
            button.frame = CGRectMake(position * buttonWidth, (height / 2) + (row * buttonHeight), buttonWidth, buttonHeight)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.layer.borderWidth = 0.5 //设置边框的宽度
            button.layer.borderColor = UIColor.lightGrayColor().CGColor //设置边框的颜色
            button.setImage(UIImage(named: imageNames[index]), forState: UIControlState.Normal)
            button.tag = index + 1
            button.addTarget(self, action: Selector.init(actions[index]), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            
            let titleLabel : UILabel = UILabel()
            titleLabel.frame = CGRectMake(0, buttonHeight - (buttonHeight / 4), buttonWidth, 20);
            titleLabel.font = UIFont.boldSystemFontOfSize(14)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.text = titles[index]
            button.addSubview(titleLabel)
            position++
        }
    }
    
    //古兰经
    func clickGuLj() {
        print("古兰经")
        let guLJViewController = GuLJViewController()
        self.navigationController?.pushViewController(guLJViewController, animated: true)
    }
    
    //天房方向
    func clickTianFFX() {
        print("天房方向")
        let houseLocationViewController = HouseLocationViewController()
        self.navigationController?.pushViewController(houseLocationViewController, animated: true)
    }
    
    //礼拜时间
    func clickLiBSJ() {
        print("礼拜时间")
    }
    
    //附近位置
    func clickFuJWZ() {
        print("附近位置")
    }
    
    //日历
    func clickRiL() {
        print("日历")
    }
    
    //尊主姓名
    func clickZunZXM() {
        print("尊主姓名")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manlResultArray.count
    }
   
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let info : NSDictionary = manlResultArray[indexPath.row] as! NSDictionary
        let province : NSString = info["admin1"] as! NSString
        let city : NSString = info["admin2"] as! NSString
        let countryInfo : NSDictionary = info["country attrs"] as! NSDictionary
        let countryCode : NSString = countryInfo["code"] as! NSString
        
        let cellTxt : NSString = String(format: "%@ %@ %@", city, province, countryCode)
        cell.textLabel?.text = String(cellTxt)
        return cell
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

