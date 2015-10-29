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
        //注: 设置title
        title = "Muslim Line";
        let greenColor : UIColor = UIColor(colorLiteralRed: 25/255.0, green: 154/255.0, blue: 76/255.0, alpha: 1.0)
        
        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        self.view.backgroundColor = greenColor
        
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("menuButtonClicked"))
        initBottomView()
    }
    
    func menuButtonClicked() {
        
    }
    
    func initBottomView() {
        //注: var 和 let的区别， var是变量 let是常量
        //let Object : 类型 比如CGFloat NSInterger等等
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width
        let height : CGFloat = UIScreen.mainScreen().bounds.size.height
        let buttonWidth = width / 3
        let buttonHeight = height / 4;
        //第几行
        var row : CGFloat = 0
        //第几个
        var position : CGFloat = 0
        
        //定义数组 [String] 代表数组里面的String的
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
            button.layer.borderWidth = 0.5 //设置边框的宽度
            button.layer.borderColor = UIColor.lightGrayColor().CGColor //设置边框的颜色
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

