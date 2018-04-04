//
//  JJImagePickerSheet.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/28.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import PhotosUI
import Photos
class JJImagePickerSheet: UIView,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var destinationControler:UIViewController!
    var takePhotosBtn:UIButton!
    var photoAlbumBtn:UIButton!
    let btnSize:CGFloat = 60
    var imageBlock:((NSArray)->())!
    var configuration:JJPhotoConfiguration?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration = JJPhotoConfiguration.defaultPhotoConfiguration()
        //布局alertSheet
        self.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.takePhotosBtn = UIButton.init(frame: CGRect.init(x: 0, y: self.frame.size.height-btnSize*2-JJ_SAFEAREABOTTOM, width: SCREENWIDTH, height: btnSize))
        self.photoAlbumBtn = UIButton.init(frame: CGRect.init(x: 0, y: self.frame.size.height-btnSize-JJ_SAFEAREABOTTOM, width: SCREENWIDTH, height: btnSize))
        self.takePhotosBtn.backgroundColor = UIColor.white
        self.photoAlbumBtn.backgroundColor = UIColor.white
        self.takePhotosBtn.setTitle("拍照", for: UIControlState.normal)
        self.photoAlbumBtn.setTitle("相册", for: UIControlState.normal)
        self.takePhotosBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.photoAlbumBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.takePhotosBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.photoAlbumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.takePhotosBtn.addTarget(self, action: #selector(takePhotoAction), for: UIControlEvents.touchUpInside)
        self.photoAlbumBtn.addTarget(self, action: #selector(photoAlbumAction), for: UIControlEvents.touchUpInside)
        self.addSubview(self.takePhotosBtn)
        self.addSubview(self.photoAlbumBtn)
        //添加分割线
        let line:UIView = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height-btnSize-JJ_SAFEAREABOTTOM, width: SCREENWIDTH, height: 1))
        line.backgroundColor = UIColor.lightGray
        self.addSubview(line)
        //添加手势来取消页面
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapRemoveAction))
        self.addGestureRecognizer(tap)
        
    }
    @objc func tapRemoveAction() {
        self.removeFromSuperview()
    }
    @objc func takePhotoAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker:UIImagePickerController = UIImagePickerController.init()
            picker.delegate = self
            picker.allowsEditing = false
            picker.videoQuality = UIImagePickerControllerQualityType.typeHigh
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.destinationControler.present(picker, animated: false, completion: nil)
        }
    }
    @objc func photoAlbumAction(){
        if JJPhotoTool.shareManager().havePhotoLibraryAuthority(){
            let library = JJImagePickerLibraryViewController()
            library.returnImagesBlock = {(selectedImages) in
                self.imageBlock(selectedImages)
            }
            let navi:JJNavigationController = self.getImageNavWithRootVC(rootVC: library)
            let smallPhotoVC = JJSmallPhotoViewController()
            let list = JJPhotoTool.shareManager().getLatestAddedPhotoList()
            //防止是空的
            if let title = list.photoTitle{
                smallPhotoVC.title = title as String
            }
            if let asset = list.assetCollection{
                smallPhotoVC.dataAry = JJPhotoTool.shareManager().getAssetsInAssetCollection(assetCollection: asset, ascending: true) as NSArray
            }
            navi.pushViewController(smallPhotoVC, animated: true)
            self.destinationControler.showDetailViewController(navi, sender: nil)
        }else{
            let alert = UIAlertView.init(title: "提示", message: "请到设置->应用里开启相机相册权限", delegate: nil, cancelButtonTitle: nil)
            self.addSubview(alert)
        }
        self.removeFromSuperview()
    }
    func getImageNavWithRootVC(rootVC:UIViewController) -> JJNavigationController {
        let nav = JJNavigationController.init(rootViewController: rootVC)
        nav.callSelectImageBlock = {(images) in
            self.imageBlock(images)
            nav.dismiss(animated: false , completion: nil)
        }
        nav.configuration = self.configuration
        nav.navigationBar.barTintColor  = self.configuration?.navBarColor
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:(self.configuration?.navTitleColor)!]
        UIApplication.shared.statusBarStyle = (self.configuration?.statusBarStyle)!
        return nav
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let tempImage = info[UIImagePickerControllerOriginalImage] {
            let image:UIImage = tempImage as! UIImage
            //通过block把数据传递回来
            let images:NSArray = [image]
            self.imageBlock(images)
            
            picker.dismiss(animated: true, completion: nil)
            self.removeFromSuperview()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
