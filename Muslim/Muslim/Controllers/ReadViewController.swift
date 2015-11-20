//
//  ReadViewController.swift
//  Muslim

//   朗读界面

//
//  Created by LSD on 15/11/18.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ReadViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    let bt_back = 100
    let bt_previous = 200
    let bt_next = 300
    let bt_contry = 400
    let bt_reader = 500
    
    var EXTRA_BOOKMARK_JUMP : Bool = false
    var EXTRA_SURA : Int?
    var EXTRA_AYA :Int?
    var EXTRA_SCOLLPOSITION :Int?
    
    var readLeftView : ReadLeftView!
    var readRightView : ReadRightView!
    let cellIdentifier = "cellIdentifier"
    var mTableView:UITableView!
    
    var chapter:Chapter?
    var sura:Int?
    var quranArray : NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLace :UIImageView = UIImageView(frame: CGRectMake(0,0,16.5,PhoneUtils.screenHeight))
        leftLace.backgroundColor = UIColor(patternImage: UIImage(named:"lace_left")!)
        self.view.addSubview(leftLace)
        let rightLace :UIImageView = UIImageView(frame: CGRectMake(PhoneUtils.screenWidth - 16.5,0,16.5,PhoneUtils.screenHeight))
        rightLace.backgroundColor = UIColor(patternImage: UIImage(named:"lace_right")!)
        self.view.addSubview(rightLace)
        
        mTableView = UITableView(frame: CGRectMake(16.5,64,PhoneUtils.screenWidth-(16.5*2),PhoneUtils.screenHeight-64))
        mTableView!.registerNib(UINib(nibName: "ReadViewCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        mTableView.separatorColor = Colors.greenColor
        mTableView.delegate = self
        mTableView.dataSource = self
        
        mTableView.estimatedRowHeight = 100
        mTableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(mTableView)
        
        setTitleBar()
        getQurans(EXTRA_SURA!)
    }
    
    func setTitleBar(){
        //头部右边的veiw
        let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("ReadRightView", owner: nil, options: nil)
        readRightView = nibs.lastObject as! ReadRightView
        readRightView.btPrevious.tag = bt_previous
        readRightView.btPrevious.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        
        readRightView.btNext.tag = bt_next
        readRightView.btNext.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        
        readRightView.btCountry.tag = bt_contry
        readRightView.btCountry.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        
        readRightView.btReader.tag = bt_reader
        readRightView.btReader.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: readRightView)
        
        //头部左边的View
        let nibsL : NSArray = NSBundle.mainBundle().loadNibNamed("ReadLeftView", owner: nil, options: nil)
        readLeftView = nibsL.lastObject as? ReadLeftView
        readLeftView.ivBack.tag = bt_back
        readLeftView.ivBack.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: readLeftView)
    }
    
    
    /**获取古兰经*/
    func getQurans(sura:Int){
        self.sura = sura
        chapter = FMDBHelper.getInstance().getChapter(sura)
        setTitelBarData()
        let array : NSMutableArray = FMDBHelper.getInstance().getQurans(sura)
        // 除1,9章，其他章最前面加一句话
        if (sura != 1 && sura != 9) {
            let quran:Quran  = Quran()
            quran.sura = sura
            quran.aya = 0
            quranArray.addObject(quran)//加在第一个位置
            quranArray.addObjectsFromArray(array as [AnyObject])
        }else{
            quranArray.addObjectsFromArray(array as [AnyObject])
        }
        mTableView.reloadData()
    }
    

    /**设置头部数据*/
    func setTitelBarData(){
        if(chapter != nil){
            readLeftView.suraTitle.text = chapter?.name_arabic as? String
            let subtext :String = String(format: "%d. %@", (chapter?.sura )!, (chapter?.name_transliteration as? String)!)
            readLeftView.suraSubTitle.text = subtext
            
            readRightView.btCountry.setImage(UIImage(named: Config.getCurrentCountryIcon()), forState: UIControlState.Normal)
            readRightView.btReader.setImage(UIImage(named: Config.getCurrentReader().stringByReplacingOccurrencesOfString(" ", withString: "_").lowercaseString), forState: UIControlState.Normal)
        }
    }
    
    func cleanSelect(){
        for i in 0...quranArray.count-1{
            let quran :Quran = quranArray[i] as! Quran
            quran.isSelected = false
        }
    }
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let quran :Quran = quranArray[indexPath.row] as! Quran
        if(quran.isSelected == true){
            return 230
        }else{
            return 180
        }
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quranArray.count
    }
    
    //生成界面
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell : ReadViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!ReadViewCell
        cell.ivPro.hidden = true
        
        let quran :Quran = quranArray[indexPath.row] as! Quran
        cell.textQuran.text = String(format: "%d. %@", quran.aya!,quran.text == nil ?"":quran.text!)
        cell.textCn.text = String(format: "%d. %@", quran.aya!,quran.text_zh == nil ?"":quran.text_zh!)
        if(quran.isSelected == true){
            cell.OptionsView.hidden = false
            cell.contentView.backgroundColor = Colors.lightGray
        }else{
            cell.OptionsView.hidden = true
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
       
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
        
        return cell
        
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let quran :Quran = quranArray[indexPath.row] as! Quran
        cleanSelect()
        quran.isSelected = true
        tableView.reloadData()
    }

    
    /**bt点击*/
    func onBtnClick(button:UIButton){
        let tag = button.tag
        switch(tag){
        case bt_back:
            self.navigationController?.popViewControllerAnimated(true)
            break
        case bt_previous:
            break
        case bt_next:
            break
        case bt_contry:
            let quranTextVC = QuranTextViewController()
            self.navigationController?.pushViewController(quranTextVC, animated: true)
            break
        case bt_reader:
            let quranAudioVC = QuranAudioViewController()
            self.navigationController?.pushViewController(quranAudioVC, animated: true)
            break
        default:
            break
        }
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
