//
//  LoginVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit
import SwiftyJSON
import GRDB

class LoginVC: BaseVC {

    @IBOutlet weak var account_View: InputTextFieldView!
    @IBOutlet weak var passWord_View: InputTextFieldView!
    @IBOutlet weak var login_Btn: MainButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "登入"
        account_View.title_label.text = "帳號"
        passWord_View.title_label.text = "密碼"
        passWord_View.input_textField.isSecureTextEntry = true
        
//        account_View.input_textField.text = "6666"
//        passWord_View.input_textField.text = "6666"
        
        login_Btn.setTitle("登入", for: .normal)
        create_NewTable()
        get_fixed_listAPI()
    }
    private func get_fixed_listAPI() {
        //取得後台給的固定選單
        self.api_get(url: Get_fixed_list_URL, showHud: false, headers: Headers) { (response, error) in
            let json = JSON(response as Any)
            if json["status"].boolValue {
                print("取得後台給的固定選單 = \(json)")
                User_Defaults.setValue(json["group"].object, forKey: "User_group")//社區選單跟該社區資訊
                User_Defaults.setValue(json["position"].object, forKey: "User_position")//位置選單
                User_Defaults.setValue(json["system"].object, forKey: "User_system")//系統選單
                User_Defaults.setValue(json["maintain"].object, forKey: "User_maintain")////保養說明
                User_Defaults.setValue(json["fix"].object, forKey: "User_fix")//一般工程修繕說明
                User_Defaults.setValue(json["fire"].object, forKey: "User_fire")//消防項目
                User_Defaults.setValue(json["quotation_fire"].object, forKey: "User_quotation_fire")//消防工程估價單
                User_Defaults.setValue(json["quotation_nomal"].object, forKey: "User_quotation_nomal")//一般工程估價單
                User_Defaults.setValue(json["instruction1"].object, forKey: "User_instruction1")//缺失說明1
                User_Defaults.setValue(json["instruction2"].object, forKey: "User_instruction2")//缺失說明2
                User_Defaults.setValue(json["instruction3"].object, forKey: "User_instruction3")//缺失說明3
            }
        }
    }
    private func create_NewTable() {
        do {
            let dbQueue = try DatabaseQueue(path: IOSdb_path)
            print("IOSdb_path = ", IOSdb_path)
            try dbQueue.write { (db) in
                //建立資料表
                try db.create(table: "goingnet", body: { (t) in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("type", .text)//總檢,保養,工程
                    t.column("project_type", .text)//一般工程, 消防
                    t.column("group_id", .text)//社區ID
                    t.column("maintain_id", .text)//保養ID
                    t.column("project_id", .text)//工程ID
                    t.column("item_id", .text)//項目ID 社區底下的專案ID project_id
                    t.column("name", .text)//名稱
                    t.column("building", .text)//棟別
                    t.column("system", .text)//系統
                    t.column("floor", .text)//樓層
                    t.column("position", .text)//位置
                    t.column("staircase", .text)//梯間
                    t.column("quotation", .text)//估價單號
                    t.column("fire", .text)//消防項目
                    t.column("img", .blob)//圖片
                    t.column("before_img", .blob)//工程前圖片
                    t.column("middle_img", .blob)//工程中圖片
                    t.column("after_img", .blob)//工程後圖片
                    t.column("instruction1", .text)//缺失說明1
                    t.column("instruction2", .text)//缺失說明2
                    t.column("instruction3", .text)//缺失說明3
                    t.column("startDate", .text)//開始日期
                    t.column("endDate", .text)//結束日期
                    t.column("upload_status", .boolean)//上傳狀態
                    t.column("edit_status", .boolean)//編輯狀態
                    t.column("status", .boolean)//複檢狀態
                    t.column("nowtime", .text)//記錄時間
                })
            }
            print("創建成功")
        }catch {
            print("創建失敗")
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let parameters = ["account": account_View.input_textField.text ?? "",
                          "password": passWord_View.input_textField.text ?? ""]
        self.api_request(url: Login_URL, showHud: true, parameters: parameters as [String : AnyObject], headers: Headers) { (response, error) in
            if let json = response {
                User_Defaults.set(json["token"].stringValue, forKey: "login_token")
                User_Defaults.set(json["name"].stringValue, forKey: "User_name")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.rootWindow(type: "HomeTBC")
                }
            }
        }
    }
}
