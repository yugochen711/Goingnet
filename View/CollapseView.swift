//
//  CollapseView.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import UIKit

class CollapseView: UIView {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var collapse_Btn: UIButton!
    
    let nibName = "CollapseView"

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
        
        title_label.textColor = TextGary_Color
        collapse_Btn.tintColor = TextGary_Color
        collapse_Btn.setTitle("", for: .normal)
        collapse_Btn.setImage(UIImage(named: "up"), for: .normal)
    }
}
