//
//  MenuHomeVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit

class MenuHomeVC: BaseVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func layout(title: String) {
        print("title = \(title), children = \(self.children)")
        if let vc = self.children.first(where: {$0.isKind(of: AllExamineVC.self)}) {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        if let vc = self.children.first(where: {$0.isKind(of: MaintainVC.self)}) {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        if let vc = self.children.first(where: {$0.isKind(of: ProjectVC.self)}) {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        switch title {
        case "總檢":
            let allExamineVC = AllExamine_Storyboard.instantiateViewController(withIdentifier: "AllExamineVC") as! AllExamineVC
            self.addChild(allExamineVC)
            allExamineVC.view.frame = self.view.bounds
            self.view.addSubview(allExamineVC.view)
            self.didMove(toParent: self)
        case "保養":
            let maintainVC = Maintain_Storyboard.instantiateViewController(withIdentifier: "MaintainVC") as! MaintainVC
            self.addChild(maintainVC)
            maintainVC.view.frame = self.view.bounds
            self.view.addSubview(maintainVC.view)
            self.didMove(toParent: self)
        case "工程":
            let projectVC = Project_Storyboard.instantiateViewController(withIdentifier: "ProjectVC") as! ProjectVC
            self.addChild(projectVC)
            projectVC.view.frame = self.view.bounds
            self.view.addSubview(projectVC.view)
            self.didMove(toParent: self)
        default:
            break
        }
    }
    @objc func menuButton(_ sender: UIButton) {
        self.onSlideMenuButtonPressed()
    }
}
