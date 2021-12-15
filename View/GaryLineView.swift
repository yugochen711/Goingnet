//
//  GaryLineView.swift
//  KIHSIOA
//
//  Created by 陳冠宇 on 2021/7/15.
//

import UIKit

class GaryLineView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    func setUI() {
        self.backgroundColor = GaryLine_Color
    }

}
