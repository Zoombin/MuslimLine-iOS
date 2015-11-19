//
//  ReadViewController.swift
//  Muslim

//   朗读界面

//
//  Created by LSD on 15/11/18.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class ReadViewController: BaseViewController {
    let bt_back = 100
    let bt_previous = 200
    let bt_next = 300
    let bt_contry = 400
    let bt_reader = 500
    
    var EXTRA_BOOKMARK_JUMP : Bool = false
    var EXTRA_SURA : Int?
    var EXTRA_AYA :Int?
    var EXTRA_SCOLLPOSITION :Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleBar()
    }
    
    func setTitleBar(){
        //右边的veiw
        let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("ReadRightView", owner: nil, options: nil)
        let readRightView : ReadRightView = nibs.lastObject as! ReadRightView
        readRightView.btPrevious.tag = bt_previous
        readRightView.btPrevious.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        
        readRightView.btNext.tag = bt_next
        readRightView.btNext.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        
        readRightView.btCountry.tag = bt_contry
        readRightView.btCountry.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        
        readRightView.btReader.tag = bt_reader
        readRightView.btReader.addTarget(self,action:Selector("onBtnClick:"),forControlEvents:UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: readRightView)
        
        //左边的View
        let nibsL : NSArray = NSBundle.mainBundle().loadNibNamed("ReadLeftView", owner: nil, options: nil)
        let readLeftView : ReadLeftView = nibsL.lastObject as! ReadLeftView
        readLeftView.ivBack.tag = bt_back
        readLeftView.ivBack.addTarget(self, action: Selector("onBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: readLeftView)
        
    }
    
    func setupview(){
        
    }
    
    /**bt点击*/
    func onBtnClick(button:UIButton){
        let tag = button.tag
        switch(tag){
        case bt_back:
            self.navigationController?.popViewControllerAnimated(true)
            break
        case bt_previous:
            break
        case bt_next:
            break
        case bt_contry:
            let quranTextVC = QuranTextViewController()
            self.navigationController?.pushViewController(quranTextVC, animated: true)
            break
        case bt_reader:
            let quranAudioVC = QuranAudioViewController()
            self.navigationController?.pushViewController(quranAudioVC, animated: true)
            break
        default:
            break
        }
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
