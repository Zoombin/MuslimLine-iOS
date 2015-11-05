//
//  SettingCell.swift
//  Muslim
//
//  Created by LSD on 15/11/5.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sub_title: UILabel!
    @IBOutlet weak var right_txt: UILabel!
    @IBOutlet weak var my_switch: UISwitch!
    @IBOutlet weak var right_img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**开关状态变化*/
    @IBAction func switchChanged(sender: AnyObject) {
    }
   
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
