//
//  MaintainFirstAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class MaintainFirstAddVC: BaseVC {
    
    @IBOutlet var input_View: [InputTextFieldPickerView]!
    
    var titleArr = ["社區", "保養開始", "保養結束", "建立保養名稱"]
    var contentArr = ["", "", "", ""]
    var group_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "新增保養"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle(group_id == "" ? "建立": "完成", for: .normal)
        rightFirstBtn.tintColor = .white
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        input_View[0].fixed_type = "name"
        input_View[0].group_id = group_id == "" ? "": group_id
        input_View[3].input_textField.delegate = self
        for index in 0..<input_View.count {
            input_View[index].title_label.text = titleArr[index]
            input_View[index].input_textField.text = contentArr[index]
        }
    }
    @objc private func nextButton(_ sender: UIButton) {
        if input_View[0].input_textField.text ?? "" == "" || input_View[1].input_textField.text ?? "" == "" || input_View[2].input_textField.text ?? "" == "" || input_View[3].input_textField.text ?? "" == "" {
            self.alertController(title: "提示", message: Hint_Select1_msg, check: "確定", cancel: "") {
            }
        }else {
            if sender.currentTitle == "建立" {
                let maintainSecondAddVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainSecondAddVC") as! MaintainSecondAddVC
                maintainSecondAddVC.item_id = "1"
                maintainSecondAddVC.maintain_id = ""
                maintainSecondAddVC.group_id = input_View[0].group_id
                maintainSecondAddVC.start_date = input_View[1].input_textField.text ?? ""
                maintainSecondAddVC.end_date = input_View[2].input_textField.text ?? ""
                maintainSecondAddVC.name = "\(input_View[0].input_textField.text ?? "")-\(input_View[3].input_textField.text ?? "")"
                self.navigationController?.pushViewController(maintainSecondAddVC, animated: true)
            }else {
                let group: DispatchGroup = DispatchGroup()
                self.readDB(str: "SELECT * FROM goingnet WHERE group_id = '\(group_id)' AND startDate = '\(contentArr[1])' AND endDate = '\(contentArr[2])' AND type = '保養'") { (respone, err) in
                    if let data = respone {
                        for index in 0..<data.count {
                            group.enter()
                            data[index].name = "\(self.input_View[0].input_textField.text ?? "")-\(self.input_View[3].input_textField.text ?? "")"
                            data[index].group_id = self.input_View[0].group_id
                            data[index].startDate = self.input_View[1].input_textField.text ?? ""
                            data[index].endDate = self.input_View[2].input_textField.text ?? ""
                            data[index].edit_status = true
                            
                            self.updateDB(data: data[index], str: "WHERE group_id = '\(self.group_id)' AND startDate = '\(self.contentArr[1])' AND endDate = '\(self.contentArr[2])' AND type = '保養'") { (respone, status) in
                                group.leave()
                            }
                        }
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    self.alertController(title: "", message: "修改完成", check: "確定", cancel: "") {
                    }
                }
            }
        }
    }
}
extension MaintainFirstAddVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countOfWords = string.count + textField.text!.count - range.length
        if countOfWords > 30 {
            return false
        }
        return true
    }
}
