//
//  JJBigPhotoCollectionViewCell.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/4/3.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class JJBigPhotoCollectionViewCell: UICollectionViewCell {
    var willDisplaying:Bool?
    lazy var previewView:JJPreviewView = {
        let tempPreview = JJPreviewView.init(frame: self.contentView.frame)
        tempPreview.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        return tempPreview
    }()
    func resetCellStatus() {
        self.previewView.resetScale()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.previewView)
    }
}
