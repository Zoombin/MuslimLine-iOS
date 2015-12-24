//
//  GuLJViewController.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class GuLJViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var tabIndex = 1
    
    let cellIdentifier = "myCell"
    @IBOutlet weak var guLJlistView: UITableView!//章节listview
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    let markCellIdentifier = "markCell"
    @IBOutlet weak var bmarkListview: UITableView! //书签listview
    @IBOutlet weak var nomarkLable: UILabel! 
    
    
    var dataArray : NSMutableArray = NSMutableArray() //章节列表
    var translated_sura_titles : NSArray = NSArray() //翻译列表
    
    var bookmarkArray : NSMutableArray = NSMutableArray() //书签列表
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_quran_label", comment:"")
        self.view.backgroundColor = Colors.greenColor
        let rightImage : UIImage =  UIImage(named: "search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image : rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("searchButtonClicked"))
        
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadChaptersData()
        loadBookMarkData()
        addHeadView()
    }

    
    /***tab切换*/
    func segmentedControlSelect() {
        if (segmentedControl.selectedSegmentIndex == 0) {
            tabIndex = 1
            
            guLJlistView.hidden = false
            bmarkListview.hidden = true
            nomarkLable.hidden = true
        } else {
            tabIndex = 2
            
            guLJlistView.hidden = true
            if(bookmarkArray.count == 0){
                //没有书签
                bmarkListview.hidden = true
                nomarkLable.hidden = false
            }else{
                bmarkListview.hidden = false
                nomarkLable.hidden = true
            }
        }
    }
    /**搜索按钮*/
    func searchButtonClicked() {
        let guljSearchViewController = GuLJSearchViewController()
        self.pushViewController(guljSearchViewController)
    }
    
    
    //初始化界面
    func setupView(){
        segmentedControl.setTitle(NSLocalizedString("frag_first", comment:""), forSegmentAtIndex: 0)
        segmentedControl.setTitle(NSLocalizedString("frag_second", comment:""), forSegmentAtIndex: 1)
        nomarkLable.text = NSLocalizedString("nobookmark", comment:"")
        //注册ListView的adapter
        guLJlistView.tag = 100
        guLJlistView!.registerNib(UINib(nibName: "GuLJCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        bmarkListview.tag = 200
        bmarkListview!.registerNib(UINib(nibName: "BookMarkCell", bundle:nil), forCellReuseIdentifier: markCellIdentifier)
        
        //这个方法是用来监听segmentedControl的值是否有变化，也就是说，有没有切换过所以用了 UIControlEvents.ValueChanged
        segmentedControl.addTarget(self, action: Selector.init("segmentedControlSelect"), forControlEvents: UIControlEvents.ValueChanged)
        SegmentedControlUtil.changeSegmentedControlColor(segmentedControl)
        
        tabIndex = 1
        guLJlistView.hidden = false
        nomarkLable.hidden = true
        bmarkListview.hidden = true
    }
    
    //添加头部
    var firstbookmark :Bookmark = Bookmark()
    func addHeadView(){
        let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("guLJViewHead", owner: nil, options: nil)
        let readViewHead = nibs.lastObject as! guLJViewHead
        readViewHead.lastRead.text = NSLocalizedString("last_read_position", comment:"")
        let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("headViewClick"))
        readViewHead.addGestureRecognizer(tagGesture)
        
        let sura = Config.getCurrentRura();
        if (sura != -1) {
            let chapter : Chapter = FMDBHelper.getInstance().getChapter(sura)!
            firstbookmark.suraId = chapter.sura
            firstbookmark.ayaId = Config.getCurrentPosition()
            firstbookmark.suraName = chapter.name_arabic
            firstbookmark.transliteration = chapter.name_transliteration
            readViewHead.arabicTitle.text = firstbookmark.suraName as? String
            readViewHead.arabicsubTitle.text = firstbookmark.transliteration as? String
            guLJlistView.tableHeaderView = readViewHead
        }
    }

    
    
    /**加载章节数据*/
    func loadChaptersData(){
        dataArray = FMDBHelper.getInstance().getChapters() //章节
        
        let path = NSBundle.mainBundle().pathForResource("translated_sura_titles", ofType: "plist") //翻译
        translated_sura_titles = NSArray(contentsOfFile: path!)!
        
        guLJlistView.reloadData()
    }
    
    /**加载书签数据*/
    func loadBookMarkData(){
        bookmarkArray = FMDBHelper.getInstance().getBookmarks() //书签
        
        bmarkListview.reloadData()
    }

    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tag = tableView.tag
        if(100 == tag){
            return dataArray.count
        }else if(200 == tag){
            return bookmarkArray.count
        }
        return 0
    }
    
    //getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tag = tableView.tag
        if(100 == tag){
            let guLJCell : GuLJCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GuLJCell
            guLJCell.indexLabel.text =  String(format:"%d.", indexPath.row + 1)
            let chapter = dataArray[indexPath.row] as! Chapter
            guLJCell.titleLabel.text = chapter.name_transliteration as? String
            
            let titletxt :String = String(format: "%@(%d)", (translated_sura_titles[chapter.sura! - 1] as! String),chapter.ayas_count! )
            guLJCell.subTitleLabel.text = titletxt
            guLJCell.describeLabel.text = chapter.name_arabic as? String
            
            return guLJCell
        }else{
            let bookmarkCell : BookMarkCell = tableView.dequeueReusableCellWithIdentifier(markCellIdentifier, forIndexPath: indexPath) as! BookMarkCell
            
            let bookmark = bookmarkArray[indexPath.row] as! Bookmark
            bookmarkCell.bookmark_title.text = bookmark.transliteration as? String
            bookmarkCell.bookmark_subtitle.text = String(format: NSLocalizedString("verse2", comment:""), bookmark.ayaId! )
            bookmarkCell.arabic_title.text = bookmark.suraName as? String
            //字体未设置
            
            return bookmarkCell
        }
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tag = tableView.tag
        let readVC : ReadViewController = ReadViewController()
        if(100 == tag){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let chapter = dataArray[indexPath.row] as! Chapter
            //正常跳转
            readVC.EXTRA_SURA = chapter.sura
            self.pushViewController(readVC)
        }else{
            //书签
            let bookmark = bookmarkArray[indexPath.row] as! Bookmark
            readVC.EXTRA_SURA = bookmark.suraId
            readVC.EXTRA_BOOKMARK_JUMP = true
            readVC.EXTRA_SCOLLPOSITION = bookmark.ayaId! - 1 //这里算位置时要减 1
            self.pushViewController(readVC)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        let tag = tableView.tag
        if(100 == tag){
            return
        }else{
            let bookmark = bookmarkArray[indexPath.row] as! Bookmark
            FMDBHelper.getInstance().deleteBookmark(bookmark.suraId!, aya:bookmark.ayaId!)
            loadBookMarkData()
            segmentedControlSelect()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let tag = tableView.tag
        if(100 == tag){
            return false
        }else{
            return true
        }
    }
    
    //上一次阅读位置
    func headViewClick(){
        let readVC : ReadViewController = ReadViewController()
        readVC.EXTRA_SURA = firstbookmark.suraId
        readVC.EXTRA_BOOKMARK_JUMP = true
        readVC.EXTRA_SCOLLPOSITION = firstbookmark.ayaId! //保存的是position
        self.pushViewController(readVC)
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
