//
//  JJPhotoListModel.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit
import Photos
class JJPhotoListModel: NSObject {
    /// 相册的名字
    var photoTitle:NSString?
    ///该相册的照片数量
    var photoNum:NSInteger?
    ///该相册的第一张图片
    var firstAsset:PHAsset?
    ///通过该属性可以获得该相册的所有照片
    var assetCollection:PHAssetCollection?
}
