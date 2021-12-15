//
//  DeleteAndUploadVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit

class DeleteAndUploadVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [(DB_dataSource, Bool)]()
    var pageType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = pageType == "upload" ? "總檢上傳": "總檢刪除"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(detailButton(_:)), for: .touchUpInside)
        rightFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        rightFirstBtn.setTitle("全選", for: .normal)
        rightFirstBtn.setTitleColor(.white, for: .normal)
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        
        let rightSecondBtn = UIButton(type: UIButton.ButtonType.system)
        rightSecondBtn.addTarget(self, action: #selector(detailButton(_:)), for: .touchUpInside)
        rightSecondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        rightSecondBtn.setTitle(pageType == "upload" ? "上傳": "刪除", for: .normal)
        rightSecondBtn.setTitleColor(.white, for: .normal)
        let rightSecondItem = UIBarButtonItem(customView: rightSecondBtn)
        navigationItem.rightBarButtonItems = [rightSecondItem, rightFirstItem]
        
        let nib = UINib(nibName: "DeleteAndUploadCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func detailButton(_ sender: UIButton) {
        if sender.currentTitle == "全選" {
            for index in 0..<dataSource.count{
                dataSource[index].1 = true
            }
            tableView.reloadData()
        }else {
            if pageType == "upload" {
                var data = [DB_dataSource]()
                for index in 0..<self.dataSource.count{
                    if self.dataSource[index].1 {
                        self.dataSource[index].0.upload_status = true
                        data.append(self.dataSource[index].0)
                    }
                }
                self.uploadAll_test(data: data) { (response) in
                    for data in data {
                        self.updateDB(data: data, str: "WHERE group_id = \(data.group_id ?? "") AND item_id = \(data.item_id ?? "")") { (respone, status) in
                        }
                    }
                }
                self.dataSource.removeAll(where: {$0.1})
                self.tableView.reloadData()
            }else {
                self.alertController(title: "提示", message: Hint_Delete_msg, check: "確定", cancel: "取消") {
                    for index in 0..<self.dataSource.count{
                        if self.dataSource[index].1 {
                            self.deleteDB(str: "DELETE FROM goingnet WHERE group_id = \(self.dataSource[index].0.group_id ?? "") AND item_id = \(self.dataSource[index].0.item_id ?? "") AND type = '總檢'") { (response) in
                                if response {
                                    print("刪除 = \(response)")
                                }
                            }
                        }
                    }
                    self.dataSource.removeAll(where: {$0.1})
                    self.tableView.reloadData()
                }
            }
        }
    }
}
extension DeleteAndUploadVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DeleteAndUploadCell
        cell?.selectionStyle = .none
        if indexPath.row%2 == 0 {
            cell?.contentView.backgroundColor = dataSource[indexPath.row].1 ? MainSub_Color: .white
        }else {
            cell?.contentView.backgroundColor = dataSource[indexPath.row].1 ? MainSub_Color: Cell_Color
        }
        cell?.title_label.text = "\(dataSource[indexPath.row].0.name ?? "") \(dataSource[indexPath.row].0.building ?? "") \(dataSource[indexPath.row].0.system ?? "") (ID:\(dataSource[indexPath.row].0.item_id ?? ""))"
        cell?.upload_status = dataSource[indexPath.row].0.upload_status
        cell?.edit_status = dataSource[indexPath.row].0.edit_status
        cell?.status = dataSource[indexPath.row].0.status
        cell?.photo_imgView.image = dataSource[indexPath.row].1 ? UIImage(named: "Ellipse79"): UIImage(named: "Ellipse78")
        
        return cell!
    }
}
extension DeleteAndUploadVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource[indexPath.row].1 = !dataSource[indexPath.row].1
        tableView.reloadData()
    }
}
