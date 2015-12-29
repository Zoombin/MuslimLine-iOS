//
//  SegmentedControlUtil.swift
//  Muslim
//
//  Created by 颜超 on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class SegmentedControlUtil: NSObject {
    //去除SegemtedControl的背景色，并且设定选中的字的颜色和未选中的颜色值
    static func changeSegmentedControlColor(segmentedControl : UISegmentedControl) {
        segmentedControl.tintColor = UIColor.clearColor()
        //注NSMutableDictionary是可变更的字典
        let selectedTextAttributes : NSMutableDictionary = NSMutableDictionary()
        selectedTextAttributes.setObject(UIFont.systemFontOfSize(15), forKey: NSFontAttributeName)
        selectedTextAttributes.setObject(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes as [NSObject : AnyObject], forState: UIControlState.Selected)
        
        let unselectedTextAttributes : NSMutableDictionary = NSMutableDictionary()
        unselectedTextAttributes.setObject(UIFont.systemFontOfSize(15), forKey: NSFontAttributeName)
        unselectedTextAttributes.setObject(UIColor(colorLiteralRed: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), forKey: NSForegroundColorAttributeName)
        segmentedControl.setTitleTextAttributes(unselectedTextAttributes as [NSObject : AnyObject], forState: UIControlState.Normal)
    }
}
