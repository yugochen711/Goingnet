//
//  InputTextFieldView.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/1.
//

import UIKit

class InputTextFieldView: UIView {

    @IBOutlet weak var title_label: EdgeInsetLabel!
    @IBOutlet weak var title_labelC: NSLayoutConstraint!
    @IBOutlet weak var input_textField: InputTextField!
    
    let nibName = "InputTextField"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    fileprivate func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        ///透過nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        xibView.tag = -999
        xibView.backgroundColor = Gary_Color
        xibView.layer.cornerRadius = 6
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        title_label.font = UIFont.systemFont(ofSize: 18.0)
        title_label.textColor = Gary_Color
        input_textField.delegate = self
        input_textField.tintColor = Main_Color
        input_textField.font = UIFont.systemFont(ofSize: 18.0)
    }
}
extension InputTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.title_label.textColor = Gary_Color
            self.title_labelC.constant = -30
            self.viewWithTag(-999)?.backgroundColor = Gary_Color
            self.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            self.title_label.textColor = Main_Color
            if self.title_labelC.constant <= 0 {
                self.title_labelC.constant += 1
            }
            self.viewWithTag(-999)?.backgroundColor = Main_Color
        })
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.title_label.textColor = Main_Color
                self.title_labelC.constant = 0
                self.viewWithTag(-999)?.backgroundColor = Main_Color
                self.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                self.title_label.textColor = Gary_Color
                if self.title_labelC.constant >= -30 {
                    self.title_labelC.constant -= 1
                }
                self.viewWithTag(-999)?.backgroundColor = Gary_Color
            })
        }else {
            self.title_label.textColor = Gary_Color
            self.title_labelC.constant = -30
            self.viewWithTag(-999)?.backgroundColor = Gary_Color
        }
        return true
    }
}
