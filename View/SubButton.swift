//
//  SubButton.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit

class SubButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        self.layer.cornerRadius = 6
        self.backgroundColor = Sub_Color
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.4
        self.layer.backgroundColor = Sub_Color.cgColor
    }

}
