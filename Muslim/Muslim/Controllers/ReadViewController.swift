//
//  ReadViewController.swift
//  Muslim

//   朗读界面

//
//  Created by LSD on 15/11/18.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ReadViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource , UIActionSheetDelegate,httpClientDelegate{
    //常量
    let bt_back = 100
    let bt_previous = 200
    let bt_next = 300
    let bt_contry = 400
    let bt_reader = 500
    let bt_play = 600
    let bt_play1 = 601
    let bt_bookmark = 700
    let bt_more = 800
    
    //传递的数据
    var EXTRA_BOOKMARK_JUMP : Bool = false
    var EXTRA_SURA : Int?
    var EXTRA_AYA :Int?
    var EXTRA_SCOLLPOSITION :Int?
    
    
    var readLeftView : ReadLeftView!
    var readRightView : ReadRightView!
    let cellIdentifier = "cellIdentifier"
    var mTableView:UITableView!
    var readViewHead : ReadViewHead!
    
    var chapter:Chapter?
    var sura:Int = 0
    var quranArray : NSMutableArray = NSMutableArray()
    var select:Int = 0
    
    var httpClient : MSLHttpClient = MSLHttpClient() //网络请求
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(EXTRA_SURA != nil){
            sura = EXTRA_SURA!
        }
        
        //网络代理
        httpClient.delegate = self
        
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
        
        
        setTitleBar() //设置titlebar
    }
    
    override func viewDidAppear(animated: Bool) {
        getQurans(sura)
        scrollViewTo(6-1) //滚动到上次阅读
        addHeadView() //tableviewHead
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
    
    //添加头部
    func addHeadView(){
        let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("ReadViewHead", owner: nil, options: nil)
        readViewHead = nibs.lastObject as! ReadViewHead
        readViewHead.btPlay1.tag = bt_play1
        readViewHead.btPlay1.hidden = true
        readViewHead.btPlay1.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("headViewClick"))
        readViewHead.addGestureRecognizer(tagGesture)
        // 除1,9章，其他章最前面加一句话
        if (sura != 1 && sura != 9) {
            let quran:Quran  = Quran()
            quran.sura = sura
            quran.aya = 0
            //quranArray.insertObject(quran, atIndex: 0)//加在第一个位置
            //tableView增加一个头部
            
            mTableView.tableHeaderView = readViewHead
        }
    }

    
    /**获取古兰经*/
    func getQurans(sura:Int){
        self.sura = sura
        chapter = FMDBHelper.getInstance().getChapter(sura)
        setTitelBarData()
        quranArray = FMDBHelper.getInstance().getQurans(sura)
        
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
    
    /***滚动到某个位置*/
    func scrollViewTo(position: NSNumber) {
        let IndexPath :NSIndexPath = NSIndexPath.init(forItem: position.integerValue, inSection: 0)
        mTableView.scrollToRowAtIndexPath(IndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
    
    func cleanSelect(){
        for i in 0...quranArray.count-1{
            let quran :Quran = quranArray[i] as! Quran
            quran.isSelected = false
        }
    }
    
    /***  下载音频回调    ****/
    func succssResult(result : NSObject, tag : NSInteger) {
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: select, inSection: 0)
        let cell : ReadViewCell =  mTableView.cellForRowAtIndexPath(indexPath) as! ReadViewCell
        cell.ivPro.stopAnimating()
        cell.ivPro.hidden = true
        cell.btPlay.hidden = false
        cell.btPlay.setImage(UIImage(named:"ic_pause"), forState: UIControlState.Normal)
        
        var path = result as? String
        path = path!.stringByReplacingOccurrencesOfString("file:///", withString: "")
        print(path)
        AudioPlayerMr.getInstance().play(path!)
        //mTableView.reloadData()
    }
    
    func errorResult(error : NSError, tag : NSInteger) {
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: select, inSection: 0)
        let cell : QuranTextCell =  mTableView.cellForRowAtIndexPath(indexPath) as! QuranTextCell
        
        cell.ivSelected.hidden = true
        cell.ivDownload.hidden = false
        cell.probar.stopAnimating()
        cell.probar.hidden = true
        self.view.makeToast(message: "下载失败")
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
        
        //设置界面
        cell.ivPro.hidden = true
        let quran :Quran = quranArray[indexPath.row] as! Quran
        cell.textQuran.text = String(format: "%d. %@", quran.aya!,quran.text == nil ?"":quran.text!)
        cell.textCn.text = String(format: "%d. %@", quran.aya!,quran.text_zh == nil ?"":quran.text_zh!)
        if(quran.isSelected == true){
            cell.OptionsView.hidden = false
            cell.contentView.backgroundColor = Colors.lightGray
            
            //收藏状态
            let isbookmark :Bool = FMDBHelper.getInstance().isBookmark(quran.sura!, aya: quran.aya!)//原方法这样操作太耗资源  -- 要改进
            if (isbookmark) {
                cell.btBookMark.setImage(UIImage(named: "ic_bookmarks_selected"), forState: UIControlState.Normal)
            } else {
                cell.btBookMark.setImage(UIImage(named: "ic_bookmarks_no_selected"), forState: UIControlState.Normal)
            }
            
            //播放状态
            if(AudioPlayerMr.getInstance().isPlaying){
                if(AudioPlayerMr.getInstance().isPlayCurrent(indexPath.row, sura: quran.sura!, isHead: false)){
                    cell.btPlay.setImage(UIImage(named:"ic_pause"), forState: UIControlState.Normal)
                }else{
                    cell.btPlay.setImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
                }
            }else{
                cell.btPlay.setImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
            }
        }else{
            cell.OptionsView.hidden = true
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
        //点击事件
        cell.btPlay.tag = bt_play
        cell.btPlay.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btBookMark.tag = bt_bookmark
        cell.btBookMark.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btMore.tag = bt_more
        cell.btMore.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
       
        //自适应高度
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
        
        return cell
        
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let quran :Quran = quranArray[indexPath.row] as! Quran
        cleanSelect()
        resetHeadView()
        quran.isSelected = true
        select = indexPath.row
        tableView.reloadData()
    }
    
    //actionSheet点击
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        let tag = actionSheet.tag
        if(201 == tag){
            //更多操作
            switch(buttonIndex){
            case 0:
                share()
                break
            case 1:
                textCopy()
                break
            default:
                break
            }
        }
        if(202 == tag){
            //分享
            switch(buttonIndex){
            case 0:
               //电子邮件
                break
            case 1:
               //短信
                break
            default:
                break
            }
        }
    }
    
    //分享
    func share(){
        let actionSheet = UIActionSheet()
        actionSheet.tag = 202
        actionSheet.title = "分享"
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("电子邮件")
        actionSheet.addButtonWithTitle("短信")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.showInView(self.view)
    }
    
    //复制
    func textCopy(){
        let quran :Quran = quranArray[select] as! Quran
        
        let board = UIPasteboard.generalPasteboard()
        board.string = String(quran.text)+"\n"+String(quran.text_zh)
        self.view.makeToast(message: "已复制到剪切板")
    }
    
    //播放音频
    func playAudio(isHead:Bool){
        let quran :Quran = quranArray[select] as! Quran
        var audioPath :String = ""
        if(isHead){
            audioPath = AudioPlayerMr.getFirstAudioPath() + AudioPlayerMr.getFirstAudioName()
        }else{
            audioPath = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
        }
         if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
            //已经存在
            if(AudioPlayerMr.getInstance().isPlaying){
               //正在播放当前的 (停止)
                AudioPlayerMr.getInstance().stop()
            }else{
                AudioPlayerMr.getInstance().setDataAndPlay(quranArray, position: select, sura: sura,isHead: false)
            }
         }else{
            let indexPath:NSIndexPath = NSIndexPath.init(forItem: select, inSection: 0)
            let cell : ReadViewCell =  mTableView.cellForRowAtIndexPath(indexPath) as! ReadViewCell
            //下载
            var fileName:String = ""
            if(isHead){
                fileName = AudioPlayerMr.getFirstAudioUrl() + AudioPlayerMr.getFirstAudioName()
            }else{
                fileName = AudioPlayerMr.getAudioUrl(quran) + AudioPlayerMr.getAudioName(quran)
            }
            let url = Constants.downloadBaseUri + fileName.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            cell.btPlay.hidden = true
            cell.ivPro.hidden = false
            cell.ivPro.startAnimating()
            
            let outPath:String = AudioPlayerMr.getAudioPath(quran)
            httpClient.downloadDocument(url,outPath: outPath)
        }
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
            self.pushViewController(quranTextVC)
            break
        case bt_reader:
            let quranAudioVC = QuranAudioViewController()
            self.pushViewController(quranAudioVC)
            break
        case bt_play:
            playAudio(false)
            break
        case bt_play1:
            playAudio(true)
            break
        case bt_bookmark:
            let quran :Quran = quranArray[select] as! Quran
            let isbookmark :Bool = FMDBHelper.getInstance().isBookmark(quran.sura!, aya: quran.aya!)
            if (isbookmark) {
               FMDBHelper.getInstance().deleteBookmark(quran.sura!, aya: quran.aya!)
            } else {
                FMDBHelper.getInstance().insertBookmark(quran.sura!, aya: quran.aya!)
            }
            mTableView.reloadData()
            break
        case bt_more:
            let actionSheet = UIActionSheet()
            actionSheet.tag = 201
            actionSheet.title = "更多操作"
            actionSheet.delegate = self
            actionSheet.addButtonWithTitle("分享")
            actionSheet.addButtonWithTitle("复制到剪切板")
            actionSheet.addButtonWithTitle("取消")
            actionSheet.cancelButtonIndex = 2
            actionSheet.showInView(self.view)
            break
        default:
            break
        }
    }
    
    //头部点击
    func headViewClick(){
        
        readViewHead.btPlay1.hidden = false
        readViewHead.backgroundColor = Colors.lightGray
        cleanSelect()
        mTableView.reloadData()
    }
    
    func resetHeadView(){
        readViewHead.backgroundColor = UIColor.whiteColor()
        readViewHead.btPlay1.hidden = true
    }
    
    //保存数据
    override func viewDidDisappear(animated: Bool) {
        Config.setCurrentRura(sura)
        Config.setCurrentPosition(3)
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
