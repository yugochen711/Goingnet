//
//  String+Extension.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/18.
//

import Foundation
import UIKit

extension String {
    func nowTime() -> Date? {
        let dateTimeFormat: DateFormatter = DateFormatter()
        dateTimeFormat.dateFormat = "yyyy-MM-dd"
        dateTimeFormat.timeZone = TimeZone(identifier: "Asia/Taipei")!
        if let dateTime: Date = dateTimeFormat.date(from: self) {
            return dateTime
        }else {
            return nil
        }
    }
}
