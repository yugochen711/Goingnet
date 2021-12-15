//
//  AllExamineFirstAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit

class AllExamineFirstAddVC: BaseVC {

    @IBOutlet var input_View: [InputTextFieldPickerView]!
    
    var titleArr = [(title: "社區", key: "name"),
                    (title: "棟別", key: "building"),
                    (title: "系統", key: "system")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "總檢新增系統"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle("下一步", for: .normal)
        rightFirstBtn.tintColor = .white
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        for index in 0..<input_View.count {
            input_View[index].title_label.text = titleArr[index].title
            input_View[index].fixed_type = titleArr[index].key
        }
    }
    @objc private func nextButton(_ sender: UIButton) {
        if input_View[0].input_textField.text ?? "" == "" || input_View[1].input_textField.text ?? "" == "" || input_View[2].input_textField.text ?? "" == "" {
            self.alertController(title: "提示", message: Hint_Select_msg, check: "確定", cancel: "") {
            }
        }else {
            let allExamineSecondAddVC = AllExamine_Storyboard.instantiateViewController(withIdentifier: "AllExamineSecondAddVC") as! AllExamineSecondAddVC
            self.readDB(str: "SELECT * FROM goingnet WHERE group_id = '\(input_View[0].group_id)' AND type = '總檢'") { (respone, err) in
                let count = respone?.count ?? 0
                allExamineSecondAddVC.item_id = "\(count + 1)"
            }
            allExamineSecondAddVC.group_id = input_View[0].group_id
            allExamineSecondAddVC.name = input_View[0].input_textField.text ?? ""
            allExamineSecondAddVC.building = input_View[1].input_textField.text ?? ""
            allExamineSecondAddVC.system = input_View[2].input_textField.text ?? ""
            self.navigationController?.pushViewController(allExamineSecondAddVC, animated: true)
        }
    }
}
