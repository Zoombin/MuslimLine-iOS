//
//  FeedbackViewController.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController,UITextViewDelegate{
    var textHint :UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("feedback", comment:"")
        
        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = Colors.greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        //设置背景颜色
        self.view.backgroundColor = Colors.lightGray
        
        setupView()
    }
    
    func setupView(){
        let margin :CGFloat = 30;
        let padding :CGFloat = 10;
        
        let textWidth:CGFloat = PhoneUtils.screenWidth - (margin*2)
        let textHight:CGFloat = (PhoneUtils.screenHeight-64)/3*0.9
        let textIndexX :CGFloat = margin
        let textIndexY :CGFloat = 64 + margin
        
        //输入框
        let textview :UITextView = UITextView(frame: CGRectMake(textIndexX, textIndexY, textWidth, textHight))
        textview.font = UIFont.systemFontOfSize(18)
        textview.layer.cornerRadius = 16;
        textview.textContainerInset = UIEdgeInsetsMake(padding, padding, padding,padding)
        textview.textAlignment = NSTextAlignment.Left
        textview.delegate = self
        self.view.addSubview(textview)
        
        //提示文字
        textHint = UILabel(frame: CGRectMake(textIndexX+padding,textIndexY,textWidth-(padding*2),80))
        textHint.text = NSLocalizedString("feedback_description_hint", comment: "")
        textHint.textColor = UIColor.lightGrayColor()
        textHint.font = UIFont.systemFontOfSize(18)
        textHint.numberOfLines = 0
        self.view.addSubview(textHint)
        
        
        //发送按钮
        let sendBtWidth :CGFloat = 100
        let sendBtHight:CGFloat = 30
        let button :UIButton = UIButton(frame: CGRectMake((PhoneUtils.screenWidth - sendBtWidth)/2,textIndexY+textHight+margin,sendBtWidth,sendBtHight))
        let btText = NSLocalizedString("feedback_submit", comment: "")
        button.setTitle(btText, forState:UIControlState.Normal)
        button.setBackgroundImage(UIImage(named:"sendback"),forState: UIControlState.Normal)
        button.addTarget(self, action: Selector.init("sendFeedback"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    //监听文字变化
    internal func textViewDidChange(textView: UITextView){
        if (textView.markedTextRange == nil) {
            textHint.hidden = false;
        }else{
            textHint.hidden = true;
        }
    }

    
    func sendFeedback(){
        //
        print("反馈")
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
