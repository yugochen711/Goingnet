//
//  Date+Extension.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/18.
//

import Foundation
import UIKit

extension Date {
    func nowAndyesterday() -> (now: String, yesterday: String) {
        let yesterday: Date = self - 86400
        let now: Date = self
        let dateTimeFormat: DateFormatter = DateFormatter()
        dateTimeFormat.dateFormat = "yyyy-MM-dd"
        dateTimeFormat.timeZone = TimeZone(identifier: "Asia/Taipei")!
        let dateTimeString: String = dateTimeFormat.string(from: now)
        let yesterdayString: String = dateTimeFormat.string(from: yesterday)
        return (dateTimeString, yesterdayString)
    }
}

