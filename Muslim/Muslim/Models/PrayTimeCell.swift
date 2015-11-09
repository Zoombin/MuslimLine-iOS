//
//  PrayTimeCell.swift
//  Muslim
//
//  Created by 颜超 on 15/11/9.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PrayTimeCell: UITableViewCell {

    @IBOutlet weak var prayTimeLabel: UILabel!
    @IBOutlet weak var timeSelectedButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var prayNameLabel: UILabel!
    @IBOutlet weak var praySunImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
