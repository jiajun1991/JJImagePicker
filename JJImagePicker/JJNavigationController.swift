//
//  JJNavigationController.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/4/2.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class JJNavigationController: UINavigationController {
    var callSelectImageBlock:((NSMutableArray)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
