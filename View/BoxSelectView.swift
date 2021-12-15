//
//  BoxSelectView.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit
import SwiftyJSON

class BoxSelectView: UIView {

    @IBOutlet weak var tableView: UITableView!
    let nibName = "BoxSelectView"
    var dataSource = [FixedDataSource(id: "", content: "請選擇", select_status: false)]
    var fixed_type = "" {
        didSet {
            print("1.fixed_type = \(fixed_type)")
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
            case "building", "floor", "staircase":
                if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                    if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
                        processSubviews(of: homeTBC.topMostVC().view, type: fixed_type)
                    }
                }
            case "system", "fix", "fire":
                if let data = User_Defaults.value(forKey: "User_\(fixed_type)") {
                    let json = JSON(data)
                    for index in 0..<json.count {
                        dataSource.append(FixedDataSource(id: "",
                                                          content: json[index]["content"].stringValue,
                                                          select_status: false))
                    }
                }
            default:
                break
            }
            self.tableView.reloadData()
        }
    }
    var group_id = "" {
        didSet {
            print("2.fixed_type = \(fixed_type), group_id = \(self.group_id)")
            switch fixed_type {
            case "building":
                if let data = User_Defaults.value(forKey: "User_group") {
                    let json = JSON(data)
                    for i in 0..<json.count {
                        if group_id == json[i]["id"].stringValue {
                            for j in 0..<json[i]["building"].count {
                                dataSource.append(FixedDataSource(id: json[i]["id"].stringValue,
                                                                  content: json[i]["building"][j]["build"].stringValue,
                                                                  select_status: false))
                            }
                        }
                    }
                }
            default:
                break
            }
            self.tableView.reloadData()
        }
    }
    var building_id = "" {
        didSet {
            print("3.fixed_type = \(fixed_type), group_id = \(self.group_id), building_id = \(building_id)")
            switch fixed_type {
            case "floor":
                if let data = User_Defaults.value(forKey: "User_group") {
                    let json = JSON(data)
                    for i in 0..<json.count {
                        if group_id == json[i]["id"].stringValue {
                            for j in 0..<json[i]["building"].count {
                                if building_id == json[i]["building"][j]["build"].stringValue {
                                    for k in 0..<json[i]["building"][j]["floor"].count {
                                        dataSource.append(FixedDataSource(id: json[i]["id"].stringValue,
                                                                          content: json[i]["building"][j]["floor"][k].stringValue,
                                                                          select_status: false))
                                    }
                                }
                            }
                        }
                    }
                }
            case "staircase":
                if let data = User_Defaults.value(forKey: "User_group") {
                    let json = JSON(data)
                    for i in 0..<json.count {
                        if group_id == json[i]["id"].stringValue {
                            for j in 0..<json[i]["building"].count {
                                if building_id == json[i]["building"][j]["build"].stringValue {
                                    for k in 0..<json[i]["building"][j]["stairs"].count {
                                        dataSource.append(FixedDataSource(id: json[i]["id"].stringValue,
                                                                          content: json[i]["building"][j]["stairs"][k].stringValue,
                                                                          select_status: false))
                                    }
                                }
                            }
                        }
                    }
                }
            default:
                break
            }
            self.tableView.reloadData()
        }
    }
    var completionHandler: ((FixedDataSource)->())?

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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    ///取得所有view物件
    private func processSubviews(of view: UIView, type: String) {
        // 1. code here do something with view
        for subview in view.subviews {
            // 2. code here do something with subview
            processSubviews(of: subview, type: type)
            // 3. code here do something with subview
            if let v = subview as? InputTextFieldPickerView {
                switch type {
                case "building":
                    if v.fixed_type == "name" {
                        self.group_id = v.group_id
                    }
                case "floor", "staircase":
                    if v.fixed_type == "building" {
                        self.group_id = v.group_id
                        self.building_id = v.input_textField.text ?? ""
                    }
                default:
                    break
                }
            }
        }
    }
}
extension BoxSelectView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BoxSelectCell
        cell?.selectionStyle = .none
        if indexPath.row == 0 {
            cell?.photo_imgView.isHidden = true
        }else {
            cell?.photo_imgView.isHidden = false
        }
        cell?.photo_imgView.image = dataSource[indexPath.row].select_status ? UIImage(named: "Ellipse79"): UIImage(named: "Ellipse78")
        cell?.title_label.text = dataSource[indexPath.row].content ?? ""
        return cell!
    }
}
extension BoxSelectView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<dataSource.count {
            dataSource[index].select_status = false
        }
        dataSource[indexPath.row].select_status = true
        tableView.reloadData()
        completionHandler?(dataSource[indexPath.row])
    }
}
