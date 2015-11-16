//
//  CalendarViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var holidayTableView: UITableView!
    
    let resultArray : NSMutableArray = NSMutableArray()
    var isIslamic : Bool = true
    let islamic_calendar : String = "islamic"
    let persain_calendar : String = "persain"
    var currentDicionary : NSDictionary?
    
    let cellIdentifier = "myCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("islamic_calendar", comment: "")
        //注册ListView的adapter
        holidayTableView!.registerNib(UINib(nibName: "CalendarCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        loadHolidays()
    }
    
    func loadHolidays() {
        let filePath = NSBundle.mainBundle().pathForResource("holidayTimes", ofType: "plist")
        let dictionary : NSDictionary = NSDictionary(contentsOfFile: filePath!)!
        print(dictionary)
        if (isIslamic) {
            let islamic : NSArray = dictionary["islamic"] as! NSArray
            resultArray.addObjectsFromArray(islamic as [AnyObject])
            holidayTableView.reloadData()
        } else {
            let persain : NSArray = dictionary["persain"] as! NSArray
            resultArray.addObjectsFromArray(persain as [AnyObject])
            holidayTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let calendarCell : CalendarCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalendarCell
        let dictionary : NSDictionary = resultArray[indexPath.row] as! NSDictionary
        calendarCell.holidayNameLabel.text = dictionary["name"] as? String
        calendarCell.dateLabel.text = dictionary["time"] as? String
        return calendarCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
