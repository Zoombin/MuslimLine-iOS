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
    
    var settingData : NSArray! //设置的数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("settings_title", comment:"");
        //注册ListView的adapter findview
        listview!.registerNib(UINib(nibName: "SettingCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        listview!.registerNib(UINib(nibName: "SettingHead", bundle:nil), forCellReuseIdentifier: headCellIdentifier)
        
        initAlertView()
        loadData()
        
    }
    
    /**获取设置的json数据*/
    func loadData(){
        let filePath = NSBundle.mainBundle().pathForResource("settings", ofType: "json")
        let txtString = try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
        let data = txtString?.dataUsingEncoding(NSUTF8StringEncoding)
        settingData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
    }
    
    
    /**初始化弹窗界面*/
   
    func initAlertView(){
        
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
    
    
    
    //let arr : NSArray = mObj.objectForKey("set") as! NSArray
    ///let dict : NSDictionary = arr.objectAtIndex(0) as! NSDictionary
    ///let string : NSString = dict.objectForKey("title") as! String
    //print(string)
    
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingCell : SettingCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingCell
        let section = indexPath.section
        let row = indexPath.row
        
        
        let mDict : NSDictionary  =  settingData.objectAtIndex(section) as! NSDictionary
        let setArr :NSArray = mDict.objectForKey("set") as! NSArray
        let set : NSDictionary = setArr.objectAtIndex(row) as! NSDictionary
        
        let title :NSString = set.objectForKey("title") as! NSString
        let subtitle :NSString = set.objectForKey("subtitle") as! NSString
        if(subtitle.length != 0){
            settingCell.sub_title.text = subtitle as String //副标题
            settingCell.title.text = title as String //标题
        }else{
            settingCell.title2.text = title as String //标题
        }
        let right_txt :NSString = set.objectForKey("right_txt") as! NSString
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
        }
        if(right_type.isEqualToString("4")){
            //需要设置子选项，子选项点击后要显示在
            settingCell.right_txt.hidden = false;
            settingCell.my_switch.hidden = true;
            
            settingCell.right_txt.text = right_txt as String;
        }
        return settingCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let mDict : NSDictionary  =  settingData.objectAtIndex(section) as! NSDictionary
        let setArr :NSArray = mDict.objectForKey("set") as! NSArray
        let set : NSDictionary = setArr.objectAtIndex(row) as! NSDictionary
        let title :NSString = set.objectForKey("title") as! NSString
        let subset :NSArray = set.objectForKey("subset") as! NSArray
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(section == 0 && row == 0){
            showAlertView(title, subset: subset, cancel: false)
        }else{
            showAlertView(title, subset: subset, cancel: true)
        }
    }
    
    
    /**选择弹窗*/
    var bkgView :UIView!
    func showAlertView(title :NSString, subset:NSArray!, cancel:Bool){
        if(subset.count > 0){
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
                contentView.addSubview(item)
                
                let line :UIView = UIView(frame: CGRectMake(0,itemHight * CGFloat(index+1),contentViewWidth,1))
                line.backgroundColor = UIColor.lightGrayColor()
                contentView.addSubview(line)
                
                let button:UIButton = UIButton(frame: CGRectMake(contentViewWidth - 50, itemHight * CGFloat(index+1) , 50, 50))
                button.setImage(UIImage(named: "Selected"), forState: UIControlState.Selected)
                button.setImage(UIImage(named: "noSelected"), forState: UIControlState.Normal)
                button.addTarget(self, action: Selector.init("buttonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
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
    }
    
    func buttonClick(sender : UIButton) {
        sender.selected = !sender.selected
        removeAlertView()
    }
    
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
