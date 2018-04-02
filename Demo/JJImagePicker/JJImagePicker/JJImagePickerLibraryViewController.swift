//
//  JJImagePickerLibraryViewController.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/29.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import Photos
class JJImagePickerLibraryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var returnImagesBlock:((NSMutableArray)->())?
    lazy var selectedImages: NSMutableArray = {
        let tempDataAry = NSMutableArray.init()
        return tempDataAry
    }()
    
    lazy var dataAry: NSMutableArray = {
        let tempDataAry = NSMutableArray.init(array: JJPhotoTool.shareManager().getAllPhotoList())
        return tempDataAry
    }()
    lazy var tv:UITableView = {
        let tempTv = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: self.view.frame.size.height-JJ_SAFEAREABOTTOM), style: UITableViewStyle.plain)
        tempTv.delegate = self
        tempTv.dataSource = self
        tempTv.register(UINib.init(nibName: "JJLibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "JJLibraryTableViewCellID")
       return tempTv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "照片"
        let cancelBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: (self.navigationController?.navigationBar.bounds.size.height)!))
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(customView: cancelBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        //布局
        self.setUI()
    }
    func setUI() {
        self.view.backgroundColor = UIColor.white
        //创建tableview
        self.view.addSubview(self.tv)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JJLibraryTableViewCellID", for: indexPath) as! JJLibraryTableViewCell
        let list = self.dataAry[indexPath.row] as! JJPhotoListModel
        let size:CGSize = CGSize.init(width: 50, height: 50)
        let str1:String = list.photoTitle! as String
        let photoNum = list.photoNum!
        let str2 = String.init(format: "(%d)", photoNum)
        let str = str1 + str2
        cell.photoTitle.text = str
        JJPhotoTool.shareManager().getImageByAsset(asset: list.firstAsset!, size: size, resizeMode: PHImageRequestOptionsResizeMode.none) { (assetImage) in
            cell.firstIv.image = assetImage
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击跳到小图页面
        let smallPhoto = JJSmallPhotoViewController()
        let list = self.dataAry[indexPath.row] as! JJPhotoListModel
        smallPhoto.title = list.photoTitle! as String
        smallPhoto.dataAry = JJPhotoTool.shareManager().getAssetsInAssetCollection(assetCollection: list.assetCollection!, ascending: true) as NSArray
        smallPhoto.returnImagesBlock = {(imagesAry)in
            self.selectedImages = imagesAry
        }
        self.navigationController?.pushViewController(smallPhoto, animated: true)
    }
    @objc func cancelAction(){
        self.dismiss(animated: false, completion: nil)
    }
    deinit {
        self.returnImagesBlock!(self.selectedImages)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
