//
//  AppDelegate.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if User_Defaults.string(forKey: "login_token") ?? "" != "" {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.rootWindow(type: "HomeTBC")
            }
        }
        
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
//        getVersion()
    }
    private func rootWindow(root: UIViewController) {
        print("root = \(root)")
        let transition = CATransition()
        transition.delegate = self as? CAAnimationDelegate
        transition.duration = 0.5
        transition.type = .fade
        self.window?.layer.add(transition, forKey: "MAIN")
        self.window?.rootViewController = root
    }
    func rootWindow(type: String) {
        switch type {
        case "HomeTBC":
            let homeTBC = Main_Storyboard.instantiateViewController(withIdentifier: "HomeTBC") as! HomeTBC
            rootWindow(root: homeTBC)
        case "LoginVC":
            let loginVC = Main_Storyboard.instantiateViewController(withIdentifier: "CustomLoginNC") as! CustomLoginNC
            rootWindow(root: loginVC)
        default:
            break
        }
    }
//    private func getVersion() {
//        //取得後台給的固定選單
//        let baseVC = BaseVC()
//        baseVC.api_get(url: Get_fixed_list_URL, showHud: false, headers: Headers) { (response, error) in
//            let json = JSON(response as Any)
//            if json["status"].boolValue {
//                print("取得後台給的固定選單 = \(json)")
//                User_Defaults.setValue(json["group"].object, forKey: "User_group")//社區選單跟該社區資訊
//                User_Defaults.setValue(json["position"].object, forKey: "User_position")//位置選單
//                User_Defaults.setValue(json["system"].object, forKey: "User_system")//系統選單
//                User_Defaults.setValue(json["maintain"].object, forKey: "User_maintain")////保養說明
//                User_Defaults.setValue(json["fix"].object, forKey: "User_fix")//一般工程修繕說明
//                User_Defaults.setValue(json["fire"].object, forKey: "User_fire")//消防項目
//                User_Defaults.setValue(json["quotation_fire"].object, forKey: "User_quotation_fire")//消防工程估價單
//                User_Defaults.setValue(json["quotation_nomal"].object, forKey: "User_quotation_nomal")//一般工程估價單
//            }
//        }
//    }
}

