//
//  DemoRouterViewController.swift
//  JJImagePicker
//
//  Created by 李骏 on 2018/3/28.
//  Copyright © 2018年 李骏. All rights reserved.
//

import UIKit

class DemoRouterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var dataArray:NSMutableArray?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :DemoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCollectionViewCellID", for: indexPath) as! DemoCollectionViewCell
        cell.iv.image = self.dataArray?[indexPath.row] as? UIImage
        return cell
    }
    @IBOutlet weak var cv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = NSMutableArray.init()
        self.cvConfig()
        
    }
    //collectionView配置
    func cvConfig(){
        self.cv.register(UINib.init(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCollectionViewCellID")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: 40, height: 40)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        //设置item的四边边距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        //列间距
        flowLayout.minimumLineSpacing = 0
        //行间距
        flowLayout.minimumInteritemSpacing = 0
        self.cv.delegate = self
        self.cv.dataSource = self
        
    }
    @IBAction func showJJImageAction(_ sender: Any) {
        let imageSheet:JJImagePickerSheet = JJImagePickerSheet.init(frame: CGRect.zero)
        imageSheet.destinationControler = self
        imageSheet.imageBlock = {(images) in
            self.dataArray?.addObjects(from: images as! [Any])
            self.cv.reloadData()
        }
        self.view.addSubview(imageSheet)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
