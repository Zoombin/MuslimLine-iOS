//
//  QuranTextCell.swift
//  Muslim
//
//  Created by LSD on 15/11/14.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class QuranTextCell: UITableViewCell {

    @IBOutlet weak var ivCountry: UIImageView!
    @IBOutlet weak var tvLanguage: UILabel!
    @IBOutlet weak var tvActor: UILabel!
    @IBOutlet weak var ivDownload: UIImageView!
    @IBOutlet weak var ivSelected: UIImageView!
    @IBOutlet weak var probar: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
