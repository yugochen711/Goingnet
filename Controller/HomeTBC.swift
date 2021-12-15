//
//  HomeTBC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit

class HomeTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = Main_Color
        UITabBar.appearance().unselectedItemTintColor = TextGary_Color
        self.tabBar.barTintColor = .white
        self.tabBar.shadowImage = nil
        if let vc = self.viewControllers {
            vc[0].tabBarItem = UITabBarItem.init(title: "首頁", image: UIImage(named: "Frame25"), selectedImage: UIImage(named: "Frame26"))
            vc[1].tabBarItem = UITabBarItem.init(title: "選單", image: UIImage(named: "Frame27"), selectedImage: UIImage(named: "Frame28"))
        }
        self.delegate = self
    }
}
extension HomeTBC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController.topMostVC() as? MenuHomeVC {
            vc.onSlideMenuButtonPressed()
        }
    }
}
