//
//  AboutViewController.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //国际化
        title = NSLocalizedString("about_us", comment:"")
        
        let greenColor : UIColor = UIColor(colorLiteralRed: 25/255.0, green: 154/255.0, blue: 76/255.0, alpha: 1.0)
        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        //设置背景颜色
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupView()
    }
    
    
    func setupView(){
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        //顶部背景图片
        let bgHight :CGFloat = ((screenHeight-64)/2)-50
        let topImg :UIImageView = UIImageView(frame: CGRectMake(0, 64, screenWidth, bgHight))
        topImg.image = UIImage(named:"topimgbg")
        self.view.addSubview(topImg)
        
        let txtWidth:CGFloat = 100
        let txtHight :CGFloat = 15
        let logoWidth : CGFloat = 65
        let logoHight : CGFloat = 65
        let indexX : CGFloat = (screenWidth-(logoWidth+20+txtWidth))/2
        let indexY :CGFloat = (bgHight-logoHight)/2+64
        
        //图标
        let logo :UIImageView = UIImageView(frame: CGRectMake(indexX, indexY, logoWidth, logoHight))
        logo.image = UIImage(named:"templelogo")
        self.view.addSubview(logo)
        
        
        let textMslX :CGFloat=indexX+logoWidth+20
        let textMslY :CGFloat = indexY+((logoHight - (txtHight+txtHight+10))/2)
        //文字
        let textMsl :UILabel = UILabel(frame: CGRectMake(textMslX, textMslY, txtWidth, txtHight))
        textMsl.text=NSLocalizedString("app_name", comment: "")
        textMsl.textColor = UIColor.whiteColor()
        textMsl.font = UIFont.systemFontOfSize(18)
        self.view.addSubview(textMsl)
        
        //版本
        let textVer : UILabel = UILabel(frame: CGRectMake(textMslX, CGRectGetMaxY(textMsl.frame)+10, txtWidth, txtHight))
        textVer.text = PhoneUtils.getAppVer();
        textVer.textColor = UIColor.whiteColor()
        textVer.font = UIFont.systemFontOfSize(18)
        self.view.addSubview(textVer)
        
        //版权
        let txtCopyRightW :CGFloat = 230
        let txtCopyRightH :CGFloat = 50
        let copyRitht : UILabel = UILabel(frame: CGRectMake((screenWidth-txtCopyRightW)/2, screenHeight-60, txtCopyRightW, txtCopyRightH))
        copyRitht.text = NSLocalizedString("about_copyright_text", comment:"")
        copyRitht.numberOfLines = 0
        copyRitht.textAlignment = NSTextAlignment.Center
        copyRitht.lineBreakMode = NSLineBreakMode.ByWordWrapping
        copyRitht.textColor = UIColor.lightGrayColor()
        copyRitht.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(copyRitht)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
