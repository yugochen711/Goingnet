//
//  TopBarView.swift
//  KIHSIOA
//
//  Created by 陳冠宇 on 2021/7/15.
//

import UIKit

protocol TopBarViewDelegate {
    func selectType(type: String)
}
class TopBarView: UIView {

    @IBOutlet weak var left_Btn: UIButton!
    @IBOutlet weak var left_View: UIView!
    @IBOutlet weak var right_Btn: UIButton!
    @IBOutlet weak var right_View: UIView!
    
    var topBarViewDelegate: TopBarViewDelegate?
    let nibName = "TopBarView"

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
        xibView.backgroundColor = .clear
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        left_Btn.setTitle("未上傳", for: .normal)
        left_Btn.setTitleColor(Main_Color, for: .normal)
        left_View.backgroundColor = Main_Color
        
        right_Btn.setTitle("已上傳", for: .normal)
        right_Btn.setTitleColor(GaryLine_Color, for: .normal)
        right_View.backgroundColor = .white
    }

    @IBAction func leftButton(_ sender: UIButton) {
        left_View.backgroundColor = Main_Color
        right_View.backgroundColor = .white
        
        left_Btn.setTitleColor(Main_Color, for: .normal)
        right_Btn.setTitleColor(GaryLine_Color, for: .normal)
        topBarViewDelegate?.selectType(type: "0")//未上傳
    }
    @IBAction func rightButton(_ sender: UIButton) {
        left_View.backgroundColor = .white
        right_View.backgroundColor = Main_Color
        
        left_Btn.setTitleColor(GaryLine_Color, for: .normal)
        right_Btn.setTitleColor(Main_Color, for: .normal)
        topBarViewDelegate?.selectType(type: "1")//已上傳
    }
}
