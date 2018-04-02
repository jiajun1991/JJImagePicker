//
//  JJSmallPhotoCollectionViewCell.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class JJSmallPhotoCollectionViewCell: UICollectionViewCell {
    var clickBlock:((UIButton)->())?
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var smallIV: UIImageView!
    @IBAction func selectAction(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        clickBlock!(btn)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectBtn.setImage(UIImage.init(named: "selected"), for: UIControlState.selected)
        self.selectBtn.setImage(UIImage.init(named: "unSelected"), for: UIControlState.normal)
    }

}
