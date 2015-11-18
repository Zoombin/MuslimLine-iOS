//
//  BookMarkCell.swift
//  Muslim
//
//  Created by LSD on 15/11/17.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class BookMarkCell: UITableViewCell {

    @IBOutlet weak var arabic_title: UILabel!
    @IBOutlet weak var bookmark_title: UILabel!
    @IBOutlet weak var bookmark_subtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
