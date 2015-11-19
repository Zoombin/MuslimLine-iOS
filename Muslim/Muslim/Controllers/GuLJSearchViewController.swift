//
//  GuLJSearchViewController.swift
//  Muslim
//  古兰经搜索页
//  Created by 颜超 on 15/10/31.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class GuLJSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var dataArray : NSMutableArray = NSMutableArray()
    let cellIdentifier = "guLJSearchCell"
    var listView :UITableView!
    
    var mSearchStr: String?
    var mSearchChapterSectionNumber: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_quran_search_label", comment:"")
        self.view.backgroundColor = UIColor.whiteColor()
        
        let searBar = UISearchBar()
        
        let width : CGFloat = UIScreen.mainScreen().bounds.width
        let height : CGFloat = UIScreen.mainScreen().bounds.height
        searBar.frame = CGRectMake(0, 64, width, 40)
        searBar.delegate = self
        searBar.placeholder = NSLocalizedString("keywords", comment:"")
        self.view.addSubview(searBar)
        
        listView = UITableView()
        listView.frame = CGRectMake(0, CGRectGetMaxY(searBar.frame), width, height - CGRectGetMaxY(searBar.frame))
        listView.separatorColor = UIColor.whiteColor()
        listView.delegate = self
        listView.dataSource = self
        self.view.addSubview(listView)
        
        //注册ListView的adapter
        listView.registerNib(UINib(nibName: "GuLJSearchCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //搜索
    func searchQuran(searchKey : NSString){
        if(searchKey.length == 0){
            //清空数据
            dataArray.removeAllObjects()
            listView.reloadData()
            return
        }
        
        analyzeSectionNumber(searchKey)
        
        mSearchStr = searchKey as String
        dataArray = FMDBHelper.getInstance().searchQurans(mSearchStr!, chapterSectionNumber: mSearchChapterSectionNumber)
        listView.reloadData()
    }
    
    //计算
    func analyzeSectionNumber(searchStr : NSString)->Bool{
        // 默认章节号为：-1
        mSearchChapterSectionNumber[0] = -1;
        mSearchChapterSectionNumber[1] = -1;
        
        // 空字符
        var bSuccess :Bool = false
        if( searchStr.length == 0 ){
            return bSuccess;
        }
        
        // 第一个符号是否为数字，是数字的话作为章节号解析，否则默认为字符串搜索
        let range : NSRange = NSRange.init(location: 0, length: 1)
        let firstCharacter = searchStr.substringWithRange(range);
        do {
            try Int(firstCharacter)
        } catch {
            print("Exception")
            return bSuccess
        }

        // 解析章节号
        let strs : [String]!
        if(searchStr.rangeOfString(":").location != NSNotFound) {
            strs = searchStr.componentsSeparatedByString(":")
        }else if(searchStr.rangeOfString(",").location != NSNotFound) {
            strs = searchStr.componentsSeparatedByString(",")
        }else if(searchStr.rangeOfString(" ").location != NSNotFound){
            strs = searchStr.componentsSeparatedByString(" ")
        }else if(searchStr.rangeOfString(".").location != NSNotFound){
            strs = searchStr.componentsSeparatedByString(".")
        }else if(searchStr.rangeOfString("-").location != NSNotFound){
            strs = searchStr.componentsSeparatedByString("-")
        }else{
            strs = searchStr.componentsSeparatedByString(":")
        }
        let len = strs.count
        for i in 0...len-1 {
            let kk : String = strs[i]
            var gg :Int = -1
            do {
                try  gg = Int(kk)!
                mSearchChapterSectionNumber[i] = gg
            }catch{
            }
        }
        
        if(mSearchChapterSectionNumber[0] as! Int != -1){
            bSuccess = true;
        }
        
        return bSuccess;
    }
    
    
    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    //getView方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let guLJSearchCell : GuLJSearchCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GuLJSearchCell
        let quran : Quran = dataArray[indexPath.row] as! Quran
        let aya :Int = quran.aya!
        let sura :Int = quran.sura!
        let chapter : Chapter = FMDBHelper.getInstance().getChapter(sura)!

        guLJSearchCell.title.text = chapter.name_transliteration as? String
        guLJSearchCell.quran.text = chapter.name_arabic as? String
        guLJSearchCell.describe.text = String(format: NSLocalizedString("verse2", comment:""), aya)
        
        return guLJSearchCell
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //搜索
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuran(searchText)
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
