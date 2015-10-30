//
//  GuLJCell.swift
//  Muslim
//
//  Created by 颜超 on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class GuLJCell: UITableViewCell {

    @IBOutlet internal weak var indexLabel: UILabel!
    @IBOutlet internal weak var titleLabel: UILabel!
    @IBOutlet internal weak var subTitleLabel: UILabel!
    @IBOutlet internal weak var describeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
