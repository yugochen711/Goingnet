//
//  UISearchBar+Extension.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import Foundation
import UIKit

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 5
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
