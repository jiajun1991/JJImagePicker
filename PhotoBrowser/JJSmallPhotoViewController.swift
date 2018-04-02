//
//  JJSmallPhotoViewController.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import Photos
class JJSmallPhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var dataAry:NSArray = []
    var selectedImageAry:NSMutableArray = NSMutableArray.init()
    var returnImagesBlock:((NSMutableArray)->())?
    
    lazy var smallPhotoCv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let tempCV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: self.view.frame.size.height-JJ_SAFEAREABOTTOM), collectionViewLayout: layout)
        layout.itemSize = CGSize.init(width: (SCREENWIDTH-20)/3, height: (SCREENWIDTH-20)/3)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        //设置item的四边边距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        //列间距
        layout.minimumLineSpacing = 5
        //行间距
        layout.minimumInteritemSpacing = 0
        tempCV.delegate = self
        tempCV.dataSource = self
        tempCV.register(UINib.init(nibName: "JJSmallPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JJSmallPhotoCollectionViewCellID")
        tempCV.backgroundColor = UIColor.white
        //滑动到最底部
        var item = tempCV.numberOfItems(inSection: 0)-1
        var lastItemIndex = NSIndexPath.init(item: item, section: 0)
        tempCV.selectItem(at: lastItemIndex as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.top)
        return tempCV
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JJSmallPhotoCollectionViewCellID", for: indexPath) as! JJSmallPhotoCollectionViewCell
        let size:CGSize = cell.frame.size
        JJPhotoTool.shareManager().getImageByAsset(asset: self.dataAry[indexPath.row] as! PHAsset, size: size, resizeMode: PHImageRequestOptionsResizeMode.none) { (assetImage) in
            cell.smallIV.image = assetImage
        }
        cell.clickBlock = {(btn) in
            //点击上面选中的按钮
            if btn.isSelected == true {
                let selectedDic = ["selectedIndex":indexPath.row,"image":cell.smallIV.image!] as [String : Any]
                self.selectedImageAry.add(selectedDic)
            }
        }
        if self.selectedImageAry.count != 0 &&  self.cellIsSelected(index: indexPath.row){
            cell.selectBtn.isSelected = true
        }else{
            cell.selectBtn.isSelected = false
        }
        return cell
        
    }
    func cellIsSelected(index:NSInteger) -> Bool {
        for item in self.selectedImageAry {
            let dic = item as! NSDictionary
            if dic["selectedIndex"] as! NSInteger == index{
                return true
            }
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //进入大图模式
        let bigPhotoVC = JJBigPhotoViewController()
        bigPhotoVC.bigPhotoDataAry = self.dataAry
        bigPhotoVC.selectedImageAry = NSMutableArray.init(array: self.selectedImageAry)
        bigPhotoVC.currentIndex = indexPath.row
        bigPhotoVC.returnSelectedImagesBlock = {(returnArray) in
            //返回的图片数组
            self.selectedImageAry = returnArray
            self.smallPhotoCv.reloadData()
        }
        self.navigationController?.pushViewController(bigPhotoVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        //布局
        self.setUI()
    }
    func setUI() {
        self.view.addSubview(self.smallPhotoCv)
        self.view.backgroundColor = UIColor.white
        let rightNaviBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: JJNAVIBARHEIGHT, height: JJNAVIBARHEIGHT))
        rightNaviBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        rightNaviBtn.setTitle("确定", for: UIControlState.normal)
        rightNaviBtn.addTarget(self, action: #selector(confirmAction), for: UIControlEvents.touchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(customView: rightNaviBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    @objc func confirmAction() {
        let nav:JJNavigationController = self.navigationController as! JJNavigationController
        let images = NSMutableArray.init()
        for item in self.selectedImageAry {
            let dic = item as! NSDictionary
            images.add(dic["image"] as! UIImage)
        }
        nav.callSelectImageBlock!(images)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
