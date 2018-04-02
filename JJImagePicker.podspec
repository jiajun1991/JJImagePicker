Pod::Spec.new do |s|
  s.name         = 'JJImagePicker'
  s.version      = '1.0.0'
  s.summary      = 'A simple way to multiselect photos from ablum in Swift' 
  s.homepage     = 'https://github.com/jiajun1991/JJImagePicker'
  s.license      = 'MIT'
  s.platform     = :ios
  s.author       = {'李骏' => 'lijun373541933@163.com'}

  s.ios.deployment_target = '8.0'
  s.source       = {:git => 'https://github.com/jiajun1991/JJImagePicker.git', :tag => s.version}
  s.requires_arc = true
  s.frameworks   = 'UIKit','Photos','PhotosUI'
  s.source_files = "PhotoBrowser"
  s.swift_version = "4.0"
end

