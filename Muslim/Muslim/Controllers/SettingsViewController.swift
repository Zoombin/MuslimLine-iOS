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
            settingCell.right_img.hidden = true;
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = true;
        }
        if(right_type.isEqualToString("2")){
            //有更多选项需要跳转到其他界面
            settingCell.right_img.hidden = false;
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = true;
            
            settingCell.right_img.image = UIImage(named:"arrow_right")
        }
        if(right_type.isEqualToString("3")){
            //显示开关按钮
            settingCell.right_img.hidden = true;
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = false;
        }
        if(right_type.isEqualToString("4")){
            //需要设置子选项，子选项点击后要显示在
            settingCell.right_img.hidden = true;
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
    
    
    func alterVier(){
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
