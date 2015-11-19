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
    var isSelected : Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getSize(isSeleced : Bool) -> CGFloat{
        if (isSeleced) {
            return 120
        }
        return 70
    }
    
}
