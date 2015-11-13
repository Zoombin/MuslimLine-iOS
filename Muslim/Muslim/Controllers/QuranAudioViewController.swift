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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("quran_audio_setting_title", comment:"");

        getData()
        setupView()
    }
    
    func getData(){
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            readerArray = Config.QuranAudioReaderIran;
        }else{
            //逊尼派
             readerArray = Config.QuranAudioReader;
        }
    }
    
    func setupView(){
        
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
