//
//  ReadViewController.swift
//  Muslim

//   朗读界面

//
//  Created by LSD on 15/11/18.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ReadViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource , UIActionSheetDelegate,mAudioPlayerDelegate{
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
    var EXTRA_SCOLLPOSITION :Int = 0
    
    
    var readLeftView : ReadLeftView!
    var readRightView : ReadRightView!
    let cellIdentifier = "cellIdentifier"
    var mTableView:UITableView!
    var readViewHead : ReadViewHead!
    
    var chapter:Chapter?
    var sura:Int = 0
    var quranArray : NSMutableArray = NSMutableArray()
    var select:Int = 0
    var isHead:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(EXTRA_SURA != nil){
            sura = EXTRA_SURA!
        }
        if(EXTRA_BOOKMARK_JUMP){
            //阅读记录或者书签跳转
            select = EXTRA_SCOLLPOSITION
            EXTRA_BOOKMARK_JUMP = false
        }
        
        //播放代理
        AudioPlayerMr.getInstance().delegate = self
        
        
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
        
        addHeadView() //tableviewHead
        //初始化播放位置
        if(AudioPlayerMr.getInstance().isPlaying && AudioPlayerMr.getInstance().sura == sura){
            select = AudioPlayerMr.getInstance().position
        }else{
            if (sura == 1 || sura == 9) {
                //没有头部 - 设置第一个选中
                let quran :Quran = quranArray[0] as! Quran
                quran.isSelected = true
            }
        }
        //准备滚动的位置的选中状态
        if(select>0){
            let quran :Quran = quranArray[select] as! Quran
            quran.isSelected = true
        }
        //刷新界面
        mTableView.reloadData()
        //滚动到相应的位置
        if(select>0){
            scrollViewTo(select) //滚动到正在阅读的位置
        }else{
            //滚动到顶部
             scrollViewToTop()
        }
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
        readViewHead.ivPro.hidden = true
        readViewHead.btPlay1.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("headViewClick"))
        readViewHead.addGestureRecognizer(tagGesture)
        // 除1,9章，其他章最前面加一句话
        if (sura != 1 && sura != 9) {
            let quran:Quran  = Quran()
            quran.sura = sura
            quran.aya = 0
            //tableView增加一个头部
            if(!AudioPlayerMr.getInstance().isPlaying || AudioPlayerMr.getInstance().sura != sura){
                readViewHead.btPlay1.hidden = false
                readViewHead.ivPro.hidden = true
            }
            readViewHead.backgroundColor = Colors.lightGray
            mTableView.tableHeaderView = readViewHead
        }else{
            mTableView.tableHeaderView = nil
        }
    }
    
    
    /**获取古兰经*/
    func getQurans(sura:Int){
        self.sura = sura
        chapter = FMDBHelper.getInstance().getChapter(sura)
        setTitelBarData()
        
        quranArray = FMDBHelper.getInstance().getQurans(sura)
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
        mTableView.scrollToRowAtIndexPath(IndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    /***滚动到顶部*/
    func scrollViewToTop() {
        scrollViewTo(0)
        mTableView.setContentOffset(CGPointMake(0,0), animated: false)
    }
    
    func cleanSelect(){
        for i in 0...quranArray.count-1{
            let quran :Quran = quranArray[i] as! Quran
            quran.isSelected = false
        }
    }
    
    func cleanAudioStatus(){
        for i in 0...quranArray.count-1{
            let quran :Quran = quranArray[i] as! Quran
            quran.audioStatus = 0
        }
    }
    
    /**播放回调**/
    func finishPlaying(){
        if(sura != AudioPlayerMr.getInstance().sura){
            //不是在播放当前章节
            return
        }
        Log.printLog("播放完成")
        cleanAudioStatus()
        cleanSelect()
        resetHeadView()
        mTableView.reloadData()
    }
    //开始播放
    func startPlaying(position:Int){
        if(sura != AudioPlayerMr.getInstance().sura ){
            return
        }
        if(-1 == position){
            //播放头部
            readViewHead.btPlay1.hidden = false
            readViewHead.btPlay1.setImage(UIImage(named:"ic_pause"), forState: UIControlState.Normal)
            readViewHead.ivPro.hidden = true
            readViewHead.ivPro.stopAnimating()
            return
        }
        
        self.select = position
        cleanAudioStatus()
        cleanSelect()
        
        let quran :Quran = quranArray[select] as! Quran
        quran.audioStatus = 1
        quran.isSelected = true
        mTableView.reloadData()
        scrollViewTo(select)
    }
    //加载数据
    func loading(position:Int){
        if(-1 == position){
            readViewHead.btPlay1.hidden = true
            readViewHead.ivPro.hidden = false
            readViewHead.ivPro.startAnimating()
            return
        }
        if(sura != AudioPlayerMr.getInstance().sura){
            return
        }
        self.select = position
        cleanAudioStatus()
        let quran :Quran = quranArray[select] as! Quran
        quran.audioStatus = -1
        
        cleanSelect()
        quran.isSelected = true
        mTableView.reloadData()
    }
    func loadFail(){
        if(sura != AudioPlayerMr.getInstance().sura){
            return
        }
        self.view.makeToast(message: "下载失败")
        cleanAudioStatus()
        resetHeadView()
        mTableView.reloadData()
    }
    //下一章节
    func loadNext(sura:Int){
        self.sura = sura
        viewDidAppear(false)
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
            
            //加载状态
            cell.ivPro.hidden = true
            cell.ivPro.stopAnimating()
            
            //播放状态
            if(AudioPlayerMr.getInstance().isPlayCurrent(indexPath.row, sura: quran.sura!,isHead: false)){
                //播放当前
                cell.btPlay.hidden = false
                cell.ivPro.hidden = true
                cell.btPlay.setImage(UIImage(named:"ic_pause"), forState: UIControlState.Normal)
            }else{
                if(quran.audioStatus == -1){
                    //加载中
                    cell.btPlay.hidden = true
                    cell.ivPro.hidden = false
                    cell.ivPro.startAnimating()
                }else{
                    cell.btPlay.hidden = false
                    cell.ivPro.hidden = true
                    cell.btPlay.setImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
                }
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
    func playAudio(){
        let quran :Quran = quranArray[select] as! Quran
        let audioPath :String = AudioPlayerMr.getAudioPath(quran) + AudioPlayerMr.getAudioName(quran)
        
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: select, inSection: 0)
        let cell : ReadViewCell =  mTableView.cellForRowAtIndexPath(indexPath) as! ReadViewCell
        
        //已经存在
        if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
            if(AudioPlayerMr.getInstance().isPlayCurrent(select, sura: quran.sura!,isHead: false)){
                //正在播放当前的 (停止)
                AudioPlayerMr.getInstance().stop()
                cell.btPlay.setImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
            }else{
                AudioPlayerMr.getInstance().stop()
                AudioPlayerMr.getInstance().setDataAndPlay(quranArray, position: select, sura: quran.sura!,isHead: false)
            }
        }else{
            AudioPlayerMr.getInstance().stop()
            AudioPlayerMr.getInstance().loadDataAndPlay(quranArray, position: select, sura: quran.sura!,isHead: false)
        }
    }
    
    func playHeadAudio(){
        let audioPath :String = AudioPlayerMr.getFirstAudioPath() + AudioPlayerMr.getFirstAudioName()
        if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
            //已经存在
            if(AudioPlayerMr.getInstance().isPlayCurrent(-1, sura: sura,isHead: true)){
                //正在播放当前的 (停止)
                AudioPlayerMr.getInstance().stop()
                readViewHead.btPlay1.setImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
            }else{
                AudioPlayerMr.getInstance().stop()
                AudioPlayerMr.getInstance().setDataAndPlay(quranArray, position: -1, sura: sura,isHead: true)
            }
        }else{
            AudioPlayerMr.getInstance().stop()
            AudioPlayerMr.getInstance().loadDataAndPlay(quranArray, position: -1, sura: sura,isHead: true)
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
            if(sura > FMDBHelper.getInstance().getMinSura()){
                sura = sura - 1
                //清除上次位置
                select = 0
                viewDidAppear(false)
            }
            break
        case bt_next:
            if(sura < FMDBHelper.getInstance().getMaxSura()){
                sura = sura + 1
                //清除上次位置
                select = 0
                viewDidAppear(false)
            }
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
            playAudio()
            break
        case bt_play1:
            playHeadAudio()
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
        readViewHead.ivPro.hidden = true
        readViewHead.ivPro.stopAnimating()
        readViewHead.backgroundColor = Colors.lightGray
        cleanSelect()
        mTableView.reloadData()
    }
    
    func resetHeadView(){
        if(readViewHead.btPlay1.hidden == false){
            readViewHead.backgroundColor = UIColor.whiteColor()
            readViewHead.btPlay1.hidden = true
            readViewHead.btPlay1.setImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
            readViewHead.ivPro.hidden = true
            readViewHead.ivPro.stopAnimating()
        }
    }
    
    //保存数据
    override func viewDidDisappear(animated: Bool) {
        //保存正在阅读的位置
        Config.setCurrentRura(sura)
        Config.setCurrentPosition(select)
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
