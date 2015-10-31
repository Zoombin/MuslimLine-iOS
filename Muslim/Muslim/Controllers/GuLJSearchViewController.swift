//
//  GuLJSearchViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/10/31.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class GuLJSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let dataArray : NSMutableArray = NSMutableArray()
    let cellIdentifier = "myCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_quran_search_label", comment:"")
        self.view.backgroundColor = UIColor.whiteColor()
        
        let searBar = UISearchBar()
        
        let width : CGFloat = UIScreen.mainScreen().bounds.width
        let height : CGFloat = UIScreen.mainScreen().bounds.height
        searBar.frame = CGRectMake(0, 64, width, 40)
        searBar.placeholder = NSLocalizedString("keywords", comment:"")
        self.view.addSubview(searBar)
        
        let listView : UITableView = UITableView()
        listView.frame = CGRectMake(0, CGRectGetMaxY(searBar.frame), width, height - CGRectGetMaxY(searBar.frame))
        listView.delegate = self
        listView.dataSource = self
        self.view.addSubview(listView)
        
        //注册ListView的adapter
        listView.registerNib(UINib(nibName: "GuLJCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //设置行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return dataArray.count
        return 10
    }
    
    //类似android的getView方法，进行生成界面和赋值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let guLJCell : GuLJCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GuLJCell
        guLJCell.indexLabel.text =  String(format:"%d.", indexPath.row + 1)
        return guLJCell
    }
    
    //选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func searchButtonClicked() {
        let guljSearchViewController = GuLJSearchViewController()
        self.navigationController?.pushViewController(guljSearchViewController, animated: true)
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
