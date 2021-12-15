//
//  AllExamineVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit

class AllExamineVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var add_Btn: MainButton!
    
    var dataSource = [DB_dataSource]()
    var customAlert: CustomAlert? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readDB(str: "SELECT * FROM goingnet WHERE type = '總檢'") { (respone, err) in
            if let data = respone {
                self.dataSource = data
                self.tableView.reloadData()
            }
        }
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
        
        add_Btn.setTitle("", for: .normal)
        add_Btn.tintColor = .white
        add_Btn.layer.cornerRadius = 22.5
        add_Btn.setImage(UIImage(named: "Group1"), for: .normal)
        let nib = UINib(nibName: "AllExamineCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func detailListButton(_ sender: UIButton) {
        customAlert?.dismissAlert()
        switch sender.currentTitle {
        case "上傳", "刪除":
            let deleteAndUploadVC = AllExamine_Storyboard.instantiateViewController(withIdentifier: "DeleteAndUploadVC") as! DeleteAndUploadVC
            var data = [(DB_dataSource, Bool)]()
            for index in 0..<dataSource.count {
                if sender.currentTitle == "上傳" ? !dataSource[index].upload_status: dataSource[index].upload_status {
                    data.append((dataSource[index], false))
                }
            }
            deleteAndUploadVC.dataSource = data
            deleteAndUploadVC.pageType = sender.currentTitle == "上傳" ? "upload": "delete"
            self.navigationController?.pushViewController(deleteAndUploadVC, animated: true)
        case "匯出":
            break
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
    @IBAction func addButton(_ sender: UIButton) {
        let allExamineFirstAddVC = AllExamine_Storyboard.instantiateViewController(withIdentifier: "AllExamineFirstAddVC") as! AllExamineFirstAddVC
        self.navigationController?.pushViewController(allExamineFirstAddVC, animated: true)
    }
}
extension AllExamineVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        add_Btn.alpha = 100 - currentOffset
//        print("currentOffset = \(currentOffset)")
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        if maximumOffset - currentOffset <= 10.0 {
//            if self.nextPage {
//                self.nextPage = false
//                if self.currentPage < self.total_page {
//                    self.currentPage = self.currentPage + 1
//                    self.chatroom_listAPI(reload: false)
//                }
//            }
//        }
    }
}
extension AllExamineVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AllExamineCell
        cell?.selectionStyle = .none
        if indexPath.row%2 == 0 {
            cell?.contentView.backgroundColor = .white
        }else {
            cell?.contentView.backgroundColor = Cell_Color
        }
        cell?.title_label.text = "\(dataSource[indexPath.row].name ?? "") \(dataSource[indexPath.row].building ?? "") \(dataSource[indexPath.row].system ?? "") (ID:\(dataSource[indexPath.row].item_id ?? ""))"
        cell?.floor_label.text = dataSource[indexPath.row].floor ?? ""
        cell?.location_label.text = dataSource[indexPath.row].position ?? ""
        cell?.info_label.text = "\(dataSource[indexPath.row].instruction1 ?? "")  \(dataSource[indexPath.row].instruction2 ?? "")  \(dataSource[indexPath.row].instruction3 ?? "")"
        cell?.upload_status = dataSource[indexPath.row].upload_status
        cell?.edit_status = dataSource[indexPath.row].edit_status
        cell?.status = dataSource[indexPath.row].status
        return cell!
    }
}
extension AllExamineVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allExamineDetailVC = AllExamine_Storyboard.instantiateViewController(withIdentifier: "AllExamineDetailVC") as! AllExamineDetailVC
        allExamineDetailVC.dataSource = dataSource[indexPath.row]
        self.navigationController?.pushViewController(allExamineDetailVC, animated: true)
    }
}
