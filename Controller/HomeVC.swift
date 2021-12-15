//
//  HomeVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit
import Photos

class HomeVC: UIViewController {

    @IBOutlet var bottom_View: [UIView]!
    @IBOutlet var photo_imgView: [UIImageView]!
    @IBOutlet var check_Btn: [UIButton]!
    @IBOutlet weak var name_label: UILabel!
    
    var imgArr = ["Frame15", "Frame16", "Frame17"]
    var btnArr = ["總檢", "保養", "工程"]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        self.title = "國霖電機"
        let rightFirstBtn = UIButton(type: UIButton.ButtonType.system)
        rightFirstBtn.addTarget(self, action: #selector(logoutButton(_:)), for: .touchUpInside)
        rightFirstBtn.setTitle("登出", for: .normal)
        let rightFirstItem = UIBarButtonItem(customView: rightFirstBtn)
        navigationItem.rightBarButtonItem = rightFirstItem
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        name_label.text = "\(User_Defaults.string(forKey: "User_name") ?? "") 您好："
        for view in bottom_View {
            view.layer.cornerRadius = 14
            view.backgroundColor = Main_Color
            view.layer.shadowRadius = 2
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowOpacity = 0.4
            view.layer.backgroundColor = Main_Color.cgColor
        }
        for index in 0..<photo_imgView.count {
            photo_imgView[index].image = UIImage(named: imgArr[index])
        }
        for index in 0..<check_Btn.count {
            check_Btn[index].setTitle(btnArr[index], for: .normal)
            check_Btn[index].setTitleColor(.white, for: .normal)
            check_Btn[index].titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }

    @IBAction func checkButton(_ sender: UIButton) {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
                homeTBC.selectedIndex = 1
                if let menuHomeVC = appdelegate.window?.rootViewController?.topMostVC() as? MenuHomeVC {
                    menuHomeVC.navigationItem.title = sender.currentTitle ?? ""
                    menuHomeVC.layout(title: sender.currentTitle ?? "")
                }
            }
        }
    }
    @objc private func logoutButton(_ sender: UIButton) {
        self.alertController(title: "", message: "確定登出？", check: "確定", cancel: "取消") {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                User_Defaults.removeObject(forKey: "login_token")
                appDelegate.rootWindow(type: "LoginVC")
            }
        }
    }
}
