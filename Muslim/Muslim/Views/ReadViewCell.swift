//
//  ReadViewCell.swift
//  Muslim
//
//  Created by LSD on 15/11/19.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ReadViewCell: UITableViewCell {
    @IBOutlet weak var textQuran: UILabel!
    @IBOutlet weak var textCn: UILabel!
    
    @IBOutlet weak var OptionsView: UIView!
    @IBOutlet weak var ivPro: UIActivityIndicatorView!
    @IBOutlet weak var btMore: UIButton!
    @IBOutlet weak var btBookMark: UIButton!
    @IBOutlet weak var btPlay: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
