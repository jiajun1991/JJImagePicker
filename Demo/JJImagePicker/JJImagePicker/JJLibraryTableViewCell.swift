//
//  JJLibraryTableViewCell.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/30.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class JJLibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var firstIv: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
