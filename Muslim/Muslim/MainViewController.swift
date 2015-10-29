//
//  ViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/10/21.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //注: 设置title25 154 76
        title = "Muslim Line";
        self.view.backgroundColor = UIColor(colorLiteralRed: 25/255.0, green: 154/255.0, blue: 76/255.0, alpha: 1.0)
        // Do any additional setup after loading the view, typically from a nib.
        initBottomView();
    }
    
    func initBottomView() {
        //注: var 和 let的区别， var是变量 let是常量
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width
        let height : CGFloat = UIScreen.mainScreen().bounds.size.height
        let buttonWidth = width / 3
        let buttonHeight = height / 4;
        //第几行
        var row : CGFloat = 0
        //第几个
        var position : CGFloat = 0
        let titles : [String] = ["古兰经", "天房方向", "礼拜时间", "附近位置", "日历", "真主尊名"]
        let actions : [String] = ["clickGuLj", "clickTianFFX", "clickLiBSJ", "clickFuJWZ", "clickRiL", "clickZunZXM"]
        let imageNames : [String] = ["quran", "qibla", "prayer", "nearby", "calenlar", "names"]
        
        for index in 0...5 {
            if (index % 3 == 0 && index != 0) {
                row++
                position = 0
            }
            let button : UIButton = UIButton()
            button.frame = CGRectMake(position * buttonWidth, (height / 2) + (row * buttonHeight), buttonWidth, buttonHeight)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.setImage(UIImage(named: imageNames[index]), forState: UIControlState.Normal)
            button.tag = index + 1
            button.addTarget(self, action: Selector.init(actions[index]), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            
            let titleLabel : UILabel = UILabel()
            titleLabel.frame = CGRectMake(0, buttonHeight - (buttonHeight / 4), buttonWidth, 20);
            titleLabel.font = UIFont.boldSystemFontOfSize(14)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.text = titles[index]
            button.addSubview(titleLabel)
            position++
        }
    }
 
    //古兰经
    func clickGuLj() {
        print("古兰经")
    }
    
    //天房方向
    func clickTianFFX() {
        print("天房方向")
    }
    
    //礼拜时间
    func clickLiBSJ() {
        print("礼拜时间")
    }
    
    //附近位置
    func clickFuJWZ() {
        print("附近位置")
    }
    
    //日历
    func clickRiL() {
        print("日历")
    }
    
    //尊主姓名
    func clickZunZXM() {
        print("尊主姓名")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

