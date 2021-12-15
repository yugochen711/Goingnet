//
//  UIViewController+Extension.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import Foundation
import UIKit

extension UIViewController {
    func topMostVC() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostVC()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostVC() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostVC() ?? tab
        }
        
        return self
    }

    func alertController(title: String, message: String, check: String, cancel: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = Main_Color
        let action = UIAlertAction(title: check, style: .default) { (alert) in
            completion()
        }
        if cancel != "" {
            let cancelAction = UIAlertAction(title: cancel, style: .default, handler: nil)
            alert.addAction(cancelAction)
        }
        if check != "" {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostVC()
    }
}
