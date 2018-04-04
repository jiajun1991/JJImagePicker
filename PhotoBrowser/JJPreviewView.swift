//
//  JJPreviewView.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/4/3.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class JJPreviewView: UIView,UIScrollViewDelegate {    
    lazy var scrollView:UIScrollView = {
      let tempScroll = UIScrollView.init()
        tempScroll.frame = self.bounds
        tempScroll.maximumZoomScale = 3.0
        tempScroll.minimumZoomScale = 1.0
        tempScroll.isMultipleTouchEnabled = true
        tempScroll.delegate = self
        tempScroll.scrollsToTop = false
        tempScroll.showsHorizontalScrollIndicator = false
        tempScroll.showsVerticalScrollIndicator = false
        tempScroll.delaysContentTouches = false
        return tempScroll
    }()
    lazy var imageView:UIImageView = {
        let tempIV = UIImageView.init(frame: self.containerView.frame)
        tempIV.contentMode = UIViewContentMode.scaleAspectFit
        return tempIV
    }()
    lazy var containerView:UIView = {
        let tempContainer = UIView.init(frame: self.scrollView.frame)
        return tempContainer
    }()
    func resetScale() {
        self.scrollView.zoomScale = 1
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        self.resetScale()
        
    }
    func initUI() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
        
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapAction(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    @objc func doubleTapAction(recognizer:UITapGestureRecognizer) {
        let scrollView = self.scrollView
        var scale :CGFloat = 1
        if scrollView.zoomScale != 3.0 {
            scale = 3
        }else{
            scale = 1
        }
        let zoomRect = self.zoomRectForScale(scale: scale, center: recognizer.location(in: recognizer.view))
        scrollView.zoom(to: zoomRect, animated: true)
    }
    func zoomRectForScale(scale:CGFloat,center:CGPoint) -> CGRect {
        var zoomRect:CGRect = CGRect.init()
        zoomRect.size.height = self.scrollView.frame.size.height/scale
        zoomRect.size.width = self.scrollView.frame.size.width/scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - zoomRect.size.height/2
        return zoomRect
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = scrollView.frame.size.width > scrollView.contentSize.width ?(scrollView.frame.size.width-scrollView.contentSize.width)*0.5:0
        let offsetY = scrollView.frame.size.height>scrollView.contentSize.height ?(scrollView.frame.size.height-scrollView.contentSize.height)*0.5:0
        self.containerView.center = CGPoint.init(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height*0.5 + offsetY)
    }
}
