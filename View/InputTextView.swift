//
//  InputTextView.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftAlertView

class InputTextView: UIView {
    
    @IBOutlet weak var bottom_View: UIView!
    @IBOutlet weak var title_label: EdgeInsetLabel!
    @IBOutlet weak var input_textView: UITextView!
    @IBOutlet weak var input_textViewH: NSLayoutConstraint!
    @IBOutlet weak var clear_Btn: UIButton!
    @IBOutlet weak var select_Btn: SubButton!

    var padding = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 10)
    var fixed_type = ""
    let nibName = "InputTextView"

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
        
        title_label.text = ""
        title_label.textColor = TextGary_Color
        bottom_View.backgroundColor = TextGary_Color
        bottom_View.layer.cornerRadius = 6
        input_textView.text = ""
        input_textView.tintColor = Main_Color
        input_textView.font = UIFont.systemFont(ofSize: 18.0)
        input_textView.layer.cornerRadius = 6
        input_textView.textContainerInset = padding
        clear_Btn.layer.cornerRadius = 4
        clear_Btn.setTitle("", for: .normal)
        clear_Btn.setImage(UIImage(named: "Group267"), for: .normal)
        clear_Btn.tintColor = .white
        clear_Btn.backgroundColor = Gary_Color
    }

    @IBAction func clearButton(_ sender: UIButton) {
        input_textView.text = ""
    }
    @IBAction func selectButton(_ sender: UIButton) {
        IQKeyboardManager.shared.resignFirstResponder()
        let view = SelectView(frame: CGRect(x: 0, y: 0, width: WIDTH-60, height: WIDTH-60))
        view.fixed_type = fixed_type
        let alertView = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "取消")
        view.title_label.text = self.title_label.text ?? ""
        view.completionHandler = { (data) in
            if self.input_textView.text == "" {
                self.input_textView.text = data.content ?? ""
            }else {
                self.input_textView.text = self.input_textView.text + "\(SPACE)\(data.content ?? "")"
            }
            alertView.dismiss()
        }
        alertView.buttonTitleColor = Main_Color
        alertView.show()
    }
}
extension InputTextView {
    @IBInspectable
    var textViewHeight: CGFloat {
        set { input_textViewH.constant = newValue }
        get { return input_textViewH.constant }
    }
}
extension InputTextView: SwiftAlertViewDelegate {
    
}
