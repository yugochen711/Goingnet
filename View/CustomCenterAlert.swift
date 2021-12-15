//
//  CustomCenterAlert.swift
//  KIHSIOA
//
//  Created by 陳冠宇 on 2021/9/10.
//

import Foundation
import UIKit

class CustomCenterAlert {
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.5
    }
    
    let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return backgroundView
    }()
    
    let alertView: UIView = {
        let alert = UIView()
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.backgroundColor = .white
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var customTargetView: UIView?
    private var statusBarFrame_h: CGFloat = 0
    private var statusBottomFrameH_h: CGFloat = StatusBottomFrameH
    
    func showAlert(vc: UITabBarController, y: CGFloat, w: CGFloat, h: CGFloat) {
        guard let targetView = vc.view else {
            return
        }

        customTargetView = targetView
        self.statusBarFrame_h = StatusBarFrameH ?? 0
        
        backgroundView.frame = targetView.bounds
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTapAlert(_:))))
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        alertView.centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
        alertView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: w).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: h).isActive = true
    }
    func showVCAlert(vc: UIViewController, y: CGFloat, w: CGFloat, h: CGFloat) {
        guard let targetView = vc.view else {
            return
        }

        customTargetView = targetView
        self.statusBarFrame_h = StatusBarFrameH ?? 0
        
        backgroundView.frame = targetView.bounds
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTapAlert(_:))))
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        alertView.centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
        alertView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: w).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: h).isActive = true
    }
    
    @objc func dismissAlert() {
        guard customTargetView != nil else {
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.alpha = 0
            self.backgroundView.alpha = 0
        }) { (done) in
            self.alertView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }
    @objc func dismissTapAlert(_ sender: UITapGestureRecognizer) {
        dismissAlert()
    }
}
