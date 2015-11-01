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
        title = NSLocalizedString("app_name", comment:"");
        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = Colors.greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        self.view.backgroundColor = Colors.greenColor
        
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("menuButtonClicked"))
        initBottomView()
    }
    
    func menuButtonClicked() {
        //临时跳转-到关于页面
        let aboutviewController = FeedbackViewController()
        self.navigationController?.pushViewController(aboutviewController, animated: true)
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
        let label1 :String = NSLocalizedString("main_quran_label", comment:"");
        let label2 :String = NSLocalizedString("main_qibla_label", comment:"");
        let label3 :String = NSLocalizedString("main_pray_label", comment:"");
        let label4 :String = NSLocalizedString("main_nearby_label", comment:"");
        let label5 :String = NSLocalizedString("main_holiday_label", comment:"");
        let label6 :String = NSLocalizedString("main_names_label", comment:"");
        let titles : [String] = [label1, label2, label3, label4, label5, label6]
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
        let guLJViewController = GuLJViewController()
        self.navigationController?.pushViewController(guLJViewController, animated: true)
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

