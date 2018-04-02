# JJImagePicker
###安装说明
######1.普通安装：
######把PhotoBrowser整个文件夹放到自己的项目中。
######导入Photos.framework和PhotosUI.framework。
######在需要使用到JJImagePicker的地方import Photos.framework。
 ```swift
let imageSheet:JJImagePickerSheet = JJImagePickerSheet.init(frame: CGRect.zero)
imageSheet.destinationControler = self
imageSheet.imageBlock = {(images) in
//在这里写处理数据和更新UI的代码
}
self.view.addSubview(imageSheet)
```
######最后还有一点就是要在plist文件中加入相机和相册的使用权限。


