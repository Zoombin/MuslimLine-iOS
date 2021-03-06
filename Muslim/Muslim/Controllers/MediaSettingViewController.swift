//
//  MediaSettingViewController.swift
//  Muslim

//  唤礼音设置

//
//  Created by LSD on 15/11/25.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import AudioToolbox

class MediaSettingViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,mAlarmMediaDelegate{
    var AlarmType :Int = 0 //哪种时段的闹钟
    
    var mTableView:UITableView!
    let cellIdentifier = "cellIdentifier"
    
    var dataArray : NSArray = NSArray()
    var mp3Array : NSArray = NSArray()
    var statusArray :NSMutableArray = NSMutableArray()
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
        select = PrayTimeUtil.getPrayMediaStatu(AlarmType)
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            mp3Array = Config.alarm_type_files_shia
            dataArray = Config.alarm_type_shia
        }else{
            //逊尼派
            mp3Array = Config.alarm_type_files_sunni
            dataArray = Config.alarm_type_sunni
        }
        for index in 0...mp3Array.count-1 {
            let name = mp3Array[index] as! String
            var path :String = ""
            if(!name.isEmpty){
                path = AlarmMediaMr.getAlarmMediaLocalPath(name)
                if(NSFileManager.defaultManager().fileExistsAtPath (path)){
                    statusArray[index] = 1   //1: 存在， 0不存在， -1真正下载
                }else{
                    statusArray[index] = 0
                }
            }else{
                //默认铃声和静音
                statusArray[index] = 1
            }
        }
        mTableView.reloadData()
    }
    
    func loading(position:Int){
        statusArray[position] = -1
        mTableView.reloadData()
    }
    func loadingfinish(position:Int){
        select = position
        let mp3Name = mp3Array[position] as! String
        var path = ""
        if(!mp3Name.isEmpty){
            path = AlarmMediaMr.getAlarmMediaLocalPath(mp3Name)
        }
        AlarmMediaMr.getInstance().stop()
        AlarmMediaMr.getInstance().play(position,path:path)
        saveSelect(position)
        
        statusArray[position] = 1
        mTableView.reloadData()
    }
    func loadFail(position:Int){
        self.view.makeToast(message: "下载失败")
        statusArray[position] = 0
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
        cell.ivPro.stopAnimating()
        cell.ivStatus.hidden = false
        if(select == row){
            cell.ivStatus.image = UIImage(named: "prayer_sound_selected")
        }else{
            let statu :Int = statusArray[row] as! Int
            if( statu == -1){
                cell.ivStatus.hidden = true
                cell.ivPro.hidden = false
                cell.ivPro.startAnimating()
            }else if(statu == 1){
                cell.ivStatus.hidden = true
            }else{
                cell.ivStatus.hidden = false
                cell.ivStatus.image = UIImage(named: "prayer_download")
            }
        }
        
        return cell
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if(AlarmMediaMr.getInstance().isPlaying && AlarmMediaMr.getInstance().mediaIndex == indexPath.row){
            AlarmMediaMr.getInstance().stop()
            return
        }
        let row =  indexPath.row
        if(row == 0){
            AlarmMediaMr.getInstance().stop()
            saveSelect(row)
            return
        }
        let mp3Name = mp3Array[row] as! String
        if(mp3Name.isEmpty){
            // 默认
            let defalt = NSBundle.mainBundle().pathForResource("sms-received1", ofType: "caf")
            saveSelect(row)
            AlarmMediaMr.getInstance().stop()
            AlarmMediaMr.getInstance().play(row,path:defalt!)
            return
        }else{
            let path = AlarmMediaMr.getAlarmMediaLocalPath(mp3Name)
            if(NSFileManager.defaultManager().fileExistsAtPath (path)){
                saveSelect(row)
                AlarmMediaMr.getInstance().stop()
                AlarmMediaMr.getInstance().play(row,path:path)
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
    
    override func viewDidDisappear(animated: Bool) {
        AlarmMediaMr.getInstance().stop()
        //页面关闭 刷新通知
        LocalNoticationUtils.showLocalNotification()
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
