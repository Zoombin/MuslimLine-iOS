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

    
    func calculateHeight(quran :Quran) {
            if (quran.hasCalulateHeight == false) {
                quran.hasCalulateHeight = true
                textQuran.sizeToFit()
                textCn.sizeToFit()
              
                textQuran.frame =  CGRectMake(PhoneUtils.screenWidth - 17 - textQuran.frame.origin.x - textQuran.frame.size.width, textQuran.frame.origin.y, textQuran.frame.size.width, textQuran.frame.size.height)
                
                textCn.frame = CGRectMake(textCn.frame.origin.x, CGRectGetMaxY(textQuran.frame) + 10, textCn.frame.size.width, textCn.frame.size.height)
                OptionsView.frame = CGRectMake(textCn.frame.origin.x, CGRectGetMaxY(textCn.frame) + 10, OptionsView.frame.size.width, OptionsView.frame.size.height)
                
                quran.unSelectedHeight = CGRectGetMaxY(textCn.frame) + 10
                quran.selectedHeight = CGRectGetMaxY(OptionsView.frame)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
