//
//  MediaSettingCell.swift
//  Muslim
//
//  Created by LSD on 15/11/25.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MediaSettingCell: UITableViewCell {
    @IBOutlet weak var ivTip: UIImageView!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var ivPro: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
