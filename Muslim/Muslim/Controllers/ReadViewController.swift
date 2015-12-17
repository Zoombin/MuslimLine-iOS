//
//  ReadViewController.swift
//  Muslim

//   朗读界面

//
//  Created by LSD on 15/11/18.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import AVFoundation

class ReadViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource , UIActionSheetDelegate,mAudioPlayerDelegate, UIScrollViewDelegate{
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
    var EXTRA_AYA :Int = 0
    var EXTRA_SCOLLPOSITION :Int = 0
    
    
    var readLeftView : ReadLeftView!
    var readRightView : ReadRightView!
    let cellIdentifier = "cellIdentifier"
    var mTableView:UITableView!
    var readViewHead : ReadViewHead!
    
    var chapter:Chapter?
    var sura:Int = 0
    var quranArray : NSMutableArray = NSMutableArray()
    var select:Int = -1
    var isHead:Bool = false
    
    var slider : UISlider!
    var isScolling :Bool = false
    var isToach :Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioSessionInterruption", name: AVAudioSessionInterruptionNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioSessionRouteChange:", name: AVAudioSessionRouteChangeNotification, object: nil)
        if(EXTRA_SURA != nil){
            sura = EXTRA_SURA!
        }
        if(EXTRA_BOOKMARK_JUMP){
            //阅读记录/或者书签跳转/或者搜索
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
        
        mTableView.separatorColor = Colors.greenColor
        mTableView.delegate = self
        mTableView.dataSource = self
        //mTableView.estimatedRowHeight = 100
        //mTableView.rowHeight = UITableViewAutomaticDimension

        self.view.addSubview(mTableView)
        
        slider = UISlider()
        slider.addTarget(self, action: Selector.init("sliderValueChanged"), forControlEvents: UIControlEvents.AllTouchEvents)
        slider.addTarget(self, action: Selector.init("touchCancel"), forControlEvents: UIControlEvents.TouchUpInside)
        slider.addTarget(self, action: Selector.init(), forControlEvents: UIControlEvents.TouchUpInside)
        slider.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        slider.setThumbImage(UIImage(named: "fast_scoll_bar"), forState: UIControlState.Normal)
        slider.minimumTrackTintColor = UIColor.clearColor()
        slider.maximumTrackTintColor = UIColor.clearColor()
        slider.layer.borderColor = UIColor.clearColor().CGColor
        slider.minimumValue = 0
        slider.maximumValue = 100
        self.view.addSubview(slider)
        
        let rotationValue : CGFloat = CGFloat(M_PI * -1.5)
        let rotation : CGAffineTransform = CGAffineTransformMakeRotation(rotationValue)
        slider.transform = rotation
        slider.frame = CGRectMake(CGRectGetMaxX(mTableView.bounds) - 15, 64, 20, mTableView.bounds.size.height)
        
        setTitleBar() //设置titlebar
        
        self.view.makeToastActivity()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.makeToastActivity()
    }
    
    override func viewDidAppear(animated: Bool) {
        getQurans(sura)
        
        addHeadView() //tableviewHead
        //初始化播放位置
        if(AudioPlayerMr.getInstance().isPlaying && AudioPlayerMr.getInstance().sura == sura){
            select = AudioPlayerMr.getInstance().position
        }else{
            if(select > 0){
                //外面进来的选中位置
            }else{
                if (sura == 1 || sura == 9) {
                    //没有头部 - 设置第一个选中
                    select = 0
                }else{
                    select = -1
                }
            }
        }
        //准备滚动的位置的选中状态
        if(select >= 0){
            resetHeadView()
            
            let quran :Quran = quranArray[select] as! Quran
            quran.isSelected = true
        }else{
            selectHeadView()
        }
        //刷新界面
        mTableView.reloadData()
        //滚动到相应的位置
        if(select > 0){
            scrollViewTo(select) //滚动到正在阅读的位置
        }else{
            //滚动到顶部
             scrollViewToTop()
        }
        touchCancel() //隐藏
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
        readLeftView.btBack.tag = bt_back
        readLeftView.btBack.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
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
        // 除1,9章，tableView增加一个头部
        if (sura != 1 && sura != 9) {
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
        self.view.hideToastActivity()
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
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!isToach){
             self.performSelector(Selector.init("hideFastSscollBar"), withObject: nil, afterDelay: 2.0)
        }
    }
    
    func touchCancel(){
        isToach = false
        self.performSelector(Selector.init("hideFastSscollBar"), withObject: nil, afterDelay: 2.0)
    }
    
    func sliderValueChanged() {
        isToach = true
        let offsetY : CGFloat = CGFloat(slider.value / 100.0) * CGFloat(mTableView.contentSize.height - 460);
        mTableView.contentOffset = CGPointMake(0, offsetY)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!isScolling){
            isScolling = true
            refreshFastSscollBar()
        }
        mTableView.contentOffset = CGPointMake(0, mTableView.contentOffset.y)
        slider.value = Float(100.0 * mTableView.contentOffset.y) / Float(mTableView.contentSize.height - 460)
    }
    
    /**更新快速滚动条状态*/
    func refreshFastSscollBar(){
        if(quranArray.count > 12){
            mTableView.showsVerticalScrollIndicator = false
            slider.hidden = false
        }else{
            mTableView.showsVerticalScrollIndicator = true
            slider.hidden = true
        }
    }
    
    func hideFastSscollBar(){
        if(isToach){
            return
        }
        slider.hidden = true
        isScolling = false
        isToach = false
    }
    
    /***滚动到某个位置*/
    func scrollViewTo(position: Int) {
        let IndexPath :NSIndexPath = NSIndexPath.init(forItem: position, inSection: 0)
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
            //不是播放当前章节
            return
        }
        if(-1 == position){
            //播放头部
            readViewHead.btPlay1.hidden = false
            readViewHead.btPlay1.setBackgroundImage(UIImage(named:"ic_pause"), forState: UIControlState.Normal)
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
    //暂停播放
    func pausePlaying(position:Int){
        if(sura != AudioPlayerMr.getInstance().sura ){
            //不是播放当前章节
            return
        }
        if(-1 == position){
            //播放头部
            readViewHead.btPlay1.hidden = false
            readViewHead.btPlay1.setBackgroundImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
            readViewHead.ivPro.hidden = true
            readViewHead.ivPro.stopAnimating()
            return
        }
        
        self.select = position
        cleanAudioStatus()
        cleanSelect()
        
        let quran :Quran = quranArray[select] as! Quran
        quran.audioStatus = 0
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
        self.view.makeToast(message: NSLocalizedString("toast_download_failure", comment:""))
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
        let content1 = String(format: "%d. %@", quran.aya!,quran.text == nil ?"":quran.text!)
        let content2 = String(format: "%d. %@",quran.aya!,quran.text_zh == nil ?"":quran.text_zh!)
        let labelWidth : Int32 = Int32(mTableView.frame.size.width - (15 * 2))
        if (quran.unSelectedHeight == 0 && quran.selectedHeight == 0) {
            let height1 = MSLFrameUtil.getLabHeight(content1, fontSize: 17, width: labelWidth)
            let height2 = MSLFrameUtil.getLabHeight(content2, fontSize: 17, width: labelWidth)
            quran.selectedHeight = CGFloat(height1 + height2 + 30 + 50)
            quran.unSelectedHeight = CGFloat(height1 + height2 + 20)
        }
        
        if(quran.isSelected == true) {
            return quran.selectedHeight
        } else {
            return quran.unSelectedHeight
        }
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quranArray.count
    }
    
    //生成界面
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        mTableView!.registerNib(UINib(nibName: "ReadViewCell", bundle:nil), forCellReuseIdentifier: String(format: "%d_%d_%@",sura, indexPath.row, Config.getCurrentLanguage()))
        let cell : ReadViewCell = tableView.dequeueReusableCellWithIdentifier(String(format: "%d_%d_%@",sura, indexPath.row, Config.getCurrentLanguage()), forIndexPath: indexPath) as! ReadViewCell
        
        
        //设置界面
        cell.ivPro.hidden = true
        let quran :Quran = quranArray[indexPath.row] as! Quran
        cell.textQuran.text = String(format: "%d. %@", quran.aya!,quran.text == nil ?"":quran.text!)
        let text_zh = quran.text_zh! as NSString
        if(text_zh.length == 0){
            cell.textCn.text = " "
        }else{
            let textContent = NSString(format: "%d. %@",quran.aya!,quran.text_zh == nil ?"":quran.text_zh!)
            if(Config.getCurrentLanguageIndex() == 36){
                //需要转换html
                let attrStr = try! NSMutableAttributedString(
                    data: textContent.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
                attrStr.addAttribute(kCTFontAttributeName as String, value: cell.textCn.font, range: NSMakeRange(0,attrStr.length))
                cell.textCn.attributedText = attrStr
            }else{
                cell.textCn.text = textContent as String
            }
        }
        
        cell.calculateHeight(quran)
        if(quran.isSelected == true){
            cell.OptionsView.hidden = false
            cell.contentView.backgroundColor = Colors.lightGray
            
            //收藏状态
            let isbookmark :Bool = FMDBHelper.getInstance().isBookmark(quran.sura!, aya: quran.aya!)//原方法这样操作太耗资源  -- 要改进
            if (isbookmark) {
                cell.btBookMark.setBackgroundImage(UIImage(named: "ic_bookmarks_selected"), forState: UIControlState.Normal)
            } else {
                cell.btBookMark.setBackgroundImage(UIImage(named: "ic_bookmarks_no_selected"), forState: UIControlState.Normal)
            }
            
            //加载状态
            cell.ivPro.hidden = true
            cell.ivPro.stopAnimating()
            
            //播放状态
            if(AudioPlayerMr.getInstance().isPlayCurrent(indexPath.row, sura: quran.sura!,isHead: false)){
                //播放当前
                cell.btPlay.hidden = false
                cell.ivPro.hidden = true
                cell.btPlay.setBackgroundImage(UIImage(named:"ic_pause"), forState: UIControlState.Normal)
            }else{
                if(quran.audioStatus == -1){
                    //加载中
                    cell.btPlay.hidden = true
                    cell.ivPro.hidden = false
                    cell.ivPro.startAnimating()
                }else{
                    cell.btPlay.hidden = false
                    cell.ivPro.hidden = true
                    cell.btPlay.setBackgroundImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
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
        //cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
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
    }
    
    //分享
    func share(){
        let quran : Quran = quranArray[select] as! Quran
        let content = String(format: "%@\n%@", quran.text!, quran.text_zh!)
        let shareViewController = UIActivityViewController.init(activityItems: [content], applicationActivities: nil)
        self.navigationController?.presentViewController(shareViewController, animated: true, completion: nil)
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
        
        //已经存在
        if(NSFileManager.defaultManager().fileExistsAtPath (audioPath)){
            if(AudioPlayerMr.getInstance().isPlayCurrent(select, sura: quran.sura!,isHead: false)){
                //正在播放当前的 (暂停)
                AudioPlayerMr.getInstance().pause()
            }else{
                if(AudioPlayerMr.getInstance().isPause && AudioPlayerMr.getInstance().position == select){
                    AudioPlayerMr.getInstance().play()
                }else{
                    AudioPlayerMr.getInstance().stop()
                    AudioPlayerMr.getInstance().setDataAndPlay(quranArray, position: select, sura: quran.sura!,isHead: false)
                }
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
                //正在播放当前的 (暂停)
                AudioPlayerMr.getInstance().pause()
            }else{
                if(AudioPlayerMr.getInstance().isPause && AudioPlayerMr.getInstance().position == -1){
                    AudioPlayerMr.getInstance().play()
                }else{
                    AudioPlayerMr.getInstance().stop()
                    AudioPlayerMr.getInstance().setDataAndPlay(quranArray, position: -1, sura: sura,isHead: true)
                }
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
                select = -1
                viewDidAppear(false)
            }
            break
        case bt_next:
            if(sura < FMDBHelper.getInstance().getMaxSura()){
                sura = sura + 1
                //清除上次位置
                select = -1
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
    
    //恢复头部
    func resetHeadView(){
        //if(readViewHead.btPlay1.hidden == false){
            readViewHead.backgroundColor = UIColor.whiteColor()
            readViewHead.btPlay1.hidden = true
            readViewHead.btPlay1.setBackgroundImage(UIImage(named:"ic_play"), forState: UIControlState.Normal)
            readViewHead.ivPro.hidden = true
            readViewHead.ivPro.stopAnimating()
        //}
    }
    
    //选中头部
    func selectHeadView(){
        readViewHead.btPlay1.hidden = false
        readViewHead.ivPro.hidden = true
        readViewHead.ivPro.stopAnimating()
        readViewHead.backgroundColor = Colors.lightGray
    }
    
    //保存数据
    override func viewDidDisappear(animated: Bool) {
        //保存正在阅读的位置
        Config.setCurrentRura(sura)
        Config.setCurrentPosition(select)
    }
    
    //后边播放音乐中断
    func audioSessionInterruption(){
        AudioPlayerMr.getInstance().pause()
    }
    
    func audioSessionRouteChange(notifi : NSNotification){
        AudioPlayerMr.getInstance().pause()
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
