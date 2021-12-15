//
//  MenuVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuVC: UIViewController {
    
    @IBOutlet var tblMenuOptions : UITableView!
    @IBOutlet var close_Btn : UIButton!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet var topBottom_View: [UIView]!
    
    var arrayMenuOptions = [Dictionary<String,String>]()
    var currentTitle = ""
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in topBottom_View {
            view.backgroundColor = Main_Color
        }
        title_label.text = "選單"
        title_label.textColor = .white
        close_Btn.setTitle("", for: .normal)
        close_Btn.tintColor = .white
        close_Btn.setImage(UIImage(named: "Group267"), for: .normal)
        
        tblMenuOptions.tableFooterView = UIView()
        tblMenuOptions.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tblMenuOptions.backgroundColor = .white
        tblMenuOptions.dataSource = self
        tblMenuOptions.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    private func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title": "首頁", "icon": currentTitle == "首頁" ? "Frame42": "Frame42"])
        arrayMenuOptions.append(["title": "總檢", "icon": currentTitle == "總檢" ? "Frame38": "Frame34"])
        arrayMenuOptions.append(["title": "保養", "icon": currentTitle == "保養" ? "Frame39": "Frame35"])
        arrayMenuOptions.append(["title": "工程", "icon": currentTitle == "工程" ? "Frame37": "Frame36"])
        
        tblMenuOptions.reloadData()
    }
    private func onCloseMenuClick(_ button: UIButton!) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width,
                                     height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                if (self.delegate != nil) {
                    self.delegate?.slideMenuItemSelectedAtIndex(Int32(button.tag))
                }
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    @IBAction func closeButton(_ sender: UIButton) {
        sender.tag = -1
        onCloseMenuClick(sender)
    }
    @IBAction func logoutButton(_ sender: UIButton) {
        self.alertController(title: "", message: "確定登出？", check: "確定", cancel: "取消") {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                User_Defaults.removeObject(forKey: "login_token")
                appDelegate.rootWindow(type: "LoginVC")
            }
        }
    }
}
extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        if let lblTitle : UILabel = cell.contentView.viewWithTag(101) as? UILabel {
            lblTitle.textColor = currentTitle == arrayMenuOptions[indexPath.row]["title"] ? Main_Color: TextGary_Color
            lblTitle.text = arrayMenuOptions[indexPath.row]["title"]
        }
        if let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as? UIImageView {
            imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"] ?? "")
            imgIcon.contentMode = .center
        }

        return cell
    }
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        onCloseMenuClick(btn)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
