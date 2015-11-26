//
//  NoticeView.swift
//  Muslim
//
//  Created by 颜超 on 15/11/22.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class NoticeView: UIView {
    
    @IBOutlet weak var progressImageView : UIImageView!
    @IBOutlet weak var voiceIconImageView: UIImageView!
    @IBOutlet weak var leftTimeButton: UIButton!
    @IBOutlet weak var prayTimeButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var prayNameLabel: UILabel!
    var aPath : UIBezierPath?
    let start : Double = 145
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
//        let color = UIColor.orangeColor()
//        color.set()
//        aPath = UIBezierPath()
//        aPath!.addArcWithCenter(CGPointMake(80, 80), radius: 77, startAngle: CGFloat((M_PI * start) / 180), endAngle: CGFloat((M_PI * 395) / 180)  , clockwise: true)
//        aPath!.lineWidth = 5.0
//        aPath!.lineCapStyle = CGLineCap.Round
//        aPath!.lineJoinStyle = CGLineJoin.Round
//        aPath!.stroke()
    }
    
    func clear() {
//        aPath = nil
//        aPath = UIBezierPath()
//        setNeedsDisplay()
//        path   = nil;  //Set current path nil
//        path   = [UIBezierPath bezierPath]; //Create new path
//        [self setNeedsDisplay];
    }
    
    func currentProgress() {
        clear()
    }


}
