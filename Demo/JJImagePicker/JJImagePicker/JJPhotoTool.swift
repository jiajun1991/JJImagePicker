//
//  JJPhotoTool.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import Photos
class JJPhotoTool: NSObject {
static let _shareManager = JJPhotoTool()
    class func shareManager()->JJPhotoTool {
        return _shareManager
    }
    ///看是否有相关权限
    func havePhotoLibraryAuthority() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.restricted || status == PHAuthorizationStatus.denied {
            return false
        }
        return true
    }
    //MARK:获得指定类别的所有结果
    func fetchAssetsInAssetCollection(assetCollection:PHAssetCollection,ascending:Bool) -> PHFetchResult<AnyObject> {
        let option:PHFetchOptions = PHFetchOptions.init()
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: ascending)];
        let result:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: option)
        return result as! PHFetchResult<AnyObject>
    }
    ///根据英文名翻译成中文名
    func transformAlbumTitle(title:NSString) -> NSString {
        if title == "Slo-mo" {
            return "慢动作"
        }else if title == "Recently Added"{
            return "最近添加"
        }else if title == "Favorites"{
            return "最爱"
        }else if title == "Recently Deleted"{
            return "最近删除"
        }else if title == "Videos"{
            return "视频"
        }else if title == "All Photos"{
            return "所有照片"
        }else if title == "Selfies"{
            return "自拍"
        }else if title == "Screenshots"{
            return "屏幕快照"
        }else if title == "Camera Roll"{
            return "相机胶卷"
        }else if title == "My Photo Stream"{
            return "我的照片流"
        }else if title == "Panoramas"{
            return "全景照片"
        }else if title == "Time-lapse"{
            return "延时摄影"
        }else if title == "Live Photos"{
            return "实况照片"
        }
        return ""
    }
    //MARK:获得所有的相册
    func getAllPhotoList() -> [JJPhotoListModel] {
        var photoList:[JJPhotoListModel] = NSMutableArray.init() as! [JJPhotoListModel]
        ///获取所有的系统相册
        let smartAlbum:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        smartAlbum.enumerateObjects { (collection, idx, stop) in
            if !(collection.localizedTitle == "Recently Deleted" || collection.localizedTitle == "Videos" || collection.localizedTitle == "Time-lapse"){
                let result:PHFetchResult = self.fetchAssetsInAssetCollection(assetCollection: collection, ascending: false)
                if result.count > 0{
                    let list:JJPhotoListModel = JJPhotoListModel()
                    list.photoTitle = self.transformAlbumTitle(title: collection.localizedTitle! as NSString)
                    list.photoNum = result.count
                    list.firstAsset = result.firstObject as? PHAsset
                    list.assetCollection = collection
                    photoList.append(list)
                }
            }
        }
        ///用户创建的相册
        let userAlbum:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
        userAlbum.enumerateObjects { (collection, idx, stop) in
            let result:PHFetchResult = self.fetchAssetsInAssetCollection(assetCollection: collection, ascending: false)
            if result.count > 0{
                let list:JJPhotoListModel = JJPhotoListModel()
                list.photoTitle = self.transformAlbumTitle(title: collection.localizedTitle! as NSString)
                if list.photoTitle == ""{
                    list.photoTitle = collection.localizedTitle! as NSString
                }
                list.photoNum = result.count
                list.firstAsset = result.firstObject as? PHAsset
                list.assetCollection = collection
                photoList.append(list)
            }
        }
        return photoList
    }
    func getLatestAddedPhotoList() -> JJPhotoListModel {
        let photos:JJPhotoListModel = JJPhotoListModel()
        let smartAlbum:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
                smartAlbum.enumerateObjects { (collection, idx, stop) in
                    if collection.localizedTitle == "Recently Added"{
                        let result:PHFetchResult = self.fetchAssetsInAssetCollection(assetCollection: collection, ascending: false)
                        if result.count > 0{
                            photos.photoTitle = self.transformAlbumTitle(title: collection.localizedTitle! as NSString)
                            photos.photoNum = result.count
                            photos.firstAsset = result.firstObject as? PHAsset
                            photos.assetCollection = collection
                        }
                    }
        }
        return photos
    }
    //MARK:获取asset相对应的照片
    func getImageByAsset(asset:PHAsset,size:CGSize,resizeMode:PHImageRequestOptionsResizeMode,completion: @escaping (UIImage)->()) {
        let option:PHImageRequestOptions = PHImageRequestOptions.init()
        /*
         resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
         deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
         这个属性只有在 synchronous 为 true 时有效。
         */
        option.resizeMode = resizeMode
        option.isNetworkAccessAllowed = true
        PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: option) { (image, info) in
            completion(image!)
        }
    }
    //MARK:获得指定相册的所有图片
    func getAssetsInAssetCollection(assetCollection:PHAssetCollection,ascending:Bool) -> [PHAsset] {
        let arr:NSMutableArray = NSMutableArray.init()
        let result:PHFetchResult = self.fetchAssetsInAssetCollection(assetCollection: assetCollection, ascending: ascending)
        result.enumerateObjects { (obj, idx, stop) in
            arr.add(obj)
        }
        return arr as! [PHAsset]
    }
}
