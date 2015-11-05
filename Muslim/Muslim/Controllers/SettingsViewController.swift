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
    
    let settingData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("settings_title", comment:"");
        //注册ListView的adapter findview
        listview!.registerNib(UINib(nibName: "SettingCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        listview!.registerNib(UINib(nibName: "SettingHead", bundle:nil), forCellReuseIdentifier: headCellIdentifier)
    }
    
    
    //设置list的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    //自定义分组的头部
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let  headerCell = tableView.dequeueReusableCellWithIdentifier(headCellIdentifier) as! SettingHead
        headerCell.backgroundColor = Colors.lightBlue
        switch (section) {
        case 0:
            headerCell.head_txt.text = "礼拜时间"
            break
        case 1:
            headerCell.head_txt.text = "古兰经"
            break
        case 2:
            headerCell.head_txt.text = "日历"
            break
        default:
            break
        }
        return headerCell
    }
    
    //设置每一个分组的行数
    func numberOfRowsInSection(section: Int) -> Int{
        var num :Int = 0;
        if(section == 0){
            num =  10
        }
        if(section == 1){
             num =  3
        }
        if(section == 2){
            num =  1
        }
        return num
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingCell : SettingCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingCell
        if((indexPath.row % 3) == 0){
            settingCell.right_img.hidden = true;
            settingCell.right_txt.hidden = true;
            settingCell.my_switch.hidden = false;
            
        }
        if((indexPath.row % 3) == 1){
            settingCell.right_txt.hidden = true;
            settingCell.right_img.hidden = false;
            settingCell.my_switch.hidden = true;
            
            settingCell.right_img.image = UIImage(named:"arrow_right")
        }
        if((indexPath.row % 3) == 2){
            settingCell.right_txt.hidden = false;
            settingCell.right_img.hidden = true;
            settingCell.my_switch.hidden = true;
            
            settingCell.right_txt.text = "提示文字"
        }
        return settingCell
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
