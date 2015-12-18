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
                let content1 = textQuran.text
                let content2 = textCn.text
                
                let offSetX : CGFloat = 15
                let width = self.contentView.frame.size.width
                let labelWidth = Int32(width - offSetX * 2)
                let height1 = MSLFrameUtil.getLabHeight(content1, fontSize: 17, width: labelWidth)
                let height2 = MSLFrameUtil.getLabHeight(content2, fontSize: 17, width: labelWidth)
                
                textQuran.frame = CGRectMake(textQuran.frame.origin.x, textQuran.frame.origin.y, width - offSetX * 2, CGFloat(height1))
               
                if (Config.getTextShouldToRight()) {
                    textCn.textAlignment = NSTextAlignment.Right
                } else {
                    textCn.textAlignment = NSTextAlignment.Left
                }
                
                textCn.frame = CGRectMake(textQuran.frame.origin.x, CGRectGetMaxY(textQuran.frame) + 10, width - offSetX * 2, CGFloat(height2))
                OptionsView.frame = CGRectMake(0, CGRectGetMaxY(textCn.frame) + 10, OptionsView.frame.size.width, OptionsView.frame.size.height)
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
