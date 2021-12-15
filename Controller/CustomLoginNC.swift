//
//  CustomLoginNC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit

class CustomLoginNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = textAttributes
        self.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem?.title = ""
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = Main_Color
        self.delegate = self
    }
}
extension CustomLoginNC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
