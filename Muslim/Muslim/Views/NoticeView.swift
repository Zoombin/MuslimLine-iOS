//
//  NoticeView.swift
//  Muslim
//
//  Created by 颜超 on 15/11/22.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class NoticeView: UIView {
    
    @IBOutlet weak var voiceIconImageView: UIImageView!
    @IBOutlet weak var leftTimeButton: UIButton!
    @IBOutlet weak var prayTimeButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var prayNameLabel: UILabel!
    var currentPertage : Double = 1
    var aPath : UIBezierPath?
    let start : Double = 145
    let end : Double = 395
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        Log.printLog("------------")
        Log.printLog(currentPertage)
        drawBackCircle()//背景圆
        
        showPoint()
        
        let currentEnd = ((end - start) * currentPertage) + start
        let color = Colors.progressGreenColor
        color.set()
        aPath = UIBezierPath()
        print(self.frame.size.width / 2)
        aPath!.addArcWithCenter(CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2), radius: self.frame.size.width / 2 == 80.0 ? 70 : 90, startAngle: CGFloat((M_PI * start) / 180), endAngle: CGFloat((M_PI * currentEnd) / 180)  , clockwise: true)
        aPath!.lineWidth = 3.0
        aPath!.lineCapStyle = CGLineCap.Round
        aPath!.lineJoinStyle = CGLineJoin.Round
        aPath!.stroke()
        
        showPoint()
    }
    
    func showPoint() {
        let currentEnd = ((end - start) * currentPertage) + start
        let color = Colors.progressGreenColor
        color.set()
        let bPath = UIBezierPath()
        bPath.addArcWithCenter(CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2), radius: self.frame.size.width / 2 == 80.0 ? 70 : 90, startAngle: CGFloat((M_PI * currentEnd) / 180), endAngle: CGFloat((M_PI * currentEnd + 0.1) / 180)  , clockwise: true)
        bPath.lineWidth = 10.0
        bPath.lineCapStyle = CGLineCap.Round
        bPath.lineJoinStyle = CGLineJoin.Round
        bPath.stroke()
    }
    
    func currentProgress(pertage : Double) {
        currentPertage = pertage
        if (currentPertage < 0) {
            currentPertage = 0
            return
        }
        if (currentPertage > 1) {
            currentPertage = 1
            return
        }
        self.setNeedsDisplay()
    }
    
    func drawBackCircle(){
        let currentEnd = ((end - start) * 1) + start
        let color = Colors.bgGreenColor
        color.set()
        let bPath = UIBezierPath()
        bPath.addArcWithCenter(CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2), radius: self.frame.size.width / 2 == 80.0 ? 70 : 90, startAngle: CGFloat((M_PI * start) / 180), endAngle: CGFloat((M_PI * currentEnd) / 180)  , clockwise: true)
        bPath.lineWidth = 3.0
        bPath.lineCapStyle = CGLineCap.Round
        bPath.lineJoinStyle = CGLineJoin.Round
        bPath.stroke()
    }


}
