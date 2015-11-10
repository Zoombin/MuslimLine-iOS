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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("setting_manual_corr", comment:"");
        setupView()
        
        //注册view
        mTableView!.registerNib(UINib(nibName: "SettingAdjustCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func setupView(){
        mTableView = UITableView(frame: CGRectMake(0,0,PhoneUtils.screenWidth,PhoneUtils.screenHeight))
        mTableView.tag = tag1
        mTableView.delegate = self
        mTableView.dataSource = self
        self.view.addSubview(mTableView)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.PrayNameArray.count
    }
    
    //生成界面
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    /**弹出框*/
    var bkgView :UIView!
    func showAlertView(){
        let viewHight:CGFloat = PhoneUtils.screenHeight
        let viewWidth :CGFloat = PhoneUtils.screenWidth
        
        //背景
        bkgView = UIView()
        bkgView.frame = CGRectMake(0, 0, viewWidth, viewHight)
        bkgView.backgroundColor = Colors.trans
        self.view.addSubview(bkgView)
        
        
        //内容显示界面
        let contentViewHight :CGFloat = PhoneUtils.screenHeight
        let contentViewWidth :CGFloat = viewWidth - (60*2)
        let contentView :UIView = UIView(frame: CGRectMake(60,(viewHight-contentViewHight)/2,contentViewWidth,contentViewHight))
        contentView.backgroundColor = Colors.lightGray
        bkgView.addSubview(contentView)
        
        
        //
        

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
