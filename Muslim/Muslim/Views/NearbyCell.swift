//
//  NearbyCell.swift
//  Muslim
//
//  Created by 颜超 on 15/11/13.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class NearbyCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
