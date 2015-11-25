//
//  QuranAudioViewController.swift
//  Muslim
//
//  Created by LSD on 15/11/7.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class QuranAudioViewController: BaseViewController {
    var readerArray : NSArray!
    var scrollView : UIScrollView!
    
    var select = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("quran_audio_setting_title", comment:"");
        
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        
        getData()
        setupView()
    }
    
    func getData(){
        select = Config.getCurrentReaderIndex()
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            readerArray = Config.QuranAudioReaderIran;
        }else{
            //逊尼派
            readerArray = Config.QuranAudioReader;
        }
    }
    
    func setupView(){
        let itemWidth :CGFloat = 90
        let itemHigth :CGFloat = 120
        
        let margin :CGFloat = 20 //边距
        var totalrow = 0 //行
        if(0 == (readerArray.count % 3)){
            totalrow = readerArray.count / 3
        }else{
             totalrow = (readerArray.count / 3)+1
        }
        let intervalW = (PhoneUtils.screenWidth-(margin*2) - itemWidth*3) / 2 //列间隔
        let intervalH:CGFloat = 10 //行间隔
        
        scrollView.frame = CGRectMake(0, 64 , PhoneUtils.screenWidth, PhoneUtils.screenHeight)
        //纵向滚动
        let pageHeight:CGFloat = ((itemHigth + intervalH ) * CGFloat(totalrow)) + margin//滚动区域的高度
        scrollView.contentSize = CGSizeMake(PhoneUtils.screenWidth, CGFloat(pageHeight))
        scrollView.showsVerticalScrollIndicator = true

        var itemP = 0//位置
        for index in 0...totalrow-1 {
            for positon in 0...2 {
                if(itemP >= readerArray.count ){
                    break;
                }
                let itemX :CGFloat = (CGFloat(positon) * itemWidth) + (CGFloat(positon) * intervalW) + margin
                let itemY :CGFloat = (CGFloat(index) * itemHigth) + (CGFloat(index) * intervalH) + margin
                
                let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("ReaderItemView", owner: nil, options: nil)
                let readerItemView : ReaderItemView = nibs.lastObject as! ReaderItemView
                readerItemView.frame = CGRectMake(itemX, itemY , itemWidth, itemHigth)
                
                let name = readerArray[itemP]
                readerItemView.name.text = name as? String
              
                let imageResouce = name.stringByReplacingOccurrencesOfString(" ", withString: "_").lowercaseString
                readerItemView.btAvstar.tag = itemP
                readerItemView.btAvstar.setImage(UIImage(named: imageResouce), forState: UIControlState.Normal)
                readerItemView.btAvstar.addTarget(self, action: Selector.init("itemClick:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                if(select == itemP){
                    readerItemView.setSelect(true)
                }else{
                    readerItemView.setSelect(false)
                }
                let tagGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector.init("itemClick"))
                readerItemView.addGestureRecognizer(tagGesture)
                
                scrollView.addSubview(readerItemView)
                itemP++
            }
        }
    }
    
    //item点击事件
    func itemClick(sender : UIButton){
        //先移除所有界面
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        let tag = sender.tag
        Config.saveCurrentReaderIndex(tag)
        select = tag
        setupView()
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
