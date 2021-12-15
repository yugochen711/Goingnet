//
//  SelectView.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class SelectView: UIView {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var search_Bar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let nibName = "SelectView"
    var completionHandler: ((FixedDataSource)->())?
    var dataSource = [FixedDataSource]()
    var searchDataSource = [FixedDataSource]()
    var fixed_type = "" {
        didSet {
            print("fixed_type = \(fixed_type)")
            switch fixed_type {
            case "name":
                if let data = User_Defaults.value(forKey: "User_group") {
                    let json = JSON(data)
                    for index in 0..<json.count {
                        dataSource.append(FixedDataSource(id: json[index]["id"].stringValue,
                                                          content: json[index][fixed_type].stringValue,
                                                          select_status: false))
                    }
                }
            case "position", "maintain", "fix":
                if let data = User_Defaults.value(forKey: "User_\(fixed_type)") {
                    let json = JSON(data)
                    for index in 0..<json.count {
                        dataSource.append(FixedDataSource(id: "",
                                                          content: json[index]["content"].stringValue,
                                                          select_status: false))
                    }
                }
            case "instruction1", "instruction2", "instruction3":
                if let data = User_Defaults.value(forKey: "User_\(fixed_type)") {
                    let json = JSON(data)
                    for index in 0..<json.count {
                        dataSource.append(FixedDataSource(id: "",
                                                          content: json[index][fixed_type].stringValue,
                                                          select_status: false))
                    }
                }
            default:
                break
            }
            self.searchDataSource = dataSource
            self.tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    fileprivate func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        ///透過nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        xibView.backgroundColor = .white
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let box_nib = UINib(nibName: "BoxSelectCell", bundle: nil)
        tableView.register(box_nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        
        search_Bar.delegate = self
    }

}
extension SelectView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchDataSource = self.dataSource
        }else { // 匹配用户输入内容的前缀(不区分大小写)
            self.searchDataSource = [FixedDataSource]()
            for data in self.dataSource {
                if let content = data.content {
                    if content.lowercased().contains(searchText.lowercased()) {
                        self.searchDataSource.append(data)
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
extension SelectView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BoxSelectCell
        cell?.selectionStyle = .none
        cell?.photo_imgView.isHidden = true
        cell?.title_label.text = searchDataSource[indexPath.row].content ?? ""
        cell?.title_label.textColor = TextGary_Color
        
        return cell!
    }
}
extension SelectView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.completionHandler?(searchDataSource[indexPath.row])
    }
}
