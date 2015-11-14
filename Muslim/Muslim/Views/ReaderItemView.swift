//
//  ReaderItemView.swift
//  Muslim
//
//  Created by LSD on 15/11/13.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ReaderItemView: UIView {
    @IBOutlet weak var avstar: UIImageView!
    @IBOutlet weak var btAvstar: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btCheck: UIButton!
    
    func setSelect(select :Bool){
        btCheck.selected = select
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
