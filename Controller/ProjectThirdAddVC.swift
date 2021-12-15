//
//  ProjectThirdAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class ProjectThirdAddVC: UIViewController {
    
    @IBOutlet weak var item_View: InputTextFieldPickerView!
    @IBOutlet weak var building_View: InputTextFieldPickerView!
    @IBOutlet weak var staircase_View: InputTextFieldPickerView!
    @IBOutlet weak var floor_View: InputTextFieldPickerView!
    @IBOutlet weak var firstDes_View: InputTextView!
    @IBOutlet weak var secondDes_View: InputTextView!
    @IBOutlet weak var topTitle_label: UILabel!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var centerTitle_label: UILabel!
    @IBOutlet weak var centerCollectionView: UICollectionView!
    @IBOutlet weak var bottomTitle_label: UILabel!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var group_id = ""
    var name = ""
    var top_arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
               (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]
    var center_arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
               (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]
    var bottom_arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
               (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "新增\(name)細項"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle("完成", for: .normal)
        rightFirstBtn.tintColor = .white
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        item_View.title_label.text = "消防項目"
        item_View.fixed_type = "fire"
        
        building_View.title_label.text = "棟別"
        building_View.fixed_type = "building"
        building_View.group_id = group_id
        
        staircase_View.title_label.text = "梯間"
        staircase_View.fixed_type = "staircase"
        staircase_View.group_id = group_id
        
        floor_View.title_label.text = "樓層"
        floor_View.fixed_type = "floor"
        floor_View.group_id = group_id
        
        firstDes_View.title_label.text = "修繕說明"
        firstDes_View.select_Btn.setTitle("選擇說明", for: .normal)
        firstDes_View.fixed_type = "fix"
        
        secondDes_View.title_label.text = "位置說明"
        secondDes_View.select_Btn.setTitle("選擇位置", for: .normal)
        secondDes_View.fixed_type = "position"
        
        let first_nib = UINib(nibName: "FirstPhotoCell", bundle: nil)
        let second_nib = UINib(nibName: "SecondPhotoCell", bundle: nil)
        topTitle_label.text = "施工前"
        topCollectionView.register(first_nib, forCellWithReuseIdentifier: "FirstPhotoCell")
        topCollectionView.register(second_nib, forCellWithReuseIdentifier: "SecondPhotoCell")
        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        topCollectionView.showsVerticalScrollIndicator = false
        
        centerTitle_label.text = "施工中"
        centerCollectionView.register(first_nib, forCellWithReuseIdentifier: "FirstPhotoCell")
        centerCollectionView.register(second_nib, forCellWithReuseIdentifier: "SecondPhotoCell")
        centerCollectionView.dataSource = self
        centerCollectionView.delegate = self
        centerCollectionView.showsVerticalScrollIndicator = false
        
        bottomTitle_label.text = "施工後"
        bottomCollectionView.register(first_nib, forCellWithReuseIdentifier: "FirstPhotoCell")
        bottomCollectionView.register(second_nib, forCellWithReuseIdentifier: "SecondPhotoCell")
        bottomCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.showsVerticalScrollIndicator = false
    }

    @objc private func checkButton(_ sender: UIButton) {
        
    }
    @objc private func closeTopButton(_ sender: UIButton) {
        top_arr.remove(at: sender.tag)
        if top_arr.count < 2 {
            top_arr.insert((cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")), at: 0)
            top_arr.insert((cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277")), at: 1)
        }
        topCollectionView.reloadData()
    }
    @objc private func closeCenterButton(_ sender: UIButton) {
        center_arr.remove(at: sender.tag)
        if center_arr.count < 2 {
            center_arr.insert((cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")), at: 0)
            center_arr.insert((cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277")), at: 1)
        }
        centerCollectionView.reloadData()
    }
    @objc private func closeBottomButton(_ sender: UIButton) {
        bottom_arr.remove(at: sender.tag)
        if bottom_arr.count < 2 {
            bottom_arr.insert((cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")), at: 0)
            bottom_arr.insert((cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277")), at: 1)
        }
        bottomCollectionView.reloadData()
    }
}
extension ProjectThirdAddVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topCollectionView:
            return top_arr.count
        case centerCollectionView:
            return center_arr.count
        case bottomCollectionView:
            return bottom_arr.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: top_arr[indexPath.row].cell, for: indexPath)
            if let first_cell = cell as? FirstPhotoCell {
                first_cell.title_label.text = top_arr[indexPath.row].title
                first_cell.photo_imgView.image = top_arr[indexPath.row].img
            }
            if let second_cell = cell as? SecondPhotoCell {
                second_cell.photo_imgView.image = top_arr[indexPath.row].img
                second_cell.close_Btn.tag = indexPath.row
                second_cell.close_Btn.addTarget(self, action: #selector(closeTopButton(_:)), for: .touchUpInside)
            }
            
            return cell
        }else if collectionView == centerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: center_arr[indexPath.row].cell, for: indexPath)
            if let first_cell = cell as? FirstPhotoCell {
                first_cell.title_label.text = center_arr[indexPath.row].title
                first_cell.photo_imgView.image = center_arr[indexPath.row].img
            }
            if let second_cell = cell as? SecondPhotoCell {
                second_cell.photo_imgView.image = center_arr[indexPath.row].img
                second_cell.close_Btn.tag = indexPath.row
                second_cell.close_Btn.addTarget(self, action: #selector(closeCenterButton(_:)), for: .touchUpInside)
            }
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bottom_arr[indexPath.row].cell, for: indexPath)
            if let first_cell = cell as? FirstPhotoCell {
                first_cell.title_label.text = bottom_arr[indexPath.row].title
                first_cell.photo_imgView.image = bottom_arr[indexPath.row].img
            }
            if let second_cell = cell as? SecondPhotoCell {
                second_cell.photo_imgView.image = bottom_arr[indexPath.row].img
                second_cell.close_Btn.tag = indexPath.row
                second_cell.close_Btn.addTarget(self, action: #selector(closeBottomButton(_:)), for: .touchUpInside)
            }
            
            return cell
        }
    }
}
extension ProjectThirdAddVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? FirstPhotoCell {
            switch indexPath.row {
            case 0:
                //判断是否能进行拍照，可以的话打开相机
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    picker.allowsEditing = false
                    switch collectionView {
                    case topCollectionView:
                        picker.view.tag = 1
                    case centerCollectionView:
                        picker.view.tag = 2
                    case bottomCollectionView:
                        picker.view.tag = 3
                    default:
                        picker.view.tag = 0
                    }
                    self.present(picker, animated: true, completion: nil)
                }else{
                    print("模拟其中无法打开照相机,请在真机中使用");
                }
            case 1:
                //调用相册功能，打开相册
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = false
                switch collectionView {
                case topCollectionView:
                    picker.view.tag = 1
                case centerCollectionView:
                    picker.view.tag = 2
                case bottomCollectionView:
                    picker.view.tag = 3
                default:
                    picker.view.tag = 0
                }
                self.present(picker, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
extension ProjectThirdAddVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (WIDTH-60)/3
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension ProjectThirdAddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imagePreViewVC = Main_Storyboard.instantiateViewController(withIdentifier: "ImagePreViewVC") as! ImagePreViewVC
            imagePreViewVC.image = image
            imagePreViewVC.completionHandler = { (data) in
                switch picker.view.tag {
                case 1:
                    self.top_arr.append((cell: "SecondPhotoCell", title: "", img: data))
                    if self.top_arr.count > 3 {
                        self.top_arr.removeAll(where: {$0.cell == "FirstPhotoCell"})
                    }
                    self.topCollectionView.reloadData()
                case 2:
                    self.center_arr.append((cell: "SecondPhotoCell", title: "", img: data))
                    if self.center_arr.count > 3 {
                        self.center_arr.removeAll(where: {$0.cell == "FirstPhotoCell"})
                    }
                    self.centerCollectionView.reloadData()
                case 3:
                    self.bottom_arr.append((cell: "SecondPhotoCell", title: "", img: data))
                    if self.bottom_arr.count > 3 {
                        self.bottom_arr.removeAll(where: {$0.cell == "FirstPhotoCell"})
                    }
                    self.bottomCollectionView.reloadData()
                default:
                    break
                }
                self.dismiss(animated: true, completion: nil)
            }
            imagePreViewVC.modalPresentationStyle = .fullScreen
            picker.dismiss(animated: true, completion: nil)
            self.present(imagePreViewVC, animated: true, completion: nil)
        }
    }
}

