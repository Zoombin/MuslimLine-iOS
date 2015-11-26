//
//  AllahNamesViewController.swift
//  Muslim
//
//  Created by LSD on 15/11/13.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class AllahNamesViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    var mTableView:UITableView!
    let cellIdentifier = "AllahNameCellIdentifier"
    var namesData : NSArray! //设置的数据
    var namesPlist : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_names_label", comment:"");
        
        loadData()
        setupView()
    }
    
    /**获取设置的json数据*/
    func loadData(){
        let filePath = NSBundle.mainBundle().pathForResource("allahnames", ofType: "json")
        let txtString = try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
        let data = txtString?.dataUsingEncoding(NSUTF8StringEncoding)
        namesData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
   
        
        let namespath = NSBundle.mainBundle().pathForResource("allah_names", ofType: "plist") 
        namesPlist = NSArray(contentsOfFile: namespath!)
    }
    
    
    func setupView(){
        mTableView = UITableView(frame: CGRectMake(0,64,PhoneUtils.screenWidth,PhoneUtils.screenHeight-64))
        //注册ListView
        mTableView!.registerNib(UINib(nibName: "AllahNameCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.separatorColor = UIColor.whiteColor()
        self.view.addSubview(mTableView)
    }
    
    //设置每个item的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesData.count
    }
    
    
    //进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let allahNameCell : AllahNameCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AllahNameCell
        let row = indexPath.row

        let mDict : NSDictionary  =  namesData.objectAtIndex(row) as! NSDictionary
        let nameEn :NSString = mDict.objectForKey("transliteration") as! NSString
        let nameOt :NSString = mDict.objectForKey("arabic") as! NSString
        let nameLocaliz = namesPlist[row]
        
        allahNameCell.indexLable.text = String(format: "%d", row+1)
        allahNameCell.nameEn.text = nameEn as String
        allahNameCell.nameLocaliz.text = nameLocaliz as? String
        allahNameCell.nameOt.text = nameOt as String
        
        return allahNameCell
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
