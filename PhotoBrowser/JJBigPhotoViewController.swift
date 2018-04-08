//
//  JJBigPhotoViewController.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import Photos

class JJBigPhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var collectionView:UICollectionView?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bigPhotoDataAry.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        (cell as! JJBigPhotoCollectionViewCell).resetCellStatus()
        (cell as! JJBigPhotoCollectionViewCell).willDisplaying = true
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! JJBigPhotoCollectionViewCell).resetCellStatus()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:JJBigPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JJBigPhotoCollectionViewCell", for: indexPath) as! JJBigPhotoCollectionViewCell
        let size = cell.previewView.imageView.frame.size
        JJPhotoTool.shareManager().getImageByAsset(asset: self.bigPhotoDataAry[indexPath.row] as! PHAsset, size: size, resizeMode: PHImageRequestOptionsResizeMode.none, completion: { (assetImage) in
                cell.previewView.imageView.image = assetImage
                self.allImageAry?[indexPath.row] = assetImage
            })
        return cell
    }
    //MARK:ScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            //看现在是第几个
            self.currentIndex =  NSInteger(scrollView.contentOffset.x/(SCREENWIDTH+KItemMargin))
            self.naviRightBtn?.isSelected = self.isOrNotSelected(index: self.currentIndex!)
            self.title = String.init(format: "%d/%d", self.currentIndex!+1,self.bigPhotoDataAry.count)
        }
    }
    
    var bigPhotoDataAry:NSArray = []
    var selectedImageAry:NSMutableArray?
    var currentIndex:NSInteger?
    var naviRightBtn:UIButton?
    var allImageAry:NSMutableArray?
    var returnSelectedImagesBlock:((NSMutableArray)->())?
    var lastScale:CGFloat?
    var oldIndex:NSInteger?
    var lastImageView:UIImageView?
    var layout:UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allImageAry = NSMutableArray.init(capacity: self.bigPhotoDataAry.count)
        
        for _ in self.bigPhotoDataAry {
            self.allImageAry?.add("1")
        }
        self.lastImageView = UIImageView.init()
        self.setUI()
    }
    
    func setUI() {
        //导航栏左边返回按钮
        let backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        backBtn.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        
        //导航栏右边的选择图片按钮
        self.naviRightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        self.naviRightBtn?.setImage(UIImage.init(named: "selected"), for: UIControlState.selected)
        self.naviRightBtn?.setImage(UIImage.init(named: "unSelected"), for: UIControlState.normal)
        self.naviRightBtn?.addTarget(self, action: #selector(rightSelectAction(btn:)), for: UIControlEvents.touchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(customView: naviRightBtn!)
        self.navigationItem.rightBarButtonItem = rightItem
        self.view.backgroundColor = UIColor.white
        self.title = String.init(format: "%d/%d", self.currentIndex!+1,self.bigPhotoDataAry.count)
        
        self.layout = UICollectionViewFlowLayout.init()
        self.layout?.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.layout?.minimumLineSpacing = KItemMargin
        self.layout?.sectionInset = UIEdgeInsetsMake(0, KItemMargin/2, 0, KItemMargin/2)
        self.layout?.itemSize = CGSize.init(width: SCREENWIDTH, height: self.view.frame.size.height-JJ_SAFEAREABOTTOM)
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: -KItemMargin/2, y: 0, width: SCREENWIDTH+KItemMargin, height: self.view.frame.size.height-JJ_SAFEAREABOTTOM), collectionViewLayout: self.layout!)
        self.collectionView?.backgroundColor = UIColor.black
        self.collectionView?.register(JJBigPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "JJBigPhotoCollectionViewCell")
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.scrollsToTop = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.setContentOffset(CGPoint.init(x: (SCREENWIDTH+KItemMargin)*CGFloat(self.currentIndex!), y: 0), animated: true)
        self.view.addSubview(self.collectionView!)
        
        self.naviRightBtn?.isSelected  =  self.isOrNotSelected(index: self.currentIndex!)

    }
    func isOrNotSelected(index:NSInteger) -> Bool {
        for i in self.selectedImageAry! {
            let everyDic = i as! NSDictionary
            if everyDic["selectedIndex"] as! NSInteger == index{
                return true
            }
        }
        return false
    }
    ///向选中数组中增加图片
    func addImage(index:NSInteger,image:UIImage) {
        let dic = ["selectedIndex":index,"image":image] as [String : Any]
        self.selectedImageAry?.add(dic)
    }
    ///向选中数组中移除图片
    func removeImage(index:NSInteger) {
        for i in self.selectedImageAry! {
            let everyDic = i as! NSDictionary
            if everyDic["selectedIndex"] as! NSInteger == index{
                self.selectedImageAry?.remove(i)
            }
        }
    }
    @objc func rightSelectAction(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            let nav:JJNavigationController = self.navigationController as! JJNavigationController
            if (self.selectedImageAry?.count)! >= (nav.configuration?.maxSelectCount)!{
                //弹出toast
                let style = ToastStyle()
                self.view.makeToast(String.init(format: "最多选择%d张", (nav.configuration?.maxSelectCount)!), duration: 3, position: .center, title: nil, image: nil, style: style, completion: nil)
                //恢复btn状态
                 btn.isSelected = !btn.isSelected
            }else{
                //调用增加函数
                self.addImage(index: self.currentIndex!, image: self.allImageAry![self.currentIndex!] as! UIImage)
            }
        }else{
            //调用移除函数
            self.removeImage(index: self.currentIndex!)
        }
    }
    deinit {
        self.returnSelectedImagesBlock!(self.selectedImageAry!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:自定义方法
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
}
