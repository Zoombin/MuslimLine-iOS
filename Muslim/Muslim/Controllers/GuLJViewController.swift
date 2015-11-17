//
//  GuLJViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class GuLJViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var tabIndex = 1
    
    let cellIdentifier = "myCell"
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var dataArray : NSMutableArray = NSMutableArray() //章节列表
    var translated_sura_titles : NSArray = NSArray() //翻译列表
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_quran_label", comment:"")
        self.view.backgroundColor = Colors.greenColor
        let rightImage : UIImage =  UIImage(named: "search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image : rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("searchButtonClicked"))
        
        //注册ListView的adapter
        listView!.registerNib(UINib(nibName: "GuLJCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        //这个方法是用来监听segmentedControl的值是否有变化，也就是说，有没有切换过所以用了 UIControlEvents.ValueChanged
        segmentedControl.addTarget(self, action: Selector.init("segmentedControlSelect"), forControlEvents: UIControlEvents.ValueChanged)
        SegmentedControlUtil.changeSegmentedControlColor(segmentedControl)
        
        loadData()
    }
    
    /***tab切换*/
    func segmentedControlSelect() {
        if (segmentedControl.selectedSegmentIndex == 0) {
            print("章节")
            tabIndex = 1
        } else {
            print("书签")
            tabIndex = 2
        }
    }
    /**搜索按钮*/
    func searchButtonClicked() {
        let guljSearchViewController = GuLJSearchViewController()
        self.navigationController?.pushViewController(guljSearchViewController, animated: true)
    }
    
    
    /**加载数据*/
    func loadData(){
        dataArray = FMDBHelper.getInstance().getChapters() //章节
        
        let path = NSBundle.mainBundle().pathForResource("translated_sura_titles", ofType: "plist") //翻译
        translated_sura_titles = NSArray(contentsOfFile: path!)!
        
        listView.reloadData()
    }

    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    //getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let guLJCell : GuLJCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GuLJCell
        guLJCell.indexLabel.text =  String(format:"%d.", indexPath.row + 1)
        let chapter = dataArray[indexPath.row] as! Chapter
        guLJCell.titleLabel.text = chapter.name_transliteration as? String
        
        let titletxt :String = String(format: "%@(%d)", (translated_sura_titles[chapter.sura! - 1] as! String),chapter.ayas_count! )
        guLJCell.subTitleLabel.text = titletxt
        guLJCell.describeLabel.text = chapter.name_arabic as? String
        
        return guLJCell
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
