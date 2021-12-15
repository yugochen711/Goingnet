//
//  BaseVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift
import JGProgressHUD
import SDWebImage
import GRDB

let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height
let User_Defaults = UserDefaults.standard
let Ios_version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let Bundle_version = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let SPACE = "  "
let StatusBarFrameH = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height
let StatusBottomFrameH = UIApplication.shared.windows[0].safeAreaInsets.bottom

let Main_Color = #colorLiteral(red: 0.03921568627, green: 0.5333333333, blue: 0.2784313725, alpha: 1)
let MainSub_Color = #colorLiteral(red: 0.8745098039, green: 0.9568627451, blue: 0.9137254902, alpha: 1)
let Sub_Color = #colorLiteral(red: 0.4196078431, green: 0.7019607843, blue: 0.9098039216, alpha: 1)
let Red_Color = #colorLiteral(red: 0.9058823529, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
let Gary_Color = #colorLiteral(red: 0.8117647059, green: 0.8117647059, blue: 0.8117647059, alpha: 1)
let TextGary_Color = #colorLiteral(red: 0.5137254902, green: 0.5137254902, blue: 0.5137254902, alpha: 1)
let Cell_Color = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
let GaryLine_Color = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
let Blue_Color = #colorLiteral(red: 0.03921568627, green: 0.4431372549, blue: 0.5333333333, alpha: 1)
let FalseGary_Color = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)

let Main_Storyboard = UIStoryboard(name: "Main", bundle: nil)
let AllExamine_Storyboard = UIStoryboard(name: "AllExamine", bundle: nil)
let Maintain_Storyboard = UIStoryboard(name: "Maintain", bundle: nil)
let Project_Storyboard = UIStoryboard(name: "Project", bundle: nil)
let IOSdb_path = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/IosGoingnet.sqlite"

let Headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
let Headers_html: HTTPHeaders = ["Accept":"text/html"]
let DOMIN = "https://anbon.works/goingnet/app/"//測試
let Version = "\(Ios_version)(\(Bundle_version))"//測試
//let DOMIN = ""//正式
//let Version = "\(Ios_version)"//正式

let Img_upload_without_crop_URL = DOMIN + "api/img_upload_without_crop"//圖片上傳(原始圖 input type=file)
let Login_URL = DOMIN + "api/login"//1.登入
let Test_upload_URL = DOMIN + "api/test_upload"//2.總檢上傳
let Get_fixed_list_URL = DOMIN + "api/get_fixed_list"//3.取得後台給的固定選單
let Maintain_upload_URL = DOMIN + "api/maintain_upload"//4.保養工程上傳
let Engineer_upload_URL = DOMIN + "api/engineer_upload"//5.工程專案上傳

let Hint_Select_msg = "您未完成選擇項目，請填寫社區、棟別、系統"
let Hint_Select1_msg = "您未完成選擇項目，請填寫社區、保養日期、保養名稱"
let Hint_Photo_msg = "請拍攝或選擇照片"
let Hint_Was_msg = "請填寫缺失說明"
let Hint_Delete_msg = "確定刪除此筆資料?"
let Hint_DeleteSuccess_msg = "刪除成功"

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func onSlideMenuButtonPressed() {
        let menuVC: MenuVC = Main_Storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
                if let view = homeTBC.view.viewWithTag(99999) {
                    view.removeFromSuperview()
                }else {
                    let garyView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
                    garyView.tag = 99999
                    garyView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                    homeTBC.view.addSubview(garyView)
                }
            }
            if let menuHomeVC = appdelegate.window?.rootViewController?.topMostVC() as? MenuHomeVC {
                menuVC.currentTitle = menuHomeVC.navigationItem.title ?? ""
            }
        }
        menuVC.view.backgroundColor = .clear
        menuVC.delegate = self
        UIApplication.shared.windows[0].addSubview(menuVC.view)
        
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width,
                                   y: 0,
                                   width: UIScreen.main.bounds.size.width,
                                   height: UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: UIScreen.main.bounds.size.width,
                                       height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    ///上傳總檢資料單筆
    func uploadAll_test(callAPI: Bool, data: DB_dataSource, vc: UIViewController) {
        if callAPI {
            if let img = data.img, let images = self.unarchiveData(img: img) {
                if images.count > 0 {
                    var path = ""
                    let group: DispatchGroup = DispatchGroup()
                    group.enter()
                    self.api_UploadSingle(url: Img_upload_without_crop_URL, showHud: false, imageKey: "pics", imageValue: images[0].sd_imageData() ?? Data(), headers: Headers) { (response, error) in
                        let json = JSON(response as Any)
                        print("圖片上傳(原始圖 input type=file) = \(json)")
                        if json["status"].boolValue && json["data"].count > 0 {
                            path = json["data"][0].stringValue
                        }
                        group.leave()
                    }
                    group.notify(queue: DispatchQueue.main) {
                        print("path = \(path)")
                        let value = ["group_id": data.group_id,
                                     "group_name": data.name,
                                     "project_id": data.item_id,
                                     "position": data.position,
                                     "building": data.building,
                                     "system": data.system,
                                     "floor": data.floor,
                                     "instruction1": data.instruction1,
                                     "instruction2": data.instruction2,
                                     "instruction3": data.instruction3,
                                     "img": path]
                        let parameters = ["token": User_Defaults.string(forKey: "login_token") ?? "",
                                          "data": JSON([value])] as [String : Any]
                        print("parameters = \(parameters)")
                        self.api_request(url: Test_upload_URL, showHud: true, parameters: parameters as [String : AnyObject], headers: Headers) { (response, error) in
                            if let _ = response {
                                self.updateDB(data: data, str: "WHERE group_id = \(data.group_id ?? "") AND item_id = \(data.item_id ?? "")") { (respone, status) in
                                    if status {
                                        if let dataSource = respone, let vc = vc as? AllExamineEditVC {
                                            vc.completionHandler?(dataSource)
                                        }
                                        if let dataSource = respone, let vc = vc as? AllExamineDetailVC {
                                            vc.detailUpdate(data: dataSource)
                                        }
                                        self.topMostVC().alertController(title: "提示", message: "ID:\(data.item_id ?? "") 上傳成功", check: "確定", cancel: "") {
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else {
            self.updateDB(data: data, str: "WHERE group_id = \(data.group_id ?? "") AND item_id = \(data.item_id ?? "")") { (respone, status) in
                if status {
                    if let dataSource = respone, let vc = vc as? AllExamineEditVC {
                        vc.completionHandler?(dataSource)
                        vc.alertController(title: "提示", message: "ID:\(data.item_id ?? "") 上傳成功", check: "確定", cancel: "") {
                            vc.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    ///上傳總檢資料多筆
    func uploadAll_test(data: [DB_dataSource], completionHandler: @escaping (Bool) -> ()) {
        let group: DispatchGroup = DispatchGroup()
        var valueArr = [[String: String?]]()
        for data in data {
            group.enter()
            if let img = data.img, let images = self.unarchiveData(img: img) {
                if images.count > 0 {
                    self.api_UploadSingle(url: Img_upload_without_crop_URL, showHud: false, imageKey: "pics", imageValue: images[0].sd_imageData() ?? Data(), headers: Headers) { (response, error) in
                        let json = JSON(response as Any)
                        print("圖片上傳(原始圖 input type=file) = \(json)")
                        if json["status"].boolValue && json["data"].count > 0 {
                            let value = ["group_id": data.group_id,
                                         "group_name": data.name,
                                         "project_id": data.item_id,
                                         "position": data.position,
                                         "building": data.building,
                                         "system": data.system,
                                         "floor": data.floor,
                                         "instruction1": data.instruction1,
                                         "instruction2": data.instruction2,
                                         "instruction3": data.instruction3,
                                         "img": json["data"][0].stringValue]
                            valueArr.append(value)
                        }
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            let parameters = ["token": User_Defaults.string(forKey: "login_token") ?? "",
                              "data": JSON(valueArr)] as [String : Any]
            print("parameters = \(parameters)")
            self.api_request(url: Test_upload_URL, showHud: true, parameters: parameters as [String : AnyObject], headers: Headers) { (response, error) in
                if let json = response {
                    completionHandler(json["status"].boolValue)
                    self.alertController(title: "", message: json["msg"].stringValue, check: "確定", cancel: "") {
                    }
                }
            }
        }
    }
}
extension BaseVC: SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
                if let view = homeTBC.view.viewWithTag(99999) {
                    view.removeFromSuperview()
                }
            }
            if let menuHomeVC = appdelegate.window?.rootViewController?.topMostVC() as? MenuHomeVC {
                switch index {
                case 0:
                    menuHomeVC.tabBarController?.selectedIndex = 0
                case 1:
                    menuHomeVC.navigationItem.title = "總檢"
                    menuHomeVC.layout(title: "總檢")
                case 2:
                    menuHomeVC.navigationItem.title = "保養"
                    menuHomeVC.layout(title: "保養")
                case 3:
                    menuHomeVC.navigationItem.title = "工程"
                    menuHomeVC.layout(title: "工程")
                default:
                    break
                }
            }
        }
    }
}
//DB格式
extension BaseVC {
    ///寫入DB
    func insertDB(data: DB_dataSource, completionHandler: @escaping (DB_dataSource?, Bool) -> ()) {
        let now: Date = Date()
        // 建立時間格式
        let dateTimeFormat: DateFormatter = DateFormatter()
        dateTimeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateTimeFormat.timeZone = TimeZone(identifier: "Asia/Taipei")!
        // 將當下時間轉換成設定的時間格式
        let dateTimeString: String = dateTimeFormat.string(from: now)
//        var row = [Row]()
//        try dbQueue.read { db in
//            row = try Row.fetchAll(db, sql: "SELECT * FROM schedule WHERE category = '\(category)' AND date = '\(date)'")
//        }
//        print("讀取數量 count = \(row.count)")
        do {
            let dbQueue = try DatabaseQueue(path: IOSdb_path)
            try dbQueue.write { db in
                try db.execute(sql: "INSERT INTO goingnet (type, project_type, name, group_id, maintain_id, project_id, item_id, building, system, floor, position, staircase, quotation, fire, img, before_img, middle_img, after_img, instruction1, instruction2, instruction3, startDate, endDate, upload_status, edit_status, status, nowtime) VALUES (:type, :project_type, :name, :group_id, :maintain_id, :project_id, :item_id, :building, :system, :floor, :position, :staircase, :quotation, :fire, :img, :before_img, :middle_img, :after_img, :instruction1, :instruction2, :instruction3, :startDate, :endDate, :upload_status, :edit_status, :status, :nowtime)",
                               arguments: ["type": data.type,//總檢,保養,工程
                                           "project_type": data.project_type,//一般工程, 消防
                                           "name": data.name,//名稱
                                           "group_id": data.group_id,//社區ID
                                           "maintain_id": data.maintain_id,//保養ID
                                           "project_id": data.project_id,//工程ID
                                           "item_id": data.item_id,//項目ID 社區底下的專案ID project_id
                                           "building": data.building,//棟別
                                           "system": data.system,//系統
                                           "floor": data.floor,//樓層
                                           "position": data.position,//位置
                                           "staircase": data.staircase,//梯間
                                           "quotation": data.quotation,//估價單號
                                           "fire": data.fire,//消防項目
                                           "img": data.img,//圖片
                                           "before_img": data.before_img,//工程前圖片
                                           "middle_img": data.middle_img,//工程中圖片
                                           "after_img": data.after_img,//工程後圖片
                                           "instruction1": data.instruction1,//缺失說明1, 保養說明, 修繕說明
                                           "instruction2": data.instruction2,//缺失說明2
                                           "instruction3": data.instruction3,//缺失說明3
                                           "startDate": data.startDate,//開始日期
                                           "endDate": data.endDate,//結束日期
                                           "upload_status": data.upload_status,//上傳狀態
                                           "edit_status": data.edit_status,//編輯狀態
                                           "status": data.status,//複檢狀態
                                           "nowtime": dateTimeString])
            }
            completionHandler(data, true)
            print("資料表 寫入成功 新增一筆")
        }catch {
            print("資料表 寫入失敗")
            completionHandler(nil, false)
        }
    }
    ///更新DB
    func updateDB(data: DB_dataSource, str: String, completionHandler: @escaping (DB_dataSource?, Bool) -> ()) {
        let now: Date = Date()
        // 建立時間格式
        let dateTimeFormat: DateFormatter = DateFormatter()
        dateTimeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateTimeFormat.timeZone = TimeZone(identifier: "Asia/Taipei")!
        // 將當下時間轉換成設定的時間格式
        let dateTimeString: String = dateTimeFormat.string(from: now)
        do {
            let dbQueue = try DatabaseQueue(path: IOSdb_path)
            try dbQueue.write { db in
                try db.execute(sql:
                                """
                                UPDATE goingnet SET
                                type = :type,
                                project_type = :project_type,
                                name = :name,
                                building = :building,
                                system = :system,
                                floor = :floor,
                                position = :position,
                                staircase = :staircase,
                                quotation = :quotation,
                                fire = :fire,
                                img = :img,
                                before_img = :before_img,
                                middle_img = :middle_img,
                                after_img = :after_img,
                                instruction1 = :instruction1,
                                instruction2 = :instruction2,
                                instruction3 = :instruction3,
                                startDate = :startDate,
                                endDate = :endDate,
                                upload_status = :upload_status,
                                edit_status = :edit_status,
                                status = :status,
                                nowtime = :nowtime \(str)
                                """,
                               arguments: ["type": data.type,
                                           "project_type": data.project_type,
                                           "name": data.name,
                                           "building": data.building,
                                           "system": data.system,
                                           "floor": data.floor,
                                           "position": data.position,
                                           "staircase": data.staircase,
                                           "quotation": data.quotation,
                                           "fire": data.fire,
                                           "img": data.img,
                                           "before_img": data.before_img,
                                           "middle_img": data.middle_img,
                                           "after_img": data.after_img,
                                           "instruction1": data.instruction1,
                                           "instruction2": data.instruction2,
                                           "instruction3": data.instruction3,
                                           "startDate": data.startDate,
                                           "endDate": data.endDate,
                                           "upload_status": data.upload_status,
                                           "edit_status": data.edit_status,
                                           "status": data.status,
                                           "nowtime": dateTimeString])
            }
            completionHandler(data, true)
            print("資料表 更新成功")
        }catch {
            print("資料表 更新失敗")
            completionHandler(nil, false)
        }
    }
    ///讀取DB
    func readDB(str: String, completionHandler: @escaping ([DB_dataSource]?, Bool) -> ()) {
        var data = [DB_dataSource]()
        do {
            let dbQueue = try DatabaseQueue(path: IOSdb_path)
            try dbQueue.read { db in
                let row = try Row.fetchAll(db, sql: str)
                if row.count > 0 {
                    for i in 0..<row.count {
                        data.append(DB_dataSource(type: row[i]["type"] as? String,
                                                  project_type: row[i]["project_type"] as? String,
                                                  name: row[i]["name"] as? String,
                                                  group_id: row[i]["group_id"] as? String,
                                                  maintain_id: row[i]["maintain_id"] as? String,
                                                  project_id: row[i]["project_id"] as? String,
                                                  item_id: row[i]["item_id"] as? String,
                                                  building: row[i]["building"] as? String,
                                                  system: row[i]["system"] as? String,
                                                  floor: row[i]["floor"] as? String,
                                                  position: row[i]["position"] as? String,
                                                  staircase: row[i]["staircase"] as? String,
                                                  quotation: row[i]["quotation"] as? String,
                                                  fire: row[i]["fire"] as? String,
                                                  img: row[i]["img"] as? Data,
                                                  before_img: row[i]["before_img"] as? Data,
                                                  middle_img: row[i]["middle_img"] as? Data,
                                                  after_img: row[i]["after_img"] as? Data,
                                                  instruction1: row[i]["instruction1"] as? String,
                                                  instruction2: row[i]["instruction2"] as? String,
                                                  instruction3: row[i]["instruction3"] as? String,
                                                  startDate: row[i]["startDate"] as? String,
                                                  endDate: row[i]["endDate"] as? String,
                                                  upload_status: row[i]["upload_status"] as Bool,
                                                  edit_status: row[i]["edit_status"] as Bool,
                                                  status: row[i]["status"] as Bool,
                                                  time: row[i]["nowtime"] as? String))
                    }
                }
            }
            completionHandler(data, true)
        }catch {
            print("讀取失敗")
            completionHandler(nil, false)
        }
    }
    ///刪除DB
    func deleteDB(str: String, completionHandler: @escaping (Bool) -> ()) {
        do {
            let dbQueue = try DatabaseQueue(path: IOSdb_path)
            try dbQueue.write { db in
                try db.execute(sql:
                                """
                                \(str)
                                """
                )
            }
            completionHandler(true)
        }catch {
            print("刪除失敗")
            completionHandler(false)
        }
    }
    ///存擋數據
    func archivedData(arr: [Data]) -> Data? {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: arr, requiringSecureCoding: false)
            return encodedData
        }catch {
            return nil
        }
    }
    ///解開數據
    func unarchiveData(img: Data) -> [UIImage]? {
        var arr = [UIImage]()
        do {
            if let decodedArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(img) as? [Data] {
                for img in decodedArray {
                    if let image = UIImage(data: img) {
                        arr.append(image)
                    }
                }
                return arr
            }else {
                return nil
            }
        }catch {
            return nil
        }
    }
}
//api格式
extension BaseVC {
    ///get
    func api_get(url: String, showHud: Bool, headers: HTTPHeaders, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        let hud = JGProgressHUD(style: .dark)
        if showHud {
            hud.show(in: self.view)
        }
        let sessionManger = Session.default
        sessionManger.sessionConfiguration.httpShouldUsePipelining = true
        sessionManger.sessionConfiguration.timeoutIntervalForRequest = 30
        sessionManger.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(value as AnyObject, nil)
                let json = JSON(response.data as Any)
                if !json["status"].boolValue {
                    self.alertController(title: "", message: json["msg"].stringValue, check: "確定", cancel: "") {
                    }
                }
            case .failure(let error):
                completionHandler(nil, error as NSError)
                if error._code == 13 || error._code == -1001 {
                    let alert = UIAlertController(title: "", message: "連線逾時，請檢查網路後重新操作", preferredStyle: .alert)
                    let action = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }else {
                    var error = "error"
                    if DOMIN == "https://anbon.works/goingnet/app/api/" {
                        error = "error -> \(url)"
                    }
                    self.alertController(title: "", message: error, check: "確定", cancel: "") {
                    }
                }
                print("get failure response === \(response.response?.statusCode ?? 0)")
                print("error -> \(url)")
            }
            if showHud {
                hud.dismiss()
            }
            //print("get === \(response)")
        }
    }
    private func api_PostCall(url: String, showHud: Bool, parameters: [String: AnyObject],headers: HTTPHeaders, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let hud = JGProgressHUD(style: .dark)
        if showHud {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let vc = appDelegate.window?.rootViewController?.topMostVC().tabBarController {
                    hud.show(in: vc.view)
                }else {
                    if let view = appDelegate.window?.rootViewController?.topMostVC().view {
                        hud.show(in: view)
                    }
                }
            }
        }
        let sessionManger = Session.default
        sessionManger.sessionConfiguration.httpShouldUsePipelining = true
        sessionManger.sessionConfiguration.timeoutIntervalForRequest = 30
        sessionManger.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                switch key {
                default:
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.data as Any)
                if json["status"].boolValue {
                    print("URL = \(url),\n\(json)")
                    completionHandler(json, nil)
                }else {
                    self.alertController(title: "", message: json["msg"].stringValue, check: "確定", cancel: "") {
                        if let login_auth = json["login_auth"].bool {
                            if !login_auth {
                                if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                                    appdelegate.rootWindow(type: "LoginVC")
                                }
                            }
                        }
                    }
                    print("一般資料 success response === \(response.response?.statusCode ?? 0), url = \(url)")
                }
            case .failure(let error):
                completionHandler(nil, error as NSError)
                if error._code == 13 || error._code == -1001 {
                    let alert = UIAlertController(title: "", message: "連線逾時，請檢查網路後重新操作", preferredStyle: .alert)
                    let action = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }else {
                    var error = "error"
                    if DOMIN == "https://anbon.works/goingnet/app/api/" {
                        error = "error -> \(url)"
                    }
                    self.alertController(title: "", message: error, check: "確定", cancel: "") {
                    }
                }
                print("response failure statusCode = \(response.response?.statusCode ?? 0)")
                print("error -> \(url)")
            }
            if showHud {
                hud.dismiss()
            }
//            print("statusCode = \(response.response?.statusCode ?? 0)")
//            print("response = \(response)")
//            print("response.response = \(response.response)")
//            print("一般資料 str success response === \(response)")
        }
    }
    ///api POST 一般資料
    func api_request(url: String, showHud: Bool, parameters: [String: AnyObject],headers: HTTPHeaders, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        api_PostCall(url: url, showHud: showHud, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    private func upload_Single(url: String, showHud: Bool, imageKey: String, imageValue: Data, headers: HTTPHeaders, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let hud = JGProgressHUD(style: .dark)
        if showHud {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let view = appDelegate.window?.rootViewController?.topMostVC().view {
                    hud.show(in: view)
                }
            }
        }
        let sessionManger = Session.default
        sessionManger.sessionConfiguration.httpShouldUsePipelining = true
        sessionManger.sessionConfiguration.timeoutIntervalForRequest = 30
        sessionManger.upload(multipartFormData: { (multipartFormData) in
            if imageKey == "pics" {
                multipartFormData.append(imageValue, withName: "\(imageKey)[]", fileName: "\(imageKey).png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.data as Any)
                if json["status"].boolValue {
                    completionHandler(json, nil)
                }else {
                    self.alertController(title: "", message: json["msg"].stringValue, check: "確定", cancel: "") {
                    }
                }
            case .failure(let error):
                completionHandler(nil, error as NSError)
                if error._code == 13 || error._code == -1001 {
                    let alert = UIAlertController(title: "", message: "連線逾時，請檢查網路後重新操作", preferredStyle: .alert)
                    let action = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }else {
                    var error = "error"
                    if DOMIN == "https://anbon.works/kihsiao/" {
                        error = "error -> \(url)"
                    }
                    self.alertController(title: "", message: error, check: "確定", cancel: "") {
                    }
                }
            }
            hud.dismiss()
            print("單張照片＋參數 failure response === \(response.response?.statusCode ?? 0)")
        }
    }
    ///post 圖片上傳＋參數（取得path）
    func api_UploadSingle(url: String, showHud: Bool, imageKey: String, imageValue: Data, headers: HTTPHeaders, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        upload_Single(url: url, showHud: showHud, imageKey: imageKey, imageValue: imageValue, headers: headers, completionHandler: completionHandler)
    }
    private func api_TestPostCall(url: String, parameters: [String: AnyObject],headers: HTTPHeaders, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        let sessionManger = Session.default
        sessionManger.sessionConfiguration.httpShouldUsePipelining = true
        sessionManger.sessionConfiguration.timeoutIntervalForRequest = 30
        sessionManger.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                switch key {
                default:
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).responseString { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.data as Any)
                if json["status"].boolValue {
                    completionHandler(json, nil)
                }else {
                    self.alertController(title: "", message: json["msg"].stringValue, check: "確定", cancel: "") {
                    }
                }
            case .failure(let error):
                completionHandler(nil, error as NSError)
                self.alertController(title: "", message: "error->\(url)", check: "確定", cancel: "") {
                }
            }
            hud.dismiss()
            print("一般資料 str success response === \(response)")
        }
    }
    //api POST 一般資料 debug 顯示String用
    func api_TestRequest(url: String, showHud: Bool, parameters: [String: AnyObject], headers: HTTPHeaders, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        api_TestPostCall(url: url, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
}
