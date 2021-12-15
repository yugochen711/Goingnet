//
//  MaintainDetailVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/12/8.
//

import UIKit

class MaintainDetailVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    var customAlert: CustomAlert? = nil
    var detailArr = [(title: String, content: String, first: Bool, second: Bool, third: Bool, textColor: UIColor)]()
    var dataSource: DB_dataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        if let data = self.dataSource {
            self.title = "\(data.name ?? "") \(data.building ?? "") \(data.system ?? "") (ID:\(data.item_id ?? ""))"
            let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
            rightFirstBtn.addTarget(self, action: #selector(detailButton(_:)), for: .touchUpInside)
            rightFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8.0)
            rightFirstBtn.setTitle("● ● ●", for: .normal)
            rightFirstBtn.setTitleColor(.white, for: .normal)
            let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
            navigationItem.rightBarButtonItem = rightFirstItem
            
            let nib = UINib(nibName: "DetailCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "Cell")
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.showsVerticalScrollIndicator = false
            
            detailUpdate(data: data)
        }
    }
    func detailUpdate(data: DB_dataSource) {
        detailArr = [(title: "保養說明", content: data.instruction1 ?? "", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "棟別", content: data.building ?? "", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "梯間", content: data.staircase ?? "", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "樓層", content: data.floor ?? "", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "位置", content: data.position ?? "", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "紀錄時間", content: data.time ?? "", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "上傳狀態", content: data.upload_status ? "是": "否", first: false, second: true, third: true, textColor: data.upload_status ? Main_Color: Red_Color),
                     (title: "編輯狀態", content: data.edit_status ? "是": "否", first: false, second: true, third: true, textColor: UIColor.black),
                     (title: "現場照片", content: "查看現場照片", first: true, second: false, third: true, textColor: UIColor.white)]
        tableView.reloadData()
    }
    
    @objc private func detailListButton(_ sender: UIButton) {
        customAlert?.dismissAlert()
        if let data = self.dataSource {
            switch sender.currentTitle {
            case "上傳":
                break
            case "修改":
                let maintainSecondAddVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainSecondAddVC") as! MaintainSecondAddVC
                maintainSecondAddVC.item_id = data.item_id ?? ""
                maintainSecondAddVC.maintain_id = data.maintain_id ?? ""
                maintainSecondAddVC.group_id = data.group_id ?? ""
                maintainSecondAddVC.start_date = data.startDate ?? ""
                maintainSecondAddVC.end_date = data.endDate ?? ""
                maintainSecondAddVC.name = data.name ?? ""
                maintainSecondAddVC.pageType = "Edit"
                maintainSecondAddVC.completionHandler = { (data) in
                    self.dataSource = data
                    self.detailUpdate(data: data)
                }
                self.navigationController?.pushViewController(maintainSecondAddVC, animated: true)
            case "刪除":
                self.alertController(title: "提示", message: Hint_Delete_msg, check: "確定", cancel: "取消") {
                    self.deleteDB(str: "DELETE FROM goingnet WHERE group_id = \(data.group_id ?? "") AND maintain_id = \(data.maintain_id ?? "") AND item_id = \(data.item_id ?? "") AND type = '保養'") { (response) in
                        if response {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            default:
                break
            }
        }
    }
    @objc private func detailButton(_ sender: UIButton) {
        if let tabbarC = self.tabBarController {
            customAlert = CustomAlert()
            customAlert?.showAlert(vc: tabbarC, item: ["修改","上傳","刪除"], y: 40)
        }
        if let stackMainView = customAlert?.stackMainView {
            for view in stackMainView.arrangedSubviews {
                if let btn = view as? UIButton {
                    btn.addTarget(self, action: #selector(detailListButton(_:)), for: .touchUpInside)
                }
            }
        }
    }
}
extension MaintainDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DetailCell
        cell?.selectionStyle = .none
        cell?.title_label.text = detailArr[indexPath.row].title
        cell?.firstContent_label.text = detailArr[indexPath.row].content
        cell?.firstContent_label.textColor = detailArr[indexPath.row].textColor
        cell?.firstContent_label.isHidden = detailArr[indexPath.row].first
        
        cell?.secondContent_label.text = detailArr[indexPath.row].content
        cell?.secondContent_label.textColor = detailArr[indexPath.row].textColor
        cell?.secondContent_label.isHidden = detailArr[indexPath.row].second
        
        cell?.thirdContent_label.text = detailArr[indexPath.row].content
        cell?.thirdContent_label.textColor = detailArr[indexPath.row].textColor
        cell?.thirdContent_label.isHidden = detailArr[indexPath.row].third
        
        return cell!
    }
}
extension MaintainDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if detailArr[indexPath.row].title == "現場照片" {
            //进入图片全屏展示
            if let data = self.dataSource, let img = data.img, let images = self.unarchiveData(img: img) {
                print("images.count = \(images.count)")
                let previewVC = ImagePreviewSecondVC(images: images, index: 0)
                previewVC.modalPresentationStyle = .fullScreen
                self.present(previewVC, animated: true, completion: nil)
            }
        }
    }
}
