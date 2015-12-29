//
//  BookMarkCell.swift
//  Muslim
//
//  Created by LSD on 15/11/17.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

protocol BookMarkCellDelegate : NSObjectProtocol {
    func showAlertWithPosition(index : NSInteger)
}
class BookMarkCell: UITableViewCell {

    @IBOutlet weak var arabic_title: UILabel!
    @IBOutlet weak var bookmark_title: UILabel!
    @IBOutlet weak var bookmark_subtitle: UILabel!
    var delegate : BookMarkCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initLongGesture(index : NSInteger) {
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: Selector.init("longPressDelete:"))
        longGesture.minimumPressDuration = 0.5
        self.contentView.addGestureRecognizer(longGesture)
    }

    func longPressDelete(longGesture : UILongPressGestureRecognizer) {
        Log.printLog("长按操作")
        if (self.delegate != nil) {
            self.delegate?.showAlertWithPosition((longGesture.view?.tag)!)
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
