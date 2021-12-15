//
//  ImagePreviewSecondVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import UIKit
import SwiftyJSON

class ImageSaver: NSObject {
    var completionHandler: ((Bool)->())?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        completionHandler?(true)
    }
}
//图片浏览控制器
class ImagePreviewSecondVC: UIViewController {

    //存储图片数组
    var images: [UIImage]
    //默认显示的图片索引
    var index:Int
    //用来放置各个图片单元
    var collectionView:UICollectionView!
    //collectionView的布局
    var collectionViewLayout: UICollectionViewFlowLayout!
    //页控制器（小圆点）
    var pageControl : UIPageControl!
    //初始化
    
    init(images: [UIImage], index:Int = 0){
        self.images = images
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    //初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景设为黑色
        self.view.backgroundColor = UIColor.black
        //collectionView尺寸样式设置
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        //横向滚动
        collectionViewLayout.scrollDirection = .horizontal
        
        //collectionView初始化
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 50, width: WIDTH, height: HEIGHT-100),
                                          collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.black
        collectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        //不自动调整内边距，确保全屏
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(collectionView)
        
        //将视图滚动到默认图片上
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //设置页控制器
        pageControl = UIPageControl()
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
        pageControl.numberOfPages = images.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index
        //view.addSubview(self.pageControl)
        
        let back_Btn = UIButton()
        back_Btn.setImage(UIImage(named: "Group267"), for: .normal)
        back_Btn.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        back_Btn.tintColor = .white
        back_Btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(back_Btn)
        back_Btn.topAnchor.constraint(equalTo: view.topAnchor, constant: StatusBarFrameH ?? 0 + 10).isActive = true
        back_Btn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        back_Btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        back_Btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    //视图显示时
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //视图消失时
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    //将要对子视图布局时调用（横竖屏切换时）
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //重新设置collectionView的尺寸
        collectionView.frame.size = CGSize(width: WIDTH, height: HEIGHT-100)
        collectionView.collectionViewLayout.invalidateLayout()
        
        //将视图滚动到当前图片上
        let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //重新设置页控制器的位置
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
//ImagePreviewVC的CollectionView相关协议方法实现
extension ImagePreviewSecondVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //collectionView单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    //collectionView单元格创建
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewCell
        cell.backgroundColor = .black
        cell.imageView.image = self.images[indexPath.row]
//        if self.images[indexPath.row]["content"].stringValue != "" {
//            if let url = URL(string: self.images[indexPath.row]["content"].stringValue) {
//                cell.imageView.sd_setImage(with: url, completed: nil)
//            }
//        }
        
        return cell
    }
    //collectionView单元格尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: WIDTH, height: HEIGHT-100)
    }
    //collectionView里某个cell将要显示
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImagePreviewCell {
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.resetSize()
        }
    }
    //collectionView里某个cell显示完毕
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //当前显示的单元格
        let visibleCell = collectionView.visibleCells[0]
        //设置页控制器当前页
        self.pageControl.currentPage = collectionView.indexPath(for: visibleCell)!.item
    }
}
