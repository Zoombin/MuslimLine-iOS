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
                let content1 = String(format: "%d.%@", quran.aya!,quran.text == nil ? "":quran.text!)
                let content2 = String(format: "%d.%@",quran.aya!,quran.text_zh == nil ? "":quran.text_zh!)
                
                let offSetX : CGFloat = 0
                let width = self.frame.size.width - offSetX * 2
                let labelWidth = Int32(width)
                let height1 = MSLFrameUtil.getLabHeight(content1, fontSize: 16, width: labelWidth)
                let height2 = MSLFrameUtil.getLabHeight(content2, fontSize: 16, width: labelWidth)
                
                textQuran.frame = CGRectMake(offSetX, textQuran.frame.origin.y, width, CGFloat(height1))
               
                if (Config.getTextShouldToRight()) {
                    textCn.textAlignment = NSTextAlignment.Right
                } else {
                    textCn.textAlignment = NSTextAlignment.Left
                }
                
                textCn.frame = CGRectMake(offSetX, CGRectGetMaxY(textQuran.frame) + 10, width, CGFloat(height2))
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
