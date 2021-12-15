//
//  CategorySecondVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/17.
//

import UIKit
import IQKeyboardManagerSwift

class CategorySecondVC: BaseVC {
    
    @IBOutlet weak var search_Bar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var add_Btn: MainButton!
    
    var dataSource = [DB_dataSource]()
    var searchDataSource = [DB_dataSource]()
    var customCenterAlert: CustomCenterAlert? = nil
    var customAlert: CustomAlert? = nil
    var pageType = ""
    var name = ""
    var group_id = ""
    var maintain_id = ""
    var startDate = ""
    var endDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readDB(str: "SELECT * FROM goingnet WHERE type = '\(pageType == "Maintain" ? "保養": "")' AND name = '\(name)' AND maintain_id = '\(maintain_id)' AND startDate = '\(startDate)'") { (respone, err) in
            if let data = respone {
                self.dataSource = data
                self.searchDataSource = self.dataSource
                self.tableView.reloadData()
            }
        }
    }
    private func layout() {
        self.title = name
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(detailButton(_:)), for: .touchUpInside)
        rightFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8.0)
        rightFirstBtn.setTitle("● ● ●", for: .normal)
        rightFirstBtn.setTitleColor(.white, for: .normal)
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        self.navigationItem.rightBarButtonItem = rightFirstItem
        
        search_Bar.backgroundImage = UIImage()
        search_Bar.layer.cornerRadius = 5
        search_Bar.layer.borderWidth = 1
        search_Bar.layer.borderColor = GaryLine_Color.cgColor
        search_Bar.placeholder = "搜尋"
        search_Bar.setTextField(color: .white)
        search_Bar.delegate = self
        
        add_Btn.setTitle("", for: .normal)
        add_Btn.tintColor = .white
        add_Btn.layer.cornerRadius = 22.5
        add_Btn.setImage(UIImage(named: "Group1"), for: .normal)
        let nib = UINib(nibName: "CategorySecondCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func detailListButton(_ sender: UIButton) {
        customAlert?.dismissAlert()
        switch (sender.currentTitle, self.pageType) {
        case ("上傳", ""):
            break
        case ("修改", "Maintain"):
            let maintainSecondAddVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainSecondAddVC") as! MaintainSecondAddVC
            maintainSecondAddVC.item_id = dataSource[sender.tag].item_id ?? ""
            maintainSecondAddVC.maintain_id = dataSource[sender.tag].maintain_id ?? ""
            maintainSecondAddVC.group_id = dataSource[sender.tag].group_id ?? ""
            maintainSecondAddVC.start_date = dataSource[sender.tag].startDate ?? ""
            maintainSecondAddVC.end_date = dataSource[sender.tag].endDate ?? ""
            maintainSecondAddVC.name = dataSource[sender.tag].name ?? ""
            maintainSecondAddVC.pageType = "Edit"
            self.navigationController?.pushViewController(maintainSecondAddVC, animated: true)
        case ("匯出", ""):
            break
        case ("刪除", "Maintain"):
            self.alertController(title: "提示", message: Hint_Delete_msg, check: "確定", cancel: "取消") {
                self.deleteDB(str: "DELETE FROM goingnet WHERE group_id = \(self.dataSource[sender.tag].group_id ?? "") AND maintain_id = \(self.dataSource[sender.tag].maintain_id ?? "") AND item_id = \(self.dataSource[sender.tag].item_id ?? "") AND type = '保養'") { (response) in
                    if response {
                        print("刪除 = \(response)")
                    }
                }
                self.dataSource.remove(at: sender.tag)
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
    @objc private func detailButton(_ sender: UIButton) {
        if let tabbarC = self.tabBarController {
            customAlert = CustomAlert()
            customAlert?.showAlert(vc: tabbarC, item: ["上傳","刪除"], y: 40)
        }
        if let stackMainView = customAlert?.stackMainView {
            for view in stackMainView.arrangedSubviews {
                if let btn = view as? UIButton {
                    btn.addTarget(self, action: #selector(detailListButton(_:)), for: .touchUpInside)
                }
            }
        }
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let tabbarC = self.tabBarController, let index = sender.view?.tag {
            let rect = self.view.convert(sender.location(in: self.view), to: self.view)
            self.customAlert = CustomAlert()
            self.customAlert?.showLeftAlert(vc: tabbarC, item: ["上傳","修改","刪除"], x: WIDTH-120, y: abs(rect.y) + 70)
            
            if let stackMainView = self.customAlert?.stackMainView {
                for view in stackMainView.arrangedSubviews {
                    if let btn = view as? UIButton {
                        btn.tag = index
                        btn.addTarget(self, action: #selector(detailListButton(_:)), for: .touchUpInside)
                    }
                }
            }
        }
    }
    @objc private func closeButton(_ sender: UIButton) {
        customCenterAlert?.dismissAlert()
    }
    @objc private func addEventButton(_ sender: UIButton) {
        customCenterAlert?.dismissAlert()
        let projectFirstAddVC = Project_Storyboard.instantiateViewController(withIdentifier: "ProjectFirstAddVC") as! ProjectFirstAddVC
        if sender.currentTitle == "建立一般工程" {
            projectFirstAddVC.name = "一般工程"
        }else {
            projectFirstAddVC.name = "消防工程"
        }
        self.navigationController?.pushViewController(projectFirstAddVC, animated: true)
    }
    @IBAction func addButton(_ sender: UIButton) {
        self.alertController(title: "提示", message: "請問是否繼續新增\n【\(name)】?", check: "確定", cancel: "取消") {
            switch self.pageType {
            case "Maintain":
                let maintainSecondAddVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainSecondAddVC") as! MaintainSecondAddVC
                self.readDB(str: "SELECT * FROM goingnet WHERE group_id = '\(self.group_id)' AND type = '保養' AND startDate = '\(self.startDate)' AND maintain_id = '\(self.maintain_id)'") { (respone, err) in
                    let count = respone?.count ?? 0
                    maintainSecondAddVC.item_id = "\(count + 1)"
                }
                maintainSecondAddVC.group_id = self.group_id
                maintainSecondAddVC.maintain_id = self.maintain_id
                maintainSecondAddVC.start_date = self.startDate
                maintainSecondAddVC.end_date = self.endDate
                maintainSecondAddVC.name = self.name
                self.navigationController?.pushViewController(maintainSecondAddVC, animated: true)
            case "Project":
                if let tabbarC = self.tabBarController {
                    self.customCenterAlert = CustomCenterAlert()
                    self.customCenterAlert?.showVCAlert(vc: tabbarC, y: self.view.frame.origin.y, w: 300, h: 220)
                    let addEventView = AddEventView(frame: CGRect(x: 0, y: 0, width: 300, height: 220))
                    addEventView.layer.cornerRadius = 12
                    if let alertView = self.customCenterAlert?.alertView {
                        addEventView.close_Btn.addTarget(self, action: #selector(self.closeButton(_:)), for: .touchUpInside)
                        addEventView.addGenerally_Btn.addTarget(self, action: #selector(self.addEventButton(_:)), for: .touchUpInside)
                        addEventView.addOther_Btn.addTarget(self, action: #selector(self.addEventButton(_:)), for: .touchUpInside)
                        alertView.addSubview(addEventView)
                    }
                }
            default:
                break
            }
        }
    }
}
extension CategorySecondVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchDataSource = self.dataSource
        }else { // 匹配用户输入内容的前缀(不区分大小写)
            self.searchDataSource = [DB_dataSource]()
            for data in self.dataSource {
                let content = "\(data.building ?? "") \(data.staircase ?? "") \(data.floor ?? "") \(data.position ?? "") (ID:\(data.item_id ?? ""))"
                if content.lowercased().contains(searchText.lowercased()) {
                    self.searchDataSource.append(data)
                }
            }
        }
        // 刷新Table View显示
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        IQKeyboardManager.shared.resignFirstResponder()
    }
}
extension CategorySecondVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CategorySecondCell
        cell?.selectionStyle = .none
        let building = searchDataSource[indexPath.row].building ?? ""
        let staircase = searchDataSource[indexPath.row].staircase ?? ""
        let floor = searchDataSource[indexPath.row].floor ?? ""
        let position = searchDataSource[indexPath.row].position ?? ""
        let item_id = searchDataSource[indexPath.row].item_id ?? ""
        cell?.title_label.text = "\(building) \(staircase) \(floor) \(position) (ID:\(item_id))"
        cell?.contnet_label.text = searchDataSource[indexPath.row].instruction1 ?? ""
        cell?.upload_status = searchDataSource[indexPath.row].upload_status
        cell?.edit_status = searchDataSource[indexPath.row].edit_status
        if let img = self.searchDataSource[indexPath.row].img, let images = self.unarchiveData(img: img) {
            cell?.photoCount = "\(images.count)"
        }
        cell?.photo_imgView.isHidden = true
        cell?.detail_Btn.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cell?.detail_Btn.addGestureRecognizer(tap)
        return cell!
    }
}
extension CategorySecondVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.pageType {
        case "Maintain":
            let maintainDetailVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainDetailVC") as! MaintainDetailVC
            maintainDetailVC.dataSource = searchDataSource[indexPath.row]
            self.navigationController?.pushViewController(maintainDetailVC, animated: true)
        case "Project":
            break
        default:
            break
        }
    }
}
