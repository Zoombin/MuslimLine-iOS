//
//  QuranTextViewController.swift
//  Muslim

//  文本&译文

//  Created by LSD on 15/11/7.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class QuranTextViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    var mTableView:UITableView!
    let cellIdentifier = "QuranTextCellIdentifier"
    
    var translationArray : NSMutableArray!
    var select = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("setting_translation_item_title", comment:"");
        
        setupView()
        getData()
    }
    
    func getData(){
        select = Config.getCurrentLanguageIndex()
        
        let quranTranslationActors : NSArray! = Config.QuranTranslationActors
        let quranTranslationEntries : NSArray! = Config.QuranTranslationEntries
        let quranTranslationValues : NSArray! = Config.QuranTranslationValues
        let quranTranslationCountryIcon : NSArray! = Config.QuranTranslationCountryIcon
        
        translationArray = NSMutableArray()
        for index in 0...quranTranslationActors.count-1 {
            let translation :Translation = Translation()
            translation.quran_translation_actor = quranTranslationActors[index] as! String
            translation.quran_translation_entry = quranTranslationEntries[index] as! String
            translation.quran_translation_value = quranTranslationValues[index] as! String
            translation.quran_translation_country_icon = quranTranslationCountryIcon[index] as! String
            let zippath = (quranTranslationValues[index] as! String) + ".sql.zip"
            translation.zippath = zippath
            let download_url = (quranTranslationValues[index] as! String) + ".sql.zip"
            translation.download_url = download_url
            translationArray.addObject(translation)
        }
        mTableView.reloadData()
    }
    
    func setupView(){
        mTableView = UITableView(frame: CGRectMake(0,0,PhoneUtils.screenWidth,PhoneUtils.screenHeight))
        //注册view
        mTableView!.registerNib(UINib(nibName: "QuranTextCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        mTableView.delegate = self
        mTableView.dataSource = self
        self.view.addSubview(mTableView)
    }
    
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translationArray.count
    }
    
    //生成界面
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : QuranTextCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! QuranTextCell
        let translation : Translation = translationArray[indexPath.row] as! Translation
        cell.ivCountry.image = UIImage(named: (translation.quran_translation_country_icon as! String))
        cell.tvLanguage.text = (translation.quran_translation_entry as! String)
        cell.tvActor.text = (translation.quran_translation_actor as! String)
        
        let row = indexPath.row
        if(row > 20){
            cell.ivSelected.hidden = true
            cell.ivDownload.hidden = false
        }else{
            cell.ivSelected.hidden = false
            cell.ivDownload.hidden = true
            if(select == row){
                cell.ivSelected.hidden = false
            }else{
                cell.ivSelected.hidden = true
            }
        }
        
        return cell
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        Config.saveCurrentLanguageIndex(indexPath.row)
        select = indexPath.row
        mTableView.reloadData()
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
