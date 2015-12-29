//
//  BaseViewController.swift
//  Muslim
//
//  Created by LSD on 15/11/3.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, LocationSettingDelegate, ShareUtilsDelegate {
    var popMenuView : UIView!
    var fullPopView : UIView!
    var locationSettingView : LocationSettingView!

    override func viewDidDisappear(animated: Bool) {
        MobClick.beginLogPageView(title)
    }
    override func viewDidAppear(animated: Bool) {
        MobClick.endLogPageView(title)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let greenColor : UIColor = Colors.greenColor        //设置标题栏颜色
        self.navigationController!.navigationBar.barTintColor = greenColor
        //设置标题的字的颜色
        self.navigationController!.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        //设置背景颜色
        self.view.backgroundColor = UIColor.whiteColor()
        
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.hideBottomHairline()
        
        initPopMenuView()
        
        let nibs = NSBundle.mainBundle().loadNibNamed("LocationSettingView", owner: nil, options: nil)
        locationSettingView = nibs.first as! LocationSettingView
        locationSettingView.delegate = self
        locationSettingView.initView()
        locationSettingView.hidden = true
        self.view.addSubview(locationSettingView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (locationSettingView.hidden == false) {
            locationSettingView.hidden = true
        }
    }
    
    func shouldShowLocationView() {
        if (Config.getLat() == 0 && Config.getLng() == 0) {
            showLocationView()
        }
    }
    
    func refreshUserLocation() {
        
    }
    
    func showLocationView() {
        locationSettingView.hidden = false
        locationSettingView.getUserLocation()
        self.view.bringSubviewToFront(locationSettingView)
    }
    
    //通用的菜单弹出界面
    func initPopMenuView(){
        fullPopView = UIView(frame: CGRectMake(0, 64, PhoneUtils.screenWidth, PhoneUtils.screenHeight))
        fullPopView.backgroundColor = Colors.transparent
        fullPopView.hidden = true;
        let tagGestureLable : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("showOrHidePopView"))
        fullPopView.addGestureRecognizer(tagGestureLable);
        
        let itemHight:CGFloat = 40
        let menuWidth:CGFloat = 150
        let menuHight:CGFloat = itemHight * 4
        var menuX :CGFloat = PhoneUtils.screenWidth - menuWidth;
        if(PhoneUtils.rightThemeStyle()){
            menuX = 0
        }
        let menuY :CGFloat = 0;
        popMenuView = UIView(frame: CGRectMake(menuX, menuY, menuWidth, menuHight))
        popMenuView.backgroundColor = UIColor.whiteColor()
        
        
        let titles : [String] = [NSLocalizedString("share", comment:""),
            NSLocalizedString("settings_title", comment:""), NSLocalizedString("about", comment:""),
            NSLocalizedString("feedback", comment:"")]
        
        var item :CGFloat = 0
        for index in 0...3 {
            let button : UIButton = UIButton()
            let itemY :CGFloat = (item * itemHight)
            button.frame = CGRectMake(0, itemY, menuWidth, itemHight)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center//居中
            button.layer.borderWidth = 0.5 //设置边框的宽度
            button.layer.borderColor = Colors.bottomLineColor.CGColor //设置边框的颜色
            button.addTarget(self, action: Selector.init("popMenuClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = index
            button.setTitle(titles[index], forState:UIControlState.Normal)
            popMenuView.addSubview(button)
            item++
        }
        fullPopView.addSubview(popMenuView)
        self.view.addSubview(fullPopView)
    }
    
    //弹出菜单点击事件
    func popMenuClick(item : UIButton){
        showOrHidePopView()
        let tag : NSInteger = item.tag
        if (tag == 0) {
            //分享
            ShareUtils.shared().delegate = self
            ShareUtils.shared().getShareContent()
        }
        else if (tag == 1) {
            //设置
            let settingsViewController = SettingsViewController(nibName:"SettingsViewController", bundle: nil)
            self.pushViewController(settingsViewController)
        }
        else if (tag == 2) {
            //关于
            let aboutviewController = AboutViewController()
            self.pushViewController(aboutviewController)
        }
        else if (tag == 3) {
            //反馈
            let feedbackviewController = FeedbackViewController()
            self.pushViewController(feedbackviewController)
        }
    }
    
    func showOrHidePopView() {
        fullPopView.hidden = !fullPopView.hidden
        self.view.bringSubviewToFront(fullPopView)
    }
    
    func pushViewController(to : UIViewController) {
        let leftImage : UIImage =  UIImage(named: "ic_back")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        to.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("backButtonClicked"))
        self.navigationController?.pushViewController(to, animated: true)
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func appShareContent(content : String) {
        let shareViewController = UIActivityViewController.init(activityItems: [content], applicationActivities: nil)
        self.navigationController?.presentViewController(shareViewController, animated: true, completion: nil)
    }
    
    func getAppShareContentFail() {
        self.view.makeToast(message: NSLocalizedString("net_err", comment: ""))
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
