//
//  ProjectFirstAddVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class ProjectFirstAddVC: UIViewController {
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var titleNon_label: UILabel!
    @IBOutlet var input_View: [InputTextFieldPickerView]!
    @IBOutlet weak var creat_Btn: MainButton!
    @IBOutlet weak var creatNon_Btn: MainButton!
    
    var titleArr = [(title: "社區", key: "name"),
                    (title: "估價單號", key: ""),
                    (title: "社區", key: "name"),
                    (title: "無合約客戶名稱 / 住戶", key: ""),
                    (title: "估價單號", key: "")]
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "新增\(name)"
        for index in 0..<input_View.count {
            input_View[index].title_label.text = titleArr[index].title
            input_View[index].fixed_type = titleArr[index].key
        }
        title_label.text = "合約客戶"
        titleNon_label.text = "非合約客戶"
        creat_Btn.setTitle("建立", for: .normal)
        creatNon_Btn.setTitle("建立", for: .normal)
    }

    @IBAction func creatButton(_ sender: UIButton) {
        let projectSecondAddVC = Project_Storyboard.instantiateViewController(withIdentifier: "ProjectSecondAddVC") as! ProjectSecondAddVC
        projectSecondAddVC.name = name
        self.navigationController?.pushViewController(projectSecondAddVC, animated: true)
    }
    @IBAction func creatNonButton(_ sender: UIButton) {
        let projectSecondAddVC = Project_Storyboard.instantiateViewController(withIdentifier: "ProjectSecondAddVC") as! ProjectSecondAddVC
        projectSecondAddVC.name = name
        self.navigationController?.pushViewController(projectSecondAddVC, animated: true)
    }
}
