//
//  HouseLocationViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/2.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class HouseLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_qibla_label", comment:"")
        self.view.backgroundColor = UIColor.whiteColor()
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
