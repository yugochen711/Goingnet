//
//  MaintainSecondAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class MaintainSecondAddVC: BaseVC {
    
    @IBOutlet weak var building_View: InputTextFieldPickerView!
    @IBOutlet weak var staircase_View: InputTextFieldPickerView!
    @IBOutlet weak var floor_View: InputTextFieldPickerView!
    @IBOutlet weak var firstDes_View: InputTextView!
    @IBOutlet weak var secondDes_View: InputTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView_HC: NSLayoutConstraint!
    
    var arr = [(cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")),
               (cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277"))]
    var group_id = ""
    var item_id = ""
    var maintain_id = ""
    var start_date = ""
    var end_date = ""
    var name = ""
    var pageType = ""
    var completionHandler: ((DB_dataSource)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("group_id = \(group_id)")
        print("name = \(name)")
        print("start_date = \(start_date)")
        print("end_date = \(end_date)")
        print("item_id = \(item_id)")
        print("maintain_id = \(maintain_id)")
        layout()
    }
    private func layout() {
        self.title = "新增保養細項"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle("完成", for: .normal)
        rightFirstBtn.tintColor = .white
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        building_View.title_label.text = "棟別"
        building_View.fixed_type = "building"
        building_View.group_id = group_id
        
        staircase_View.title_label.text = "梯間"
        staircase_View.fixed_type = "staircase"
        staircase_View.group_id = group_id
        
        floor_View.title_label.text = "樓層"
        floor_View.fixed_type = "floor"
        floor_View.group_id = group_id
        
        firstDes_View.title_label.text = "保養說明"
        firstDes_View.select_Btn.setTitle("選擇說明", for: .normal)
        firstDes_View.fixed_type = "maintain"
        
        secondDes_View.title_label.text = "位置說明"
        secondDes_View.select_Btn.setTitle("選擇位置", for: .normal)
        secondDes_View.fixed_type = "position"
        
        let first_nib = UINib(nibName: "FirstPhotoCell", bundle: nil)
        collectionView.register(first_nib, forCellWithReuseIdentifier: "FirstPhotoCell")
        let second_nib = UINib(nibName: "SecondPhotoCell", bundle: nil)
        collectionView.register(second_nib, forCellWithReuseIdentifier: "SecondPhotoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        if maintain_id == "" {
            self.readDB(str: "SELECT * FROM goingnet WHERE group_id = '\(group_id)' AND type = '保養' AND name = '\(name)' AND startDate = '\(start_date)'") { (respone, err) in
                let count = respone?.count ?? 0
                if count > 0 {
                    if let id = respone?[0].maintain_id {
                        if let number = Int(id) {
                            self.maintain_id = "\(number + 1)"
                        }
                    }
                }else {
                    self.maintain_id = "1"
                }
                print("DB maintain_id = \(self.maintain_id)")
            }
        }else if pageType == "Edit" {
            self.readDB(str: "SELECT * FROM goingnet WHERE type = '保養' AND group_id = '\(group_id)' AND item_id = '\(item_id)' AND maintain_id = '\(maintain_id)'") { (respone, err) in
                if let data = respone {
                    if data.count > 0, let img = data[0].img, let images = self.unarchiveData(img: img) {
                        self.firstDes_View.input_textView.text = data[0].instruction1
                        self.secondDes_View.input_textView.text = data[0].position
                        self.building_View.input_textField.text = data[0].building
                        self.floor_View.input_textField.text = data[0].floor
                        self.staircase_View.input_textField.text = data[0].staircase
                        
                        for index in 0..<images.count {
                            self.arr.append((cell: "SecondPhotoCell", title: "", img: images[index]))
                        }
                        if self.arr.count > 7 {
                            self.arr.removeAll(where: {$0.cell == "FirstPhotoCell"})
                        }
                        let h: Int = self.arr.count/3
                        self.collectionView_HC.constant = CGFloat(self.arr.count%3 == 0 ? (102*h)+(15*(h-1)): (102*h)+102+(15*h))
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    @objc private func checkButton(_ sender: UIButton) {
        let photo = arr.filter({$0.cell == "SecondPhotoCell"})
        let instruction1 = firstDes_View.input_textView.text
        let instruction2 = secondDes_View.input_textView.text
        if photo.count == 0 {
            self.alertController(title: "提示", message: Hint_Photo_msg, check: "確定", cancel: "") {
            }
        }else {
            var arr = [Data]()
            for index in 0..<photo.count {
                if let img = photo[index].img?.pngData() {
                    arr.append(img)
                }
            }
            if self.pageType == "Edit" {
                let group: DispatchGroup = DispatchGroup()
                self.readDB(str: "SELECT * FROM goingnet WHERE type = '保養' AND group_id = '\(group_id)' AND item_id = '\(item_id)' AND maintain_id = '\(maintain_id)'") { (respone, err) in
                    if let data = respone {
                        for index in 0..<data.count {
                            group.enter()
                            data[index].instruction1 = instruction1
                            data[index].building = self.building_View.input_textField.text ?? ""
                            data[index].floor = self.floor_View.input_textField.text ?? ""
                            data[index].staircase = self.staircase_View.input_textField.text ?? ""
                            data[index].position = instruction2
                            data[index].img = self.archivedData(arr: arr)
                            data[index].edit_status = true
                            
                            self.updateDB(data: data[index], str: "WHERE type = '保養' AND group_id = '\(self.group_id)' AND item_id = '\(self.item_id)' AND maintain_id = '\(self.maintain_id)'") { (respone, status) in
                                group.leave()
                                self.completionHandler?(data[index])
                            }
                        }
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    self.alertController(title: "", message: "修改完成", check: "確定", cancel: "") {
                    }
                }
            }else {
                let data = DB_dataSource(type: "保養",
                                         name: self.name,
                                         group_id: self.group_id,
                                         maintain_id: self.maintain_id,
                                         item_id: self.item_id,
                                         building: building_View.input_textField.text ?? "",
                                         floor: floor_View.input_textField.text ?? "",
                                         position: instruction2,
                                         staircase: staircase_View.input_textField.text ?? "",
                                         img: self.archivedData(arr: arr),
                                         instruction1: instruction1,
                                         startDate: start_date,
                                         endDate: end_date,
                                         upload_status: false, edit_status: pageType == "Edit" ? true: false, status: false)
                self.insertDB(data: data) { (data, err) in
                    let data = self.arr.filter({$0.cell == "SecondPhotoCell"})
                    for item in data {
                        if let img = item.img {
                            CustomPhotoAlbum.sharedInstance.save(img) { (result, error) in
                                if let e = error {
                                    // handle error
                                    print("儲存相簿err = \(e)")
                                    return
                                }
                                // save successful, do something (such as inform user)
                            }
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
    }
    @objc private func closeButton(_ sender: UIButton) {
        arr.remove(at: sender.tag)
        if self.arr.filter({$0.cell == "FirstPhotoCell"}).count == 0 {
            self.arr.insert((cell: "FirstPhotoCell", title: "拍照", img: UIImage(named: "Group278")), at: 0)
            self.arr.insert((cell: "FirstPhotoCell", title: "選擇照片", img: UIImage(named: "Group277")), at: 1)
        }
        let h: Int = arr.count/3
        collectionView_HC.constant = CGFloat(arr.count%3 == 0 ? (102*h)+(15*(h-1)): (102*h)+102+(15*h))
        collectionView.reloadData()
    }
}
extension MaintainSecondAddVC: UICollectionViewDataSource {
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
extension MaintainSecondAddVC: UICollectionViewDelegate {
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
extension MaintainSecondAddVC: UICollectionViewDelegateFlowLayout {
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
extension MaintainSecondAddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imagePreViewVC = Main_Storyboard.instantiateViewController(withIdentifier: "ImagePreViewVC") as! ImagePreViewVC
            imagePreViewVC.image = image
            imagePreViewVC.completionHandler = { (data) in
                self.arr.append((cell: "SecondPhotoCell", title: "", img: data))
                if self.arr.count > 7 {
                    self.arr.removeAll(where: {$0.cell == "FirstPhotoCell"})
                }
                let h: Int = self.arr.count/3
                self.collectionView_HC.constant = CGFloat(self.arr.count%3 == 0 ? (102*h)+(15*(h-1)): (102*h)+102+(15*h))
                self.collectionView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            imagePreViewVC.modalPresentationStyle = .fullScreen
            picker.dismiss(animated: true, completion: nil)
            self.present(imagePreViewVC, animated: true, completion: nil)
        }
    }
}
