//
//  CustomAlert.swift
//  LingJiouMountain
//
//  Created by 陳冠宇 on 2021/6/7.
//

import Foundation
import UIKit

class CustomAlert {
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.5
    }
    
    let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        return backgroundView
    }()
    
    let alertView: UIView = {
        let alert = UIView()
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.backgroundColor = .white
        return alert
    }()
    
    let stackMainView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    private var customTargetView: UIView?
    private var statusBarFrame_h: CGFloat = 0
    private var statusBottomFrameH_h: CGFloat = StatusBottomFrameH
    
    func showAlert(vc: UITabBarController, item: [String], y: CGFloat) {
        guard let targetView = vc.view else {
            return
        }
        let item_h = CGFloat(item.count * 35)
        
        customTargetView = targetView
        self.statusBarFrame_h = StatusBarFrameH ?? 0
        
        backgroundView.frame = targetView.bounds
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTapAlert(_:))))
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        if (item_h + y) > (HEIGHT - (statusBottomFrameH_h + 48)) {
            alertView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor,
                                              constant: -(self.statusBottomFrameH_h + 48)).isActive = true
        }else {
            alertView.topAnchor.constraint(equalTo: targetView.topAnchor,
                                           constant: self.statusBarFrame_h + y).isActive = true
        }
        alertView.rightAnchor.constraint(equalTo: targetView.rightAnchor,
                                         constant: 0).isActive = true
        alertView.layer.cornerRadius = 3
        alertView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        alertView.layer.shadowRadius = 2
        alertView.layer.shadowOffset = CGSize(width: 2, height: 2)
        alertView.layer.shadowOpacity = 1
        alertView.layer.backgroundColor = UIColor.white.cgColor
        alertView.addSubview(stackMainView)
        stackMainView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 0).isActive = true
        stackMainView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0).isActive = true
        stackMainView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0).isActive = true
        stackMainView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 0).isActive = true
        
        for index in 0..<item.count {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.contentHorizontalAlignment = .center
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle(item[index], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            btn.backgroundColor = .white
            stackMainView.addArrangedSubview(btn)
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 105).isActive = true
        }
    }
    func showLeftAlert(vc: UITabBarController, item: [String], x: CGFloat, y: CGFloat) {
        guard let targetView = vc.view else {
            return
        }
        let item_h = CGFloat(item.count * 35)
        
        customTargetView = targetView
        self.statusBarFrame_h = StatusBarFrameH ?? 0
        
        backgroundView.frame = targetView.bounds
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTapAlert(_:))))
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        if (item_h + y) > (HEIGHT - (statusBottomFrameH_h + 48)) {
            alertView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor,
                                              constant: -(self.statusBottomFrameH_h + 48)).isActive = true
        }else {
            alertView.topAnchor.constraint(equalTo: targetView.topAnchor,
                                           constant: self.statusBarFrame_h + y).isActive = true
        }
        alertView.leftAnchor.constraint(equalTo: targetView.leftAnchor,
                                         constant: x).isActive = true
        alertView.layer.cornerRadius = 3
        alertView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        alertView.layer.shadowRadius = 2
        alertView.layer.shadowOffset = CGSize(width: 2, height: 2)
        alertView.layer.shadowOpacity = 1
        alertView.layer.backgroundColor = UIColor.white.cgColor
        alertView.addSubview(stackMainView)
        stackMainView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 0).isActive = true
        stackMainView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0).isActive = true
        stackMainView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0).isActive = true
        stackMainView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 0).isActive = true
        
        for index in 0..<item.count {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.contentHorizontalAlignment = .center
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle(item[index], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            btn.backgroundColor = .white
            stackMainView.addArrangedSubview(btn)
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 105).isActive = true
        }
    }
    func showAlert(vc: UITabBarController, item: [String], x: CGFloat, y: CGFloat) {
        guard let targetView = vc.view else {
            return
        }
        let item_h = CGFloat(item.count * 35)
        
        customTargetView = targetView
        self.statusBarFrame_h = StatusBarFrameH ?? 0
        
        backgroundView.frame = targetView.bounds
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTapAlert(_:))))
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        if (item_h + y) > (HEIGHT - (statusBottomFrameH_h + 48)) {
            alertView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor,
                                              constant: -(self.statusBottomFrameH_h + 48)).isActive = true
        }else {
            alertView.topAnchor.constraint(equalTo: targetView.topAnchor,
                                           constant: self.statusBarFrame_h + y).isActive = true
        }
        alertView.leftAnchor.constraint(equalTo: targetView.leftAnchor,
                                         constant: x).isActive = true
        alertView.layer.cornerRadius = 5
        alertView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        alertView.layer.masksToBounds = true
        alertView.addSubview(stackMainView)
        stackMainView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 0).isActive = true
        stackMainView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0).isActive = true
        stackMainView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0).isActive = true
        stackMainView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 0).isActive = true
        
        for index in 0..<item.count {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.contentHorizontalAlignment = .left
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle(item[index], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            btn.backgroundColor = Gary_Color
            stackMainView.spacing = 0
            stackMainView.addArrangedSubview(btn)
            btn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 90).isActive = true
        }
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
