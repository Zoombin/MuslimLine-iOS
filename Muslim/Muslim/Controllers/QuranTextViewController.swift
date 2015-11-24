//
//  QuranTextViewController.swift
//  Muslim

//  文本&译文

//  Created by LSD on 15/11/7.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class QuranTextViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,httpClientDelegate{
    var httpClient : MSLHttpClient = MSLHttpClient()
    var mTableView:UITableView!
    let cellIdentifier = "QuranTextCellIdentifier"
    
    var translationArray : NSMutableArray = NSMutableArray()
    var select = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("setting_translation_item_title", comment:"");
        
        setupView()
        getData()
        
        httpClient.delegate = self
    }
    
    func getData(){
        select = Config.getCurrentLanguageIndex()
        
        let quranTranslationActors : NSArray! = Config.QuranTranslationActors
        let quranTranslationEntries : NSArray! = Config.QuranTranslationEntries
        let quranTranslationValues : NSArray! = Config.QuranTranslationValues
        let quranTranslationCountryIcon : NSArray! = Config.QuranTranslationCountryIcon
        
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
            let path = FileUtils.documentsDirectory() + "/"+download_url
            if(NSFileManager.defaultManager().fileExistsAtPath (path)){
                translation.isdownload = 1;
            }else{
                translation.isdownload = 0;
            }
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
    
    
    /***  网络请求回调    ****/
    func succssResult(result : NSObject, tag : NSInteger) {
        var path = result as? String
        path = path!.stringByReplacingOccurrencesOfString("file://", withString: "")
        let sql = ZipUtils.readZipFile(path!)//读zip文件
        FMDBHelper.getInstance().executeSQLs(sql)//写入数据库
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: select, inSection: 0)
        let cell : QuranTextCell =  mTableView.cellForRowAtIndexPath(indexPath) as! QuranTextCell
        
        cell.probar.stopAnimating()
        cell.probar.hidden = true
        Config.saveCurrentLanguageIndex(indexPath.row)
        let translation : Translation = translationArray[indexPath.row] as! Translation
        translation.isdownload = 1
        mTableView.reloadData()
    }
    
    func errorResult(error : NSError, tag : NSInteger) {
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: select, inSection: 0)
        let cell : QuranTextCell =  mTableView.cellForRowAtIndexPath(indexPath) as! QuranTextCell
        
        cell.ivSelected.hidden = true
        cell.ivDownload.hidden = false
        cell.probar.stopAnimating()
        cell.probar.hidden = true
        self.view.makeToast(message: "下载失败")
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
        cell.probar.hidden = true
        
        if(1 == translation.isdownload){
            //文件存在
            cell.ivDownload.hidden = true
            cell.ivSelected.hidden = true
            if(select == indexPath.row){
                cell.ivSelected.hidden = false
            }
        }else{
            cell.ivSelected.hidden = true
            cell.ivDownload.hidden = false
        }
        return cell
    }
    
    //item点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        let translation :Translation = translationArray[row] as! Translation
        let fileName = translation.download_url as! String
        
        select = indexPath.row
        let cell : QuranTextCell =  tableView.cellForRowAtIndexPath(indexPath) as! QuranTextCell
        cell.ivDownload.hidden = true
        
        if(1 == translation.isdownload){
            //文件存在
            let path = FileUtils.documentsDirectory() + "/" + (translation.download_url as! String)
            let sql = ZipUtils.readZipFile(path)//读zip文件
            FMDBHelper.getInstance().executeSQLs(sql)//写入数据库
            
            Config.saveCurrentLanguageIndex(indexPath.row)
            cell.ivSelected.hidden = false
            mTableView.reloadData()
        }else{
            //下载
            let url = Constants.downloadTranslationUri  + fileName
            cell.probar.hidden = false
            cell.probar.startAnimating()
            httpClient.downloadDocument(url,outPath: "")
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
