//
//  MaintainUploadVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class MaintainUploadVC: BaseVC {

    @IBOutlet weak var select_label: UILabel!
    @IBOutlet weak var select_Btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [MaintainDataSource]()
    var titleArr = ["今天", "昨天"]
    var pageType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Commit後")
        layout()
    }
    private func layout() {
        self.title = "保養\(pageType)"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(detailButton(_:)), for: .touchUpInside)
        rightFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        rightFirstBtn.setTitle(pageType, for: .normal)
        rightFirstBtn.setTitleColor(.white, for: .normal)
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        select_label.text = "已選擇0個"
        select_Btn.layer.cornerRadius = 5
        select_Btn.layer.borderWidth = 1
        select_Btn.layer.borderColor = Main_Color.cgColor
        select_Btn.setTitle("全選", for: .normal)
        select_Btn.setTitleColor(Main_Color, for: .normal)
        select_Btn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        
        let nib = UINib(nibName: "UploadCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        let upload_status = pageType == "上傳" ? "0": "1"
        self.readDB(str: "SELECT * FROM goingnet WHERE type = '保養' AND upload_status = '\(upload_status)'") { (respone, err) in
            if var data = respone {
                //排序 最新日期開始
                data.sort { (n1, n2) -> Bool in
                    if let n1Date = n1.startDate?.nowTime(), let n2Date = n2.startDate?.nowTime() {
                        return  n1Date > n2Date
                    }
                    return false
                }
                for index in 0..<data.count {
                    print("startDate = \(data[index].startDate ?? ""), name = \(data[index].name ?? ""), end = \(data[index].endDate ?? ""), maintain_id = \(data[index].maintain_id ?? "")")
                }
                //取出相同名稱和相同日期 當作大分類
                var set = Set<String>()
                var unique = [DB_dataSource]()
                for index in 0..<data.count {
                    if !set.contains("\(data[index].name ?? "")-\(data[index].startDate ?? "")-\(data[index].maintain_id ?? "")") {
                        unique.append(data[index])
                        set.insert("\(data[index].name ?? "")-\(data[index].startDate ?? "")-\(data[index].maintain_id ?? "")")
                    }
                }
                //將相同日期的資料放一起
                for index in 0..<unique.count {
                    var selectArr = [Bool]()
                    let arr = self.dataSource.filter({$0.title == unique[index].startDate ?? ""})
                    if arr.count == 0 {
                        //未上傳筆數
                        let noUpload = data.filter({$0.upload_status == false && $0.name == unique[index].name && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id})
                        //總共筆數
                        let allCount = data.filter({$0.name == unique[index].name ?? "" && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id})
                        selectArr.append(false)
                        self.dataSource.append(MaintainDataSource(title: unique[index].startDate ?? "",
                                                             data: [unique[index]],
                                                             noUpload: [noUpload.count],
                                                             allCount: [allCount.count],
                                                             is_Select: selectArr))
                    }else {
                        var otherData = [DB_dataSource]()
                        var otherSelect = [Bool]()
                        for i in 0..<arr[0].data.count {
                            otherData.append(arr[0].data[i])
                            otherSelect.append(false)
                        }
                        otherData.append(unique[index])
                        otherSelect.append(false)
                        if let i = self.dataSource.firstIndex(where: {$0.title == unique[index].startDate ?? ""}) {
                            var noUpload = self.dataSource[i].noUpload
                            noUpload.append(data.filter({$0.upload_status == false && $0.name == unique[index].name ?? "" && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id}).count)
                            
                            var allCount = self.dataSource[i].allCount
                            allCount.append(data.filter({$0.name == unique[index].name ?? "" && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id}).count)
                            self.dataSource[i] = MaintainDataSource(title: unique[index].startDate ?? "",
                                                               data: otherData,
                                                               noUpload: noUpload,
                                                               allCount: allCount,
                                                               is_Select: otherSelect)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func detailButton(_ sender: UIButton) {
        for data in dataSource {
            for index in 0..<data.is_Select.count {
                if data.is_Select[index] {
                    print("startDate = \(data.data[index].startDate ?? ""), name = \(data.data[index].name ?? ""), end = \(data.data[index].endDate ?? ""), maintain_id = \(data.data[index].maintain_id ?? "")")
                }
            }
        }
    }
    @IBAction func selectButton(_ sender: UIButton) {
        var is_Select = 0
        for data in dataSource {
            for index in 0..<data.is_Select.count {
                data.is_Select[index] = true
            }
            is_Select = is_Select + data.data.count
        }
        select_label.text = "已選擇\(is_Select)個"
        tableView.reloadData()
    }
}
extension MaintainUploadVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UploadCell
        cell?.selectionStyle = .none
        cell?.title_label.text = dataSource[indexPath.section].data[indexPath.row].name ?? ""
        cell?.photo_imgView.image = dataSource[indexPath.section].is_Select[indexPath.row] ? UIImage(named: "Ellipse79"): UIImage(named: "Ellipse78")
        cell?.bottom_View.backgroundColor = dataSource[indexPath.section].is_Select[indexPath.row] ? MainSub_Color: .white
        
        return cell!
    }
}
extension MaintainUploadVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title_label = EdgeInsetLabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        title_label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        title_label.font = UIFont.boldSystemFont(ofSize: 20)
        title_label.textColor = Main_Color
        let nowAndyesterday = Date().nowAndyesterday()
        if nowAndyesterday.now == dataSource[section].title {
            title_label.text = "今天"
        }else if nowAndyesterday.yesterday == dataSource[section].title {
            title_label.text = "昨天"
        }else {
            title_label.text = dataSource[section].title
        }
        
        return title_label
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UploadCell {
            if dataSource[indexPath.section].is_Select[indexPath.row] {
                cell.bottom_View.backgroundColor = .white
            }else {
                cell.bottom_View.backgroundColor = MainSub_Color
            }
            dataSource[indexPath.section].is_Select[indexPath.row] = !dataSource[indexPath.section].is_Select[indexPath.row]
            let is_Select = dataSource.flatMap { (data) -> [Bool] in
                return data.is_Select.filter({$0})
            }
            select_label.text = "已選擇\(is_Select.count)個"
            tableView.reloadData()
        }
    }
}
