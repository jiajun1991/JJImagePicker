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
    var configuration:JJPhotoConfiguration?{
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func setNaviBackBtn(hidden:Bool) {
        if hidden {
            return
        }else{
//            let backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
//            backBtn.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
//            backBtn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        }
    }
//        @objc func backAction(){
//            self.navigationController?.popViewController(animated: true)
//        }
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
