//
//  ProjectSecondAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class ProjectSecondAddVC: UIViewController {
    
    @IBOutlet var input_View: [InputTextFieldPickerView]!

    var titleArr = ["社區", "住戶", "估價單號", "工程開始", "工程結束", "建立一般工程名稱"]
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "新增\(name)"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle("建立", for: .normal)
        rightFirstBtn.tintColor = .white
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        for index in 0..<input_View.count {
            if index < 3 {
                input_View[index].isUserInteractionEnabled = false
                input_View[index].input_textField.backgroundColor = FalseGary_Color
            }
            input_View[index].title_label.text = titleArr[index]
        }
    }
    @objc private func nextButton(_ sender: UIButton) {
        let projectThirdAddVC = Project_Storyboard.instantiateViewController(withIdentifier: "ProjectThirdAddVC") as! ProjectThirdAddVC
        projectThirdAddVC.name = name
        self.navigationController?.pushViewController(projectThirdAddVC, animated: true)
    }
}
