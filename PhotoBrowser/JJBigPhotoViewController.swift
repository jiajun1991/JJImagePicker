//
//  JJBigPhotoViewController.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import Photos

class JJBigPhotoViewController: UIViewController,UIScrollViewDelegate {
    var bigPhotoDataAry:NSArray = []
    var selectedImageAry:NSMutableArray?
    var currentIndex:NSInteger?
    var naviRightBtn:UIButton?
    var allImageAry:NSMutableArray?
    var returnSelectedImagesBlock:((NSMutableArray)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.allImageAry = NSMutableArray.init(capacity: self.bigPhotoDataAry.count)
        for _ in self.bigPhotoDataAry {
            self.allImageAry?.add("1")
        }
        self.setUI()
    }
    lazy var scrollView:UIScrollView = {
       let tempScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: self.view.frame.size.height-JJ_SAFEAREABOTTOM))
        let num = CGFloat(self.bigPhotoDataAry.count)
        tempScroll.contentSize = CGSize.init(width: num*SCREENWIDTH, height: 0)
        tempScroll.isPagingEnabled = true
        tempScroll.alwaysBounceVertical = false
        tempScroll.backgroundColor = UIColor.black
        tempScroll.delegate = self
        tempScroll.showsVerticalScrollIndicator = false
        tempScroll.showsHorizontalScrollIndicator = false
        return tempScroll
    }()
    func setUI() {
        //导航栏右边的选择图片按钮
        self.naviRightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: JJNAVIBARHEIGHT, height: JJNAVIBARHEIGHT))
        self.naviRightBtn?.setImage(UIImage.init(named: "selected"), for: UIControlState.selected)
        self.naviRightBtn?.setImage(UIImage.init(named: "unSelected"), for: UIControlState.normal)
        self.naviRightBtn?.addTarget(self, action: #selector(rightSelectAction(btn:)), for: UIControlEvents.touchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(customView: naviRightBtn!)
        self.navigationItem.rightBarButtonItem = rightItem
        self.view.backgroundColor = UIColor.white
        self.title = String.init(format: "%d/%d", self.currentIndex!+1,self.bigPhotoDataAry.count)
        self.view.addSubview(self.scrollView)
            
        let iv:UIImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(self.currentIndex!)*SCREENWIDTH, y: 0, width: SCREENWIDTH, height: self.scrollView.frame.size.height))
        iv.contentMode = UIViewContentMode.scaleAspectFit
        iv.tag = self.currentIndex!
        self.scrollView.addSubview(iv)
        let size = iv.frame.size
        JJPhotoTool.shareManager().getImageByAsset(asset: self.bigPhotoDataAry[self.currentIndex!] as! PHAsset, size: size, resizeMode: PHImageRequestOptionsResizeMode.exact, completion: { (assetImage) in
                iv.image = assetImage
            self.allImageAry?[self.currentIndex!] = assetImage
        })
        self.scrollView.contentOffset.x = SCREENWIDTH * CGFloat(self.currentIndex!)
        self.naviRightBtn?.isSelected  =  self.isOrNotSelected(index: self.currentIndex!)

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x/SCREENWIDTH + 1
        self.currentIndex = NSInteger(scrollView.contentOffset.x/SCREENWIDTH)
        self.title = String.init(format: "%.0f/%d", currentPage,self.bigPhotoDataAry.count)
        self.naviRightBtn?.isSelected = self.isOrNotSelected(index: self.currentIndex!)
        for view in scrollView.subviews {
            if view.tag == self.currentIndex{
                return
            }
        }
        let iv:UIImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(self.currentIndex!)*SCREENWIDTH, y: 0, width: SCREENWIDTH, height: self.scrollView.frame.size.height))
        iv.contentMode = UIViewContentMode.center
        iv.tag = self.currentIndex!
        self.scrollView.addSubview(iv)
        let size = iv.frame.size
        JJPhotoTool.shareManager().getImageByAsset(asset: self.bigPhotoDataAry[self.currentIndex!] as! PHAsset, size: size, resizeMode: PHImageRequestOptionsResizeMode.exact, completion: { (assetImage) in
            iv.image = assetImage
            self.allImageAry?[self.currentIndex!] = assetImage
        })
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
            //调用增加函数
            self.addImage(index: self.currentIndex!, image: self.allImageAry![self.currentIndex!] as! UIImage)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
