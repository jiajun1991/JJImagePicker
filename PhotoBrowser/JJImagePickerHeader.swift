//
//  JJImagePickerHeader.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/28.
//  Copyright © 2018年 李骏. All rights reserved.
//

import Foundation
import UIKit

var SCREENWIDTH = UIScreen.main.bounds.size.width
var SCREENHEIGHT = UIScreen.main.bounds.size.height
var JJ_IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
let JJVersion = Double(UIDevice.current.systemVersion)
let JJVersion2 = CGFloat(JJVersion ?? 0)
var JJ_IOS_11 = JJVersion2 >= 11.0
var JJ_IS_IPHONEX = (JJ_IS_IPHONE && JJ_IOS_11 && min(SCREENWIDTH, SCREENHEIGHT) >= 375 && max(SCREENWIDTH, SCREENHEIGHT) >= 812)
var JJ_SAFEAREABOTTOM = CGFloat(JJ_IS_IPHONEX ? 34 : 0)
var JJNAVIBARHEIGHT = UINavigationBar.appearance().frame.size.height
var TOPHEIGHT = UIApplication.shared.statusBarFrame.height + UINavigationBar.appearance().frame.size.height
var KItemMargin = CGFloat(40)

