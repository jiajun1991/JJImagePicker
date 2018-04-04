//
//  JJPhotoConfiguration.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/4/4.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class JJPhotoConfiguration: NSObject {
    ///默认相册配置
    class func defaultPhotoConfiguration() ->JJPhotoConfiguration{
        let configuration = JJPhotoConfiguration.init()
        configuration.maxSelectCount = 9
        configuration.statusBarStyle = UIStatusBarStyle.lightContent
        configuration.navBarColor = UIColor.black
        configuration.navTitleColor = UIColor.white
        return configuration
    }
    ///照片最大选择数量，默认选择数量是9，最小是1
    var maxSelectCount:NSInteger?{
        didSet{
            self.maxSelectCount = ((self.maxSelectCount!>1) ?self.maxSelectCount:1)
        }
    }
    ///状态栏样式，需要在info.plist中添加键"View controller-based status bar appearance"值设置为NO
    var statusBarStyle:UIStatusBarStyle?
    ///导航条颜色，默认黑色
    var navBarColor:UIColor?
    ///导航标题颜色，默认白色
    var navTitleColor:UIColor?
    
}
