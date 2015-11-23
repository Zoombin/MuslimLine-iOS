//
//  BaseViewController.swift
//  Muslim
//
//  Created by LSD on 15/11/3.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var popMenuView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let greenColor : UIColor = Colors.greenColor        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        //设置背景颜色
        self.view.backgroundColor = UIColor.whiteColor()
        
        initPopMenuView()
    }
    
    //通用的菜单弹出界面
    func initPopMenuView(){
        let itemHight:CGFloat = 40
        let menuWidth:CGFloat = 150
        let menuHight:CGFloat = itemHight * 4
        let menuX :CGFloat = PhoneUtils.screenWidth - menuWidth;
        let menuY :CGFloat = 64;
        popMenuView = UIView(frame: CGRectMake(menuX, menuY, menuWidth, menuHight))
        popMenuView.backgroundColor = UIColor.whiteColor()
        popMenuView.hidden = true;
        
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
            button.layer.borderColor = UIColor.lightGrayColor().CGColor //设置边框的颜色
            button.addTarget(self, action: Selector.init("popMenuClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = index
            button.setTitle(titles[index], forState:UIControlState.Normal)
            popMenuView.addSubview(button)
            item++
        }
        self.view.addSubview(popMenuView)
    }
    
    //弹出菜单点击事件
    func popMenuClick(item : UIButton){
        popMenuView.hidden = true;
        let tag : NSInteger = item.tag
        if (tag == 0) {
            //分享
        }
        else if (tag == 1) {
            //设置
            let settingsViewController = SettingsViewController()
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
        popMenuView.hidden = !popMenuView.hidden
        self.view.bringSubviewToFront(popMenuView)
    }
    
    func pushViewController(to : UIViewController) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("back", comment: ""), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationController?.pushViewController(to, animated: true)
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
