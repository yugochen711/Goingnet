//
//  ProjectVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit
import IQKeyboardManagerSwift

class ProjectVC: BaseVC {
    
    @IBOutlet weak var search_Bar: UISearchBar!
    @IBOutlet weak var topBar_View: TopBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var add_Btn: MainButton!
    
    var customCenterAlert: CustomCenterAlert? = nil
    var customAlert: CustomAlert? = nil
    var dataSource = [MaintainDataSource]()
    var searchDataSource = [MaintainDataSource]()
    var upload = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProjectVC")
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readDB(upload: upload)
    }
    private func layout() {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if let menuHomeVC = appdelegate.window?.rootViewController?.topMostVC() as? MenuHomeVC {
                let leftFirstBtn = UIButton(type: UIButton.ButtonType.system)
                leftFirstBtn.addTarget(menuHomeVC, action: #selector(MenuHomeVC.menuButton(_:)), for: .touchUpInside)
                leftFirstBtn.setTitle("", for: .normal)
                leftFirstBtn.setImage(UIImage(named: "Frame14"), for: .normal)
                let leftFirstItem = UIBarButtonItem(customView: leftFirstBtn)
                menuHomeVC.navigationItem.leftBarButtonItem = leftFirstItem
                
                let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
                rightFirstBtn.addTarget(self, action: #selector(detailButton(_:)), for: .touchUpInside)
                rightFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8.0)
                rightFirstBtn.setTitle("● ● ●", for: .normal)
                rightFirstBtn.setTitleColor(.white, for: .normal)
                let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
                menuHomeVC.navigationItem.rightBarButtonItem = rightFirstItem
            }
        }
        topBar_View.topBarViewDelegate = self
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
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func readDB(upload: String) {
        var dataSource = [MaintainDataSource]()
        self.readDB(str: "SELECT * FROM goingnet WHERE type = '工程' AND upload_status = '\(upload)'") { (respone, err) in
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
                    let arr = dataSource.filter({$0.title == unique[index].startDate ?? ""})
                    if arr.count == 0 {
                        //未上傳筆數
                        let noUpload = data.filter({$0.upload_status == false && $0.name == unique[index].name && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id})
                        //總共筆數
                        let allCount = data.filter({$0.name == unique[index].name ?? "" && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id})
                        dataSource.append(MaintainDataSource(title: unique[index].startDate ?? "",
                                                             data: [unique[index]],
                                                             noUpload: [noUpload.count],
                                                             allCount: [allCount.count],
                                                             is_Select: [false]))
                    }else {
                        var otherData = [DB_dataSource]()
                        for i in 0..<arr[0].data.count {
                            otherData.append(arr[0].data[i])
                        }
                        otherData.append(unique[index])
                        if let i = dataSource.firstIndex(where: {$0.title == unique[index].startDate ?? ""}) {
                            var noUpload = dataSource[i].noUpload
                            noUpload.append(data.filter({$0.upload_status == false && $0.name == unique[index].name ?? "" && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id}).count)
                            var allCount = dataSource[i].allCount
                            allCount.append(data.filter({$0.name == unique[index].name ?? "" && $0.startDate == unique[index].startDate && $0.maintain_id == unique[index].maintain_id}).count)
                            dataSource[i] = MaintainDataSource(title: unique[index].startDate ?? "",
                                                               data: otherData,
                                                               noUpload: noUpload,
                                                               allCount: allCount,
                                                               is_Select: [false])
                        }
                    }
                }
                self.dataSource = dataSource
                self.searchDataSource = self.dataSource
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func detailTopButton(_ sender: UIButton) {
        customAlert?.dismissAlert()
        switch sender.currentTitle {
        case "上傳", "刪除":
            break
        default:
            break
        }
    }
    @objc private func detailListButton(_ sender: UIButton) {
        customAlert?.dismissAlert()
        if let section = sender.superview?.tag,
           let group_id = dataSource[section].data[sender.tag].group_id,
           let startDate = dataSource[section].data[sender.tag].startDate,
           let endDate = dataSource[section].data[sender.tag].endDate,
           let name = dataSource[section].data[sender.tag].name,
           let maintain_id = dataSource[section].data[sender.tag].maintain_id  {
            switch sender.currentTitle {
            case "新增":
//                let maintainSecondAddVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainSecondAddVC") as! MaintainSecondAddVC
//                self.readDB(str: "SELECT * FROM goingnet WHERE group_id = '\(group_id)' AND type = '保養' AND startDate = '\(startDate)' AND maintain_id = '\(maintain_id)'") { (respone, err) in
//                    let count = respone?.count ?? 0
//                    maintainSecondAddVC.item_id = "\(count + 1)"
//                }
//                maintainSecondAddVC.group_id = group_id
//                maintainSecondAddVC.maintain_id = maintain_id
//                maintainSecondAddVC.start_date = startDate
//                maintainSecondAddVC.end_date = endDate
//                maintainSecondAddVC.name = name
//                self.navigationController?.pushViewController(maintainSecondAddVC, animated: true)
                break
            case "上傳":
                break
            case "修改":
//                let maintainFirstAddVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainFirstAddVC") as! MaintainFirstAddVC
//                let nameArr = name.split(separator: "-")
//                if nameArr.count > 1 {
//                    maintainFirstAddVC.contentArr[0] = "\(nameArr[0])"
//                    maintainFirstAddVC.contentArr[3] = "\(nameArr[1])"
//                }
//                maintainFirstAddVC.contentArr[1] = startDate
//                maintainFirstAddVC.contentArr[2] = endDate
//                maintainFirstAddVC.group_id = group_id
//                self.navigationController?.pushViewController(maintainFirstAddVC, animated: true)
                break
            case "刪除":
                break
            default:
                break
            }
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
                    btn.addTarget(self, action: #selector(detailTopButton(_:)), for: .touchUpInside)
                }
            }
        }
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let tabbarC = self.tabBarController,
           let index = sender.view?.tag,
           let section = sender.view?.superview?.superview?.superview?.tag {
            let rect = self.view.convert(sender.location(in: self.view), to: self.view)
            self.customAlert = CustomAlert()
            self.customAlert?.showLeftAlert(vc: tabbarC, item: ["新增","上傳","修改","刪除"], x: WIDTH-120, y: abs(rect.y) + 70)
            
            if let stackMainView = self.customAlert?.stackMainView {
                for view in stackMainView.arrangedSubviews {
                    if let btn = view as? UIButton {
                        btn.superview?.tag = section
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
        if let tabbarC = self.tabBarController {
            customCenterAlert = CustomCenterAlert()
            customCenterAlert?.showVCAlert(vc: tabbarC, y: self.view.frame.origin.y, w: 300, h: 220)
            let addEventView = AddEventView(frame: CGRect(x: 0, y: 0, width: 300, height: 220))
            addEventView.layer.cornerRadius = 12
            if let alertView = customCenterAlert?.alertView {
                addEventView.close_Btn.addTarget(self, action: #selector(closeButton(_:)), for: .touchUpInside)
                addEventView.addGenerally_Btn.addTarget(self, action: #selector(addEventButton(_:)), for: .touchUpInside)
                addEventView.addOther_Btn.addTarget(self, action: #selector(addEventButton(_:)), for: .touchUpInside)
                alertView.addSubview(addEventView)
            }
        }
    }
}
extension ProjectVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        add_Btn.alpha = 100 - currentOffset
    }
}
extension ProjectVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchDataSource = self.dataSource
        }else { // 匹配用户输入内容的前缀(不区分大小写)
            self.searchDataSource = [MaintainDataSource]()
            for data in self.dataSource {
                for second_data in data.data {
                    if let content = second_data.name {
                        if content.lowercased().contains(searchText.lowercased()) {
                            self.searchDataSource.append(data)
                        }
                    }
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
extension ProjectVC: TopBarViewDelegate {
    func selectType(type: String) {
        upload = type
        readDB(upload: upload)
    }
}
extension ProjectVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataSource[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CategoryCell
        cell?.selectionStyle = .none
        cell?.contentView.tag = indexPath.section
        cell?.status_Btn.isHidden = true
        cell?.title_label.text = searchDataSource[indexPath.section].data[indexPath.row].name ?? ""
        cell?.upload_label.text = "未上傳 : \(searchDataSource[indexPath.section].noUpload[indexPath.row])"
        cell?.start_label.text = "工程開始 : \(searchDataSource[indexPath.section].data[indexPath.row].startDate ?? "")"
        cell?.end_label.text = "工程結束 : \(searchDataSource[indexPath.section].data[indexPath.row].endDate ?? "")"
        cell?.total_label.text = "總筆數 : \(searchDataSource[indexPath.section].allCount[indexPath.row])"
        cell?.detail_Btn.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cell?.detail_Btn.addGestureRecognizer(tap)
        return cell!
    }
}
extension ProjectVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title_label = EdgeInsetLabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        title_label.textInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        title_label.font = UIFont.boldSystemFont(ofSize: 20)
        title_label.textColor = Main_Color
        let nowAndyesterday = Date().nowAndyesterday()
        if nowAndyesterday.now == searchDataSource[section].title {
            title_label.text = "今天"
        }else if nowAndyesterday.yesterday == searchDataSource[section].title {
            title_label.text = "昨天"
        }else {
            title_label.text = searchDataSource[section].title
        }
        
        return title_label
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySecondVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "CategorySecondVC") as! CategorySecondVC
        categorySecondVC.pageType = "Project"
        self.navigationController?.pushViewController(categorySecondVC, animated: true)
    }
}
