//
//  FeedbackViewController.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController,UITextViewDelegate, httpClientDelegate{
    var textHint :UILabel!
    var httpClient : MSLHttpClient = MSLHttpClient()
    var textview :UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("feedback", comment:"")
        //设置背景颜色
        self.view.backgroundColor = Colors.lightGray
        httpClient.delegate = self
        
        setupView()
    }
    
    ////网络请求回调
    func succssResult(result: NSObject, tag : NSInteger) {
        self.view.hideToastActivity()
        self.view.makeToast(message: NSLocalizedString("thanks_for_feedback", comment:""))
        self.performSelector(Selector.init("back"), withObject: nil, afterDelay: 1.5)
    }
    func errorResult(error : NSError, tag : NSInteger) {
        self.view.hideToastActivity()
        self.view.makeToast(message: error.description)
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func hideKeyboard(){
        textview.resignFirstResponder()
        //searBar.becomeFirstResponder()
    }
    
    
    func setupView(){
        let margin :CGFloat = 30;
        let padding :CGFloat = 11;
        
        let textWidth:CGFloat = PhoneUtils.screenWidth - (margin*2)
        let textHight:CGFloat = (PhoneUtils.screenHeight-64)/3*0.9
        let textIndexX :CGFloat = margin
        let textIndexY :CGFloat = 64 + margin
        
        let invisibleBtn :UIButton = UIButton(frame: CGRectMake(0, 64, PhoneUtils.screenWidth, PhoneUtils.screenHeight))
        invisibleBtn.addTarget(self, action: Selector.init("hideKeyboard"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(invisibleBtn)
        
        //输入框
        textview = UITextView(frame: CGRectMake(textIndexX, textIndexY, textWidth, textHight))
        textview.font = UIFont.systemFontOfSize(18)
        textview.layer.cornerRadius = 16;
        textview.textContainerInset = UIEdgeInsetsMake(padding * 2, padding, padding,padding)
        textview.textAlignment = NSTextAlignment.Left
        textview.delegate = self
        self.view.addSubview(textview)
        
        //解决光标的问题
        self.automaticallyAdjustsScrollViewInsets = false
        //提示文字
        textHint = UILabel(frame: CGRectMake(textIndexX+padding+5,textIndexY,textWidth-(padding*2),80))
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
        if (textView.text.isEmpty) {
            textHint.hidden = false;
        }else{
            textHint.hidden = true;
        }

    }
    
    func textViewDidBeginEditing(textView: UITextView){
       textHint.hidden = true;
    }
    

    //发送反馈
    func sendFeedback(){
        //反馈
        hideKeyboard()
        self.view.makeToastActivityWithMessage(message: NSLocalizedString("sending", comment: ""))
        let message : String = textview.text as String
        if(message.isEmpty){
            self.view.hideToastActivity()
            self.view.makeToast(message: NSLocalizedString("feedback_can_not_be_empty", comment: ""))
            return
        }
        httpClient.sendFeedback(message, tag: 0)
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
