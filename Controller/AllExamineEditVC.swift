//
//  AllExamineEditVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import UIKit
import SwiftAlertView

class AllExamineEditVC: BaseVC {
    
    @IBOutlet weak var building_View: InputTextFieldPickerView!
    @IBOutlet weak var system_View: InputTextFieldPickerView!
    @IBOutlet weak var floor_View: InputTextFieldPickerView!
    @IBOutlet weak var locaion_View: InputTextView!
    @IBOutlet weak var firstDes_View: InputTextView!
    @IBOutlet weak var secondDes_View: InputTextView!
    @IBOutlet weak var thirdDes_View: InputTextView!
    @IBOutlet weak var firstCollapse_View: CollapseView!
    @IBOutlet weak var first_stackView: UIStackView!
    
    @IBOutlet weak var camera_Btn: RedButton!
    @IBOutlet weak var photo_Btn: RedButton!
    @IBOutlet weak var photo_imgView: UIImageView!
    @IBOutlet weak var secondCollapse_View: CollapseView!
    @IBOutlet weak var second_stackView: UIStackView!
    
    var completionHandler: ((DB_dataSource)->())?
    var dataSource: DB_dataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        if let data = self.dataSource {
            self.title = "\(data.name ?? "") \(data.building ?? "") \(data.system ?? "") (ID:\(data.item_id ?? ""))"
            let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
            rightFirstBtn.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)
            rightFirstBtn.setTitle("完成", for: .normal)
            rightFirstBtn.tintColor = .white
            let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
            navigationItem.rightBarButtonItem = rightFirstItem
            
            building_View.title_label.text = "棟別"
            building_View.input_textField.text = data.building ?? ""
            building_View.group_id = data.group_id ?? ""
            building_View.fixed_type = "building"
            
            system_View.title_label.text = "系統"
            system_View.input_textField.text = data.system ?? ""
            system_View.fixed_type = "system"
            
            floor_View.title_label.text = "樓層"
            floor_View.input_textField.text = data.floor ?? ""
            floor_View.group_id = data.group_id ?? ""
            floor_View.fixed_type = "floor"
            
            locaion_View.title_label.text = "位置"
            locaion_View.input_textView.text = data.position ?? ""
            locaion_View.fixed_type = "position"
            locaion_View.select_Btn.setTitle(" 修改位置", for: .normal)
            locaion_View.select_Btn.setImage(UIImage(named: "mode_24px"), for: .normal)
            locaion_View.select_Btn.tintColor = .white
            
            firstDes_View.title_label.text = "缺失說明"
            firstDes_View.input_textView.text = data.instruction1 ?? ""
            firstDes_View.fixed_type = ""
            firstDes_View.select_Btn.setTitle(" 修改說明", for: .normal)
            firstDes_View.select_Btn.setImage(UIImage(named: "mode_24px"), for: .normal)
            firstDes_View.select_Btn.tintColor = .white
            
            secondDes_View.title_label.text = "缺失說明"
            secondDes_View.input_textView.text = data.instruction2 ?? ""
            secondDes_View.fixed_type = ""
            secondDes_View.select_Btn.setTitle(" 修改說明", for: .normal)
            secondDes_View.select_Btn.setImage(UIImage(named: "mode_24px"), for: .normal)
            secondDes_View.select_Btn.tintColor = .white
            
            thirdDes_View.title_label.text = "缺失說明"
            thirdDes_View.input_textView.text = data.instruction3 ?? ""
            thirdDes_View.fixed_type = ""
            thirdDes_View.select_Btn.setTitle(" 修改說明", for: .normal)
            thirdDes_View.select_Btn.setImage(UIImage(named: "mode_24px"), for: .normal)
            thirdDes_View.select_Btn.tintColor = .white
            
            firstCollapse_View.title_label.text = "位置描述"
            firstCollapse_View.collapse_Btn.addTarget(self, action: #selector(firstCollapseButton(_:)), for: .touchUpInside)
            secondCollapse_View.title_label.text = "現場照片"
            secondCollapse_View.collapse_Btn.addTarget(self, action: #selector(secondCollapseButton(_:)), for: .touchUpInside)
            
            camera_Btn.setTitle("拍照", for: .normal)
            photo_Btn.setTitle("選擇照片", for: .normal)
            photo_imgView.backgroundColor = .black
            if let img = data.img, let images = self.unarchiveData(img: img) {
                if images.count > 0 {
                    photo_imgView.image = images[0]
                }
            }
            photo_imgView.layer.cornerRadius = 5
            photo_imgView.layer.masksToBounds = true
        }
    }
    
    @objc private func checkButton(_ sender: UIButton) {
        print("請選擇接下來的動作")
        let alertView = SwiftAlertView(title: "請選擇接下來的動作", message: "", delegate: self, cancelButtonTitle: "停留在此頁", otherButtonTitles: ["返回詳細資料頁面", "上傳紀錄"])
        alertView.buttonTitleColor = Main_Color
        alertView.cancelButtonIndex = 2
        alertView.show()
        alertView.clickedButtonAction = { buttonIndex in
            print("確定 = \(buttonIndex)")
            switch buttonIndex {
            case 0,1:
                var arr = [Data]()
                let instruction1 = self.firstDes_View.input_textView.text
                let instruction2 = self.secondDes_View.input_textView.text
                let instruction3 = self.thirdDes_View.input_textView.text
                if instruction1 == "" && instruction2 == "" && instruction3 == "" {
                    self.alertController(title: "提示", message: Hint_Was_msg, check: "確定", cancel: "") {
                    }
                }else {
                    if let img = self.photo_imgView.image?.pngData() {
                        arr.append(img)
                    }
                    let data = DB_dataSource(type: "總檢",
                                             name: self.dataSource?.name ?? "",
                                             group_id: self.dataSource?.group_id ?? "",
                                             item_id: self.dataSource?.item_id ?? "",
                                             building: self.building_View.input_textField.text ?? "",
                                             system: self.system_View.input_textField.text ?? "",
                                             floor: self.floor_View.input_textField.text ?? "",
                                             position: self.locaion_View.input_textView.text,
                                             img: self.archivedData(arr: arr),
                                             instruction1: instruction1,
                                             instruction2: instruction2,
                                             instruction3: instruction3,
                                             upload_status: buttonIndex == 1 ? true: false,
                                             edit_status: buttonIndex == 1 ? false: true,
                                             status: false)
                    self.uploadAll_test(callAPI: buttonIndex == 1 ? true: false, data: data, vc: self)
                }
            default:
                break
            }
        }
    }
    @objc private func firstCollapseButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "up") {
            sender.setImage(UIImage(named: "down"), for: .normal)
        }else {
            sender.setImage(UIImage(named: "up"), for: .normal)
        }
        first_stackView.isHidden = !first_stackView.isHidden
    }
    @objc private func secondCollapseButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "up") {
            sender.setImage(UIImage(named: "down"), for: .normal)
        }else {
            sender.setImage(UIImage(named: "up"), for: .normal)
        }
        second_stackView.isHidden = !second_stackView.isHidden
    }
    @IBAction func cameraButton(_ sender: UIButton) {
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
    }
    @IBAction func photoButton(_ sender: UIButton) {
        //调用相册功能，打开相册
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
}
extension AllExamineEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imagePreViewVC = Main_Storyboard.instantiateViewController(withIdentifier: "ImagePreViewVC") as! ImagePreViewVC
            imagePreViewVC.image = image
            imagePreViewVC.completionHandler = { (data) in
                self.photo_imgView.image = data
                self.dismiss(animated: true, completion: nil)
            }
            imagePreViewVC.modalPresentationStyle = .fullScreen
            picker.dismiss(animated: true, completion: nil)
            self.present(imagePreViewVC, animated: true, completion: nil)
        }
//        self.dismiss(animated: true, completion: nil)
    }
}
extension AllExamineEditVC: SwiftAlertViewDelegate {
    
}
