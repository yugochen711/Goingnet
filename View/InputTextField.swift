//
//  InputTextField.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit

class InputTextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    func setUI() {
        self.borderStyle = .none
        self.backgroundColor = .white
        self.tintColor = Main_Color
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 18.0)
        self.layer.cornerRadius = 6
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}

