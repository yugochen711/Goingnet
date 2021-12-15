//
//  AllExamineSecondAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit

class AllExamineSecondAddVC: BaseVC {

    @IBOutlet weak var building_View: InputTextFieldPickerView!
    @IBOutlet weak var system_View: InputTextFieldPickerView!
    @IBOutlet weak var floor_View: InputTextFieldPickerView!
    @IBOutlet weak var locaion_View: InputTextView!
    @IBOutlet weak var firstDes_View: InputTextView!
    @IBOutlet weak var secondDes_View: InputTextView!
    @IBOutlet weak var thirdDes_View: InputTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView_HC: NSLayoutConstraint!
    
    var arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
               (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]
    var group_id = ""
    var name = ""
    var building = ""
    var system = ""
    var item_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("group_id = \(group_id)")
        print("name = \(name)")
        print("building = \(building)")
        print("system = \(system)")
        print("item_id = \(item_id)")
        layout()
    }
    private func layout() {
        self.title = "總檢新增系統"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle("完成", for: .normal)
        rightFirstBtn.tintColor = .white
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        building_View.title_label.text = "棟別"
        building_View.fixed_type = "building"
        building_View.group_id = group_id
        building_View.input_textField.text = building
        
        system_View.title_label.text = "系統"
        system_View.fixed_type = "system"
        system_View.input_textField.text = system
        
        floor_View.title_label.text = "樓層"
        floor_View.fixed_type = "floor"
        floor_View.group_id = group_id
        
        locaion_View.title_label.text = "位置"
        locaion_View.select_Btn.setTitle("選擇位置", for: .normal)
        locaion_View.fixed_type = "position"
        
        firstDes_View.title_label.text = "缺失說明"
        firstDes_View.select_Btn.setTitle("選擇說明", for: .normal)
        firstDes_View.fixed_type = "instruction1"
        secondDes_View.title_label.text = "缺失說明"
        secondDes_View.select_Btn.setTitle("選擇說明", for: .normal)
        secondDes_View.fixed_type = "instruction2"
        thirdDes_View.title_label.text = "缺失說明"
        thirdDes_View.select_Btn.setTitle("選擇說明", for: .normal)
        thirdDes_View.fixed_type = "instruction3"
        
        let first_nib = UINib(nibName: "FirstPhotoCell", bundle: nil)
        collectionView.register(first_nib, forCellWithReuseIdentifier: "FirstPhotoCell")
        let second_nib = UINib(nibName: "SecondPhotoCell", bundle: nil)
        collectionView.register(second_nib, forCellWithReuseIdentifier: "SecondPhotoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
    }
    @objc private func checkButton(_ sender: UIButton) {
        let photo = arr.filter({$0.cell == "SecondPhotoCell"})
        let instruction1 = firstDes_View.input_textView.text
        let instruction2 = secondDes_View.input_textView.text
        let instruction3 = thirdDes_View.input_textView.text
        if photo.count == 0 {
            self.alertController(title: "提示", message: Hint_Photo_msg, check: "確定", cancel: "") {
            }
        }else if instruction1 == "" && instruction2 == "" && instruction3 == "" {
            self.alertController(title: "提示", message: Hint_Was_msg, check: "確定", cancel: "") {
            }
        }else {
            var arr = [Data]()
            for index in 0..<photo.count {
                if let img = photo[index].img?.pngData() {
                    arr.append(img)
                }
            }
            let data = DB_dataSource(type: "總檢",
                                     name: self.name,
                                     group_id: self.group_id,
                                     item_id: self.item_id,
                                     building: self.building,
                                     system: self.system,
                                     floor: floor_View.input_textField.text,
                                     position: locaion_View.input_textView.text,
                                     img: self.archivedData(arr: arr),
                                     instruction1: instruction1,
                                     instruction2: instruction2,
                                     instruction3: instruction3,
                                     upload_status: false, edit_status: false, status: false)
            self.insertDB(data: data) { (data, err) in
                if let img = self.arr.first(where: {$0.cell == "SecondPhotoCell"})?.img {
                    CustomPhotoAlbum.sharedInstance.save(img) { (result, error) in
                        if let e = error {
                            // handle error
                            print("儲存相簿err = \(e)")
                            return
                        }
                        // save successful, do something (such as inform user)
                    }
                }
                self.alertController(title: "提示", message: "ID:\(self.item_id) 儲存成功", check: "確定", cancel: "") {
                    if let itemID = Int(self.item_id) {
                        self.item_id = "\(itemID + 1)"
                    }
                    self.arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
                                (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]
                    self.collectionView.reloadData()
                }
            }
        }
    }
    @objc private func closeButton(_ sender: UIButton) {
        arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
               (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]
        collectionView.reloadData()
    }
}
extension AllExamineSecondAddVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: arr[indexPath.row].cell, for: indexPath)
        if let first_cell = cell as? FirstPhotoCell {
            first_cell.title_label.text = arr[indexPath.row].title
            first_cell.photo_imgView.image = arr[indexPath.row].img
        }
        if let second_cell = cell as? SecondPhotoCell {
            second_cell.photo_imgView.image = arr[indexPath.row].img
            second_cell.close_Btn.tag = indexPath.row
            second_cell.close_Btn.addTarget(self, action: #selector(closeButton(_:)), for: .touchUpInside)
        }
        
        return cell
    }
}
extension AllExamineSecondAddVC: UICollectionViewDelegate {
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
                self.present(picker, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
extension AllExamineSecondAddVC: UICollectionViewDelegateFlowLayout {
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
extension AllExamineSecondAddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imagePreViewVC = Main_Storyboard.instantiateViewController(withIdentifier: "ImagePreViewVC") as! ImagePreViewVC
            imagePreViewVC.image = image
            imagePreViewVC.completionHandler = { (data) in
                self.arr = [(cell: "SecondPhotoCell", title: "", img: data)]
                self.collectionView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            imagePreViewVC.modalPresentationStyle = .fullScreen
            picker.dismiss(animated: true, completion: nil)
            self.present(imagePreViewVC, animated: true, completion: nil)
        }
//        self.dismiss(animated: true, completion: nil)
    }
}
