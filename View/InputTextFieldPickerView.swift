//
//  InputTextFieldPickerView.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit
import SwiftAlertView
import DatePickerDialog
import IQKeyboardManagerSwift

class InputTextFieldPickerView: UIView {
    
    @IBOutlet weak var bottom_View: UIView!
    @IBOutlet weak var title_label: EdgeInsetLabel!
    @IBOutlet weak var input_textField: InputTextField!
    @IBOutlet weak var clear_Btn: UIButton!
    
    let nibName = "InputTextFieldPickerView"
    let btn = UIButton()
    var btn_type = ""
    var fixed_type = ""
    var group_id = ""

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
        xibView.backgroundColor = .white
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        title_label.text = "title"
        title_label.textColor = TextGary_Color
        bottom_View.backgroundColor = TextGary_Color
        bottom_View.layer.cornerRadius = 6
        
        input_textField.rightViewMode = .always
        
        btn.tintColor = TextGary_Color
        btn.addTarget(self, action: #selector(downButton(_:)), for: .touchUpInside)
        
        input_textField.rightView = btn
        input_textField.tintColor = Main_Color
        input_textField.font = UIFont.systemFont(ofSize: 18.0)
        input_textField.delegate = self
        
        clear_Btn.layer.cornerRadius = 4
        clear_Btn.setTitle("", for: .normal)
        clear_Btn.setImage(UIImage(named: "Group267"), for: .normal)
        clear_Btn.tintColor = .white
        clear_Btn.backgroundColor = Gary_Color
        clear_Btn.isHidden = true
    }
    ///取得所有view物件
    private func processSubviews(of view: UIView, type: String) {
        // 1. code here do something with view
        for subview in view.subviews {
            // 2. code here do something with subview
            processSubviews(of: subview, type: type)
            // 3. code here do something with subview
            if let v = subview as? InputTextFieldPickerView {
                switch type {
                case "name":
                    if v.fixed_type == "building" {
                        v.input_textField.text = ""
                    }
                case "building":
                    if v.fixed_type == "floor" || v.fixed_type == "staircase" {
                        v.input_textField.text = ""
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc private func downButton(_ sender: UIButton) {
        IQKeyboardManager.shared.resignFirstResponder()
        switch btn_type {
        case "down":
            switch self.fixed_type {
            case "name":
                let view = SelectView(frame: CGRect(x: 0, y: 0, width: WIDTH-60, height: WIDTH-60))
                view.fixed_type = fixed_type
                let alertView = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "取消")
                view.title_label.text = self.title_label.text ?? ""
                view.completionHandler = { (data) in
                    if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                        if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
                            self.processSubviews(of: homeTBC.topMostVC().view, type: self.fixed_type)
                        }
                    }
                    self.group_id = data.id ?? ""
                    self.input_textField.text = data.content ?? ""
                    alertView.dismiss()
                }
                alertView.buttonTitleColor = Main_Color
                alertView.show()
            default:
                let view = BoxSelectView(frame: CGRect(x: 0, y: 0, width: WIDTH-60, height: WIDTH-60))
                view.fixed_type = fixed_type
                view.group_id = group_id
                let alertView = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "取消")
                view.completionHandler = { (data) in
                    if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                        if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
                            self.processSubviews(of: homeTBC.topMostVC().view, type: self.fixed_type)
                        }
                    }
                    self.input_textField.text = data.content ?? ""
                    alertView.dismiss()
                }
                alertView.buttonTitleColor = Main_Color
                alertView.show()
//                alertView.clickedButtonAction = { buttonIndex in
//                    if alertView.button(at: buttonIndex)?.currentTitle == "確定" {
//                        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
//                            if let homeTBC = appdelegate.window?.rootViewController as? HomeTBC {
//                                self.processSubviews(of: homeTBC.topMostVC().view, type: self.fixed_type)
//                            }
//                        }
//                        if let dataSource = view.dataSource.first(where: {$0.select_status}) {
//                            self.input_textField.text = dataSource.content ?? ""
//                        }
//                    }
//                }
            }
        case "date":
            let datePicker = DatePickerDialog(textColor: .black, buttonColor: .black, font: UIFont.systemFont(ofSize: 16.0), locale: Locale(identifier: "zh_Hant_TW"), showCancelButton: true)
            if #available(iOS 13.4, *) { datePicker.datePicker.preferredDatePickerStyle = .wheels }
            datePicker.show("",
                            doneButtonTitle: "確定",
                            cancelButtonTitle: "取消",
                            minimumDate: nil,
                            maximumDate: nil,
                            datePickerMode: .date) { (date) in
                if let dt = date {
                    print("dt = \(dt)")
                    let formatter = DateFormatter()
                    formatter.locale = Locale.init(identifier: "zh_CN")
                    formatter.dateFormat = "YYYY-MM-dd"
                    self.input_textField.text = formatter.string(from: dt)
                }
            }
        default:
            break
        }
    }
    @IBAction func clearButton(_ sender: UIButton) {
        input_textField.text = ""
    }
}
extension InputTextFieldPickerView {
    @IBInspectable
    var buttonType: String {
        set {
            btn_type = newValue
            btn.setImage(UIImage(named: btn_type), for: .normal)
            if btn_type != "" {
                input_textField.placeholder = "請選擇"
            }
        }
        get { return btn_type }
    }
}
extension InputTextFieldPickerView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if btn_type == "" {
            return true
        }
        return false
    }
}
extension InputTextFieldPickerView: SwiftAlertViewDelegate {
    
}
