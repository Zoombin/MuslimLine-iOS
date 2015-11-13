//
//  AllahNameCell.swift
//  Muslim
//
//  Created by LSD on 15/11/13.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class AllahNameCell: UITableViewCell {

    
    @IBOutlet weak var indexLable: UILabel!
    @IBOutlet weak var nameEn: UILabel!
    @IBOutlet weak var nameLocaliz: UILabel!
    @IBOutlet weak var nameOt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
