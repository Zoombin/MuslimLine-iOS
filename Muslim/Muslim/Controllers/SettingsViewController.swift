//
//  SettingsViewController.swift
//  Muslim
//
//  Created by LSD on 15/11/5.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var listview: UITableView!
    let width : CGFloat = UIScreen.mainScreen().bounds.width
    let cellIdentifier = "settigCellIdentifier"
    let headCellIdentifier = "HeadCellIdentifier"
    
    var listSection:Int = 0 //全局存储选择状态
    var listRow :Int = 0
    
    var settingData : NSArray! //设置的数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("settings_title", comment:"");
        //注册ListView的adapter findview
        listview!.registerNib(UINib(nibName: "SettingCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        listview!.registerNib(UINib(nibName: "SettingHead", bundle:nil), forCellReuseIdentifier: headCellIdentifier)
        
        loadData()
    }
    
    /**获取设置的json数据*/
    func loadData(){
        let filePath = NSBundle.mainBundle().pathForResource("settings", ofType: "json")
        let txtString = try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
        let data = txtString?.dataUsingEncoding(NSUTF8StringEncoding)
        settingData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
    }
    
    //设置list的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(settingData != nil){
            return settingData.count
        }
        return 0
    }
    
    //自定义分组的头部
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let  headerCell = tableView.dequeueReusableCellWithIdentifier(headCellIdentifier) as! SettingHead
        headerCell.backgroundColor = Colors.lightBlue
        if(settingData != nil){
            let mDict : NSDictionary  =  settingData.objectAtIndex(section) as! NSDictionary
            let name : NSString = mDict.objectForKey("name") as! NSString
            headerCell.head_txt.text = name as String
        }
        return headerCell
    }
    
    //设置每个item的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num :Int = 0;
        if(settingData != nil){
            let mDict : NSDictionary  =  settingData.objectAtIndex(section) as! NSDictionary
            let setArr :NSArray = mDict.objectForKey("set") as! NSArray
            num = setArr.count
            return num
        }
        return num
    }
    
    //进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingCell : SettingCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingCell
        let section = indexPath.section
        let row = indexPath.row
        
        
        let mDict : NSDictionary  =  settingData.objectAtIndex(section) as! NSDictionary
        let setArr :NSArray = mDict.objectForKey("set") as! NSArray
        let set : NSDictionary = setArr.objectAtIndex(row) as! NSDictionary
        
        let title :NSString = set.objectForKey("title") as! NSString
        let subtitle :NSString = set.objectForKey("subtitle") as! NSString
        settingCell.sub_title.text = subtitle as String //副标题
        settingCell.title.text = title as String //标题
        settingCell.title2.text = title as String //标题
        if(subtitle.length != 0){
            settingCell.sub_title.hidden = false
            settingCell.title.hidden = false
            settingCell.title2.hidden = true
        }else{
            settingCell.sub_title.hidden = true
            settingCell.title.hidden = true
            settingCell.title2.hidden = false
        }
        
        let right_type :NSString = set.objectForKey("right_type") as! NSString
        if(right_type.isEqualToString("1")){
            //需要设置子选项 但不需要显示在右边
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = true;
        }
        if(right_type.isEqualToString("2")){
            //有更多选项需要跳转到其他界面
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = true;
            
            settingCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        if(right_type.isEqualToString("3")){
            //显示开关按钮
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = false;
            settingCell.my_switch.tag = row //区分是哪个开关
            
            //开关改变事件
            settingCell.my_switch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            
            settingCell.my_switch.enabled = true
            
            settingCell.sub_title.hidden = true
            settingCell.title.hidden = true
            settingCell.title2.hidden = true
            let select = getItemSelect(section, row: row)
            if(2 == select){
                //不可用
                //settingCell.my_switch.enabled = false
                settingCell.my_switch.setOn(false, animated: true)
                
                //settingCell.sub_title.hidden = false
                //settingCell.title.hidden = false
            }else{
                settingCell.title2.hidden = false
                if(0 == select){
                    //关
                    settingCell.my_switch.setOn(false, animated: true)
                }
                if(1 == select){
                    // 开
                    settingCell.my_switch.setOn(true, animated: true)
                }
            }
        }
        if(right_type.isEqualToString("4")){
            //需要设置子选项，子选项点击后要显示在
            settingCell.right_txt.hidden = false;
            settingCell.my_switch.hidden = true;
            
            let select = getItemSelect(section, row: row)
            let subset :NSArray = set.objectForKey("subset") as! NSArray
            let right_txt : NSString = subset.objectAtIndex(select) as! NSString
            settingCell.right_txt.text = right_txt as String
        }
        return settingCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        let mDict : NSDictionary  =  settingData.objectAtIndex(section) as! NSDictionary
        let setArr :NSArray = mDict.objectForKey("set") as! NSArray
        let set : NSDictionary = setArr.objectAtIndex(row) as! NSDictionary
        let title :NSString = set.objectForKey("title") as! NSString
        let subset :NSArray = set.objectForKey("subset") as! NSArray
        
        listSection = section;
        listRow = row;
        
        if(subset.count > 0 ){
            //需要弹窗
            var cancel :Bool = true
            if(section == 0 && row == 0){
                cancel = false
            }
            let select = getItemSelect(section, row: row)
            showAlertView(title, subset: subset,select:select,cancel: cancel)
            return
        }
        let right_type :NSString = set.objectForKey("right_type") as! NSString
        if(right_type.isEqualToString("2")){
            //有更多选项需要跳转到其他界面
            if(section == 0 && row == 1){
                //手动更正
                let settingAdjustViewController = SettingAdjustViewController()
                self.pushViewController(settingAdjustViewController)
            }
            if(section == 1){
                if(0 == row){
                    //文本&译文
                    let quranTextViewController = QuranTextViewController()
                    self.pushViewController(quranTextViewController)
                }
                if(row == 1){
                    //朗诵
                    let quranAudioViewController = QuranAudioViewController()
                    self.pushViewController(quranAudioViewController)
                }
            }
            
        }
    }
    
    
    /**选择弹窗*/
    var bkgView :UIView!
    func showAlertView(title :NSString, subset:NSArray!, select :Int ,cancel:Bool){
        let viewHight:CGFloat = PhoneUtils.screenHeight
        let viewWidth :CGFloat = PhoneUtils.screenWidth
        
        bkgView = UIView()
        bkgView.frame = CGRectMake(0, 0, viewWidth, viewHight)
        bkgView.backgroundColor = Colors.trans
        self.view.addSubview(bkgView)
        
        let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("removeAlertView"))
        if(cancel){
            bkgView.addGestureRecognizer(tagGesture)
        }
        
        
        let itemHight :CGFloat = 50
        let contentViewWidth :CGFloat = viewWidth-(30*2)
        var num = subset.count + 1 //加一个标题
        if(cancel){
            num = num + 1 // 加一尾部
        }
        let count : CGFloat = CGFloat(num)
        let contentViewHight :CGFloat = itemHight * count
        
        //内容显示界面
        let contentView :UIView = UIView(frame: CGRectMake(30,(viewHight-contentViewHight)/2,contentViewWidth,contentViewHight))
        contentView.backgroundColor = Colors.lightGray
        bkgView.addSubview(contentView)
        
        //标题
        let titleLable :UILabel = UILabel(frame: CGRectMake(0,0,contentViewWidth,itemHight))
        titleLable.text = "  "+(title as String)
        titleLable.backgroundColor = UIColor.whiteColor()
        titleLable.textColor = Colors.greenColor
        titleLable.font = UIFont.systemFontOfSize(Dimens.text_size_larger)
        contentView.addSubview(titleLable)
        
        //item
        let itemCount = subset.count
        for index in 0...(itemCount - 1) {
            let item :UILabel = UILabel(frame: CGRectMake(0,itemHight * CGFloat(index+1),contentViewWidth,itemHight))
            let text : NSString = subset.objectAtIndex(index) as! NSString
            item.text = "  "+(text as String)
            item.userInteractionEnabled = true//设置点击事件
            let tagGestureLable : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("popItemClick:"))
            item.tag = index
            item.addGestureRecognizer(tagGestureLable);
            contentView.addSubview(item)
            
            let line :UIView = UIView(frame: CGRectMake(0,itemHight * CGFloat(index+1),contentViewWidth,1))
            line.backgroundColor = UIColor.lightGrayColor()
            contentView.addSubview(line)
            
            let button:UIButton = UIButton(frame: CGRectMake(contentViewWidth - 50, itemHight * CGFloat(index+1) , 50, 50))
            button.setImage(UIImage(named: "Selected"), forState: UIControlState.Selected)
            button.setImage(UIImage(named: "noSelected"), forState: UIControlState.Normal)
            button.tag = index
            if(index == select){
                button.selected = true
            }
            
            button.userInteractionEnabled = false
            //button.addTarget(self, action: Selector.init("popItemClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            contentView.addSubview(button)
        }
        
        //尾部取消界面
        if(cancel){
            let foot:UIView = UIView(frame: CGRectMake(0,itemHight * CGFloat(itemCount+1),contentViewWidth,itemHight))
            foot.backgroundColor = UIColor.whiteColor()
            contentView.addSubview(foot)
            let cancelLable :UILabel = UILabel(frame: CGRectMake(contentViewWidth-50,itemHight * CGFloat(itemCount+1),50,itemHight))
            cancelLable.text = NSLocalizedString("cancel", comment:"")
            cancelLable.textColor = UIColor.lightGrayColor()
            contentView.addSubview(cancelLable)
        }
    }
    
    /**开关改变事件*/
    func stateChanged (sender :UISwitch){
        let tag : NSInteger = sender.tag
        if(2 == tag){
            //自动设置
            if(sender.on){
                Config.saveAutoSwitch(1)
            }else{
                Config.saveAutoSwitch(0)
            }
        }
        if(8 == tag){
            //默认播放
            if(sender.on){
                Config.saveSlientMode(1)
            }else{
                Config.saveSlientMode(0)
            }
        }
    }
    
    /**选中按钮点击事件**/
    func popItemClick(sender : UIGestureRecognizer) {
        //sender.selected = !sender.selected
        removeAlertView()
        
        let btSelect : NSInteger = sender.view!.tag
        Log.printLog(btSelect)
        //处理切换事件
        switch(listSection){
        case 0:
            //第一组
            switch(listRow){
            case 0:
                //穆斯林派别
                Config.saveFaction(btSelect)
                break
            case 3:
                //祈祷算法
                Config.saveAsrCalculationjuristicMethod(btSelect)
                break
            case 4:
                //礼拜时间约定
                Config.savePrayerName(btSelect)
                break
            case 5:
                //高纬度调整
                Config.saveHighLatitudeAdjustment(btSelect)
                break
            case 6:
                //夏令日
                Config.saveDaylightSavingTime(btSelect)
                break
            case 7:
                //小时制
                Config.saveTimeFormat(btSelect)
                listview.reloadData()
                break
            default:
                break
            }
            break
        case 1:
            //第二组
            break
        case 2:
            //第三组
            switch(listRow){
            case 0:
                //日历选择
                Config.saveCalenderSelection(btSelect)
                listview.reloadData()
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    /**获取item选中状态*/
    func getItemSelect(section :Int,row : Int)->Int{
        var select :Int = 0;
        switch(section){
        case 0:
            switch(row){
            case 0:
                select = Config.faction
                break
            case 2:
                select = Config.AutoSwitch
                break
            case 3:
                select = Config.CalculationMethods
                break
            case 4:
                select = Config.PrayerName
                break
            case 5:
                select = Config.HighLatitude
                break
            case 6:
                select = Config.Daylight
                break
            case 7:
                select = Config.TimeFormat
                break
            case 8:
                select = Config.SlinetMode
                break
            default:
                break
            }
            break
        case 2:
            switch(row){
            case 0:
                select = Config.IsIslamicCalendar
                break
            default:
                break
            }
        default:
            break
        }
        return select
    }
    
    
    
    /**移除弹弹窗**/
    func removeAlertView() {
        bkgView.removeFromSuperview()
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
