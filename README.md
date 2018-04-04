# JJImagePicker
安装说明
1.普通安装：
把PhotoBrowser整个文件夹放到自己的项目中。
导入Photos.framework和PhotosUI.framework。
 ```swift
let imageSheet:JJImagePickerSheet = JJImagePickerSheet.init(frame: CGRect.zero)
imageSheet.destinationControler = self
//这里是自定义的一些内容，目前包括导航栏颜色，导航栏字体颜色，状态栏样式，最大选择数量
imageSheet.configuration?.maxSelectCount = 3
imageSheet.configuration?.navTitleColor = UIColor.white
imageSheet.configuration?.navBarColor = UIColor.init(red: 56/255.0, green: 124/255.0, blue: 150/255.0, alpha: 1)
imageSheet.imageBlock = {(images) in
//在这里写处理数据和更新UI的代码
}
self.view.addSubview(imageSheet)
```
最后还有一点就是要在plist文件中加入相机和相册的使用权限。


