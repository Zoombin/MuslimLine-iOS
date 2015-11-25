//
//  MediaSettingViewController.swift
//  Muslim

//  唤礼音设置

//
//  Created by LSD on 15/11/25.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MediaSettingViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,mAlarmMediaDelegate{
    var AlarmType :Int = 0 //哪种时段的闹钟
    
    var mTableView:UITableView!
    let cellIdentifier = "cellIdentifier"
    
    var dataArray : NSArray = NSArray()
    var mp3Array : NSArray = NSArray()
    var select : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("prayer_adhan_settings", comment:"");
        
        AlarmMediaMr.getInstance().delegate = self
        
        mTableView = UITableView(frame: CGRectMake(0,64,PhoneUtils.screenWidth,PhoneUtils.screenHeight-64))
        mTableView!.registerNib(UINib(nibName: "MediaSettingCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        mTableView.delegate = self
        mTableView.dataSource = self
        self.view.addSubview(mTableView)
        
        getData()
    }
    
    func getData(){
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            select = Config.getShiaAlarm(AlarmType)
            mp3Array = Config.alarm_type_files_shia
            dataArray = Config.alarm_type_shia
        }else{
            //逊尼派
            select = Config.getSunniAlarm(AlarmType)
            mp3Array = Config.alarm_type_files_sunni
            dataArray = Config.alarm_type_sunni
        }
        mTableView.reloadData()
    }
    
    func loading(position:Int){
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: position, inSection: 0)
        let cell : MediaSettingCell =  mTableView.cellForRowAtIndexPath(indexPath) as! MediaSettingCell
        cell.ivStatus.hidden = true
        cell.ivPro.hidden = false
        cell.ivPro.startAnimating()
    }
    func loadingfinish(position:Int){
        let mp3Name = mp3Array[position] as! String
        let path = AlarmMediaMr.getAlarmMediaPath() + mp3Name
        AlarmMediaMr.getInstance().play(path)
        saveSelect(position)
    }
    func loadFail(){
        self.view.makeToast(message: "下载失败")
        mTableView.reloadData()
    }
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    //生成界面
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MediaSettingCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!MediaSettingCell
        let row = indexPath.row
        if(0 == row){
            cell.ivTip.image = UIImage(named: "prayer_remind_off")
        }else{
            cell.ivTip.image = UIImage(named: "prayer_remind_on")
        }
        cell.tvTitle.text = dataArray[row] as? String
        cell.ivPro.hidden = true
        cell.ivStatus.hidden = false
        cell.ivStatus.stopAnimating()
        if(select == row){
            cell.ivStatus.image = UIImage(named: "prayer_sound_selected")
        }else{
            let path = AlarmMediaMr.getAlarmMediaPath() + (mp3Array[row] as! String)
            if(NSFileManager.defaultManager().fileExistsAtPath (path)){
                 cell.ivStatus.hidden = true
            }else{
                cell.ivStatus.image = UIImage(named: "prayer_download")
            }
        }
        
        return cell
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        AlarmMediaMr.getInstance().stop()
        let row =  indexPath.row
        if(row == 0){
            saveSelect(row)
            return
        }
        if(row == 1){
            saveSelect(row)
            return
        }
        let mp3Name = mp3Array[row] as! String
        if(mp3Name.isEmpty){
            //2 默认
            let defalt = NSBundle.mainBundle().pathForResource("aghati", ofType: "mp3")
            saveSelect(row)
            AlarmMediaMr.getInstance().play(defalt!)
            return
        }else{
            let path = AlarmMediaMr.getAlarmMediaPath() + mp3Name
            if(NSFileManager.defaultManager().fileExistsAtPath (path)){
                saveSelect(row)
                AlarmMediaMr.getInstance().play(path)
            }else{
                AlarmMediaMr.getInstance().loadNewAlarmMedia(row)
            }
        }
    }
    
    func saveSelect(position:Int){
        select = position
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            Config.setShiaAlarm(AlarmType, select: position)
        }else{
            //逊尼派
            Config.setSunniAlarm(AlarmType, select: position)
        }
        mTableView.reloadData()
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
