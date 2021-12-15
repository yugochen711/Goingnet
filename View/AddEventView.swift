//
//  AddEventView.swift
//  KIHSIOA
//
//  Created by 陳冠宇 on 2021/10/4.
//

import UIKit

class AddEventView: UIView {

    @IBOutlet weak var close_Btn: UIButton!
    @IBOutlet weak var addGenerally_Btn: MainButton!
    @IBOutlet weak var addOther_Btn: MainButton!
    
    let nibName = "AddEventView"

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
        xibView.layer.cornerRadius = 12
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        close_Btn.setTitle("", for: .normal)
        close_Btn.setImage(UIImage(named: "Group267"), for: .normal)
        close_Btn.tintColor = TextGary_Color
        
        addGenerally_Btn.layer.cornerRadius = 22.5
        addGenerally_Btn.backgroundColor = Main_Color
        addGenerally_Btn.setTitle("建立一般工程", for: .normal)
        addGenerally_Btn.setTitleColor(.white, for: .normal)
        addGenerally_Btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        addOther_Btn.layer.cornerRadius = 22.5
        addOther_Btn.backgroundColor = Blue_Color
        addOther_Btn.setTitle("建立消防工程", for: .normal)
        addOther_Btn.setTitleColor(.white, for: .normal)
        addOther_Btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }

}
