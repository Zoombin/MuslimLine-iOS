//
//  SettingAdjustViewController.swift
//  Muslim

//  手动调节

//  Created by LSD on 15/11/7.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class SettingAdjustViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    var tag1 = 100
    var mTableView:UITableView!
    let cellIdentifier = "SettingAdjustCellIdentifier"
    
    var tag2 = 200
    var alertTableView:UITableView! //弹出界面
    let alertcellIdentifier = "alertcellIdentifier"
    
    var listRow :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("setting_manual_corr", comment:"");
        setupView()
    
    }
    
    func setupView(){
        mTableView = UITableView(frame: CGRectMake(0,0,PhoneUtils.screenWidth,PhoneUtils.screenHeight))
        //注册view
        mTableView!.registerNib(UINib(nibName: "SettingAdjustCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        mTableView.tag = tag1
        mTableView.delegate = self
        mTableView.dataSource = self
        self.view.addSubview(mTableView)
    }
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tag = tableView.tag
        if(tag == 100){
            return 50
        }
        if(tag == 200){
            return 45
        }
        return 0
    }
    
    //个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tag = tableView.tag
        if(tag == 100){
            return Config.PrayNameArray.count
        }
        if(tag == 200){
            return 121
        }
        return 0
    }
    
    //生成界面
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tag = tableView.tag
        if(tag == 100){
            let cell : SettingAdjustCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingAdjustCell
            let row = indexPath.row
            cell.txtName.text = Config.PrayNameArray[row] as? String
            let stringName : NSString = NSLocalizedString("setting_pray_adjuest_time_min", comment:"")
            switch(row){
            case 0:
                cell.txtTime.text = String(format: "%d%@", (Config.FajrTime - Constants.ADJUSTTIME), stringName)
                break
            case 1:
                cell.txtTime.text = String(format: "%d%@", (Config.SunriseTime - Constants.ADJUSTTIME), stringName)
                break
            case 2:
                cell.txtTime.text = String(format: "%d%@", (Config.DhuhrTime - Constants.ADJUSTTIME), stringName)
                break
            case 3:
                cell.txtTime.text = String(format: "%d%@", (Config.AsrTime - Constants.ADJUSTTIME), stringName)
                break
            case 4:
                cell.txtTime.text = String(format: "%d%@", (Config.MaghribTime - Constants.ADJUSTTIME), stringName)
                break
            case 5:
                cell.txtTime.text = String(format: "%d%@", (Config.IshaaTime - Constants.ADJUSTTIME), stringName)
                break
            default:
                break
            }
            return cell
        }else{
            let cell : SettingAdjustAlertCell = tableView.dequeueReusableCellWithIdentifier(alertcellIdentifier, forIndexPath: indexPath) as! SettingAdjustAlertCell
            cell.contentView.backgroundColor = Colors.lightGray
            let row = indexPath.row
            cell.txtValue.text = String(format: "%d%@", (row - Constants.ADJUSTTIME), NSLocalizedString("setting_pray_adjuest_time_min", comment:""))
            let select = getaAdjustItemSelect(listRow)
            if(select == row){
                cell.btCheckBox.selected = true
            }else{
                cell.btCheckBox.selected = false
            }
            cell.btCheckBox.tag = row
            cell.btCheckBox.addTarget(self, action: Selector.init("adjustItemClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let tag = tableView.tag
        let row = indexPath.row
        if(tag == 100){
            listRow = row
            let select = getaAdjustItemSelect(listRow)
            showAlertView(select)
        }
        if(tag == 200){
            
        }
    }
    
    /**弹出框*/
    var bkgView :UIView!
    func showAlertView(position :Int){
        let viewWidth :CGFloat = PhoneUtils.screenWidth
        let viewHight:CGFloat = PhoneUtils.screenHeight-64
        
        //背景
        bkgView = UIView()
        bkgView.frame = CGRectMake(0, 64, viewWidth, viewHight)
        bkgView.backgroundColor = Colors.trans
//      let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("removeAlertView"))
//      bkgView.addGestureRecognizer(tagGesture)
        self.view.addSubview(bkgView)
        
        
        //内容显示界面
        let contentViewHight :CGFloat = viewHight
        let contentViewWidth :CGFloat = viewWidth - (30*2)
        let contentView :UIView = UIView(frame: CGRectMake(30,0,contentViewWidth,contentViewHight))
        contentView.backgroundColor = Colors.lightGray
        bkgView.addSubview(contentView)
        
        
        //头部
        let head:UIView = UIView(frame: CGRectMake(0,0,contentViewWidth,50))
        head.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(head)
        let titleLable :UILabel = UILabel(frame: CGRectMake(20,0,contentViewWidth,50))
        titleLable.text = NSLocalizedString("setting_manual_corr_dlg", comment:"")
        titleLable.textColor = Colors.greenColor
        titleLable.font = UIFont.systemFontOfSize(Dimens.text_size_larger)
        titleLable.textAlignment = NSTextAlignment.Left
        contentView.addSubview(titleLable)
        
        
        //列表
        alertTableView = UITableView(frame: CGRectMake(0,50,contentViewWidth,contentViewHight-100))
        alertTableView!.registerNib(UINib(nibName: "SettingAdjustAlertCell", bundle:nil), forCellReuseIdentifier: alertcellIdentifier)
        alertTableView.tag = tag2
        alertTableView.delegate = self
        alertTableView.dataSource = self
        let index : NSNumber = NSNumber(integer: position)
        self.performSelector(Selector.init("scrollViewTo:"), withObject: index, afterDelay: 2.0/10)//滚动
        contentView.addSubview(alertTableView)
        
        
        //尾部
        let foot:UIView = UIView(frame: CGRectMake(0,contentViewHight-50,contentViewWidth,50))
        foot.backgroundColor = UIColor.whiteColor()
        let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("removeAlertView"))
        foot.addGestureRecognizer(tagGesture)
        contentView.addSubview(foot)
        let cancelLable :UILabel = UILabel(frame: CGRectMake(contentViewWidth-50,contentViewHight-50,50,50))
        cancelLable.text = NSLocalizedString("cancel", comment:"")
        cancelLable.textColor = UIColor.lightGrayColor()
        contentView.addSubview(cancelLable)
        
    }
    
    /***滚动到某个位置*/
    func scrollViewTo(position: NSNumber) {
        let IndexPath :NSIndexPath = NSIndexPath.init(forItem: position.integerValue, inSection: 0)
        alertTableView.scrollToRowAtIndexPath(IndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
    }
    
    /***按钮框点击事件*/
    func adjustItemClick(sender : UIButton) {
        let position = sender.tag
        switch (listRow) {
        case 0:
            Config.saveFajrTime(position);
            break;
        case 1:
            Config.saveSunriseTime(position);
            break;
        case 2:
            Config.saveDhuhrTime(position);
            break;
        case 3:
            Config.saveAsrTime(position);
            break;
        case 4:
            Config.saveMaghribTime(position);
            break;
        case 5:
            Config.saveIshaaTime(position);
            break;
        default:
            break
        }
        
//        alertTableView.reloadData()
        mTableView.reloadData()
        removeAlertView()
    }
    
    /**获取item选中状态*/
    func getaAdjustItemSelect(itemRow :Int)->Int{
        var select :Int = 0;
        
        switch(itemRow){
        case 0:
            select = Config.FajrTime
            break
        case 1:
            select = Config.SunriseTime
            break
        case 2:
            select = Config.DhuhrTime
            break
        case 3:
            select = Config.AsrTime
            break
        case 4:
            select = Config.MaghribTime
            break
        case 5:
            select = Config.IshaaTime
            break
        default:
            break
        }
        return select
    }
    
    
    /**移除弹弹窗**/
    func removeAlertView() {
        bkgView.removeFromSuperview()
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
