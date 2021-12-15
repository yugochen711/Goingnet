//
//  ModelDataSource.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/10.
//

import Foundation
import UIKit
import GRDB

struct Community {
    var group_id: String
    var item_id: String
}
extension Community : FetchableRecord {
    enum Columns: String, ColumnExpression {
        case group_id, item_id
    }
    
    init(row: Row) {
        group_id = row[Columns.group_id]
        item_id = row[Columns.item_id]
    }
}
class DB_dataSource {
    var type: String?//總檢,保養,工程：一般工程, 消防
    var project_type: String?//一般工程, 消防
    var name: String?//名稱
    var group_id: String?//社區ID
    var maintain_id: String?//保養ID
    var project_id: String?//工程ID
    var item_id: String?//項目ID 社區底下的專案ID project_id
    var building: String?//棟別
    var system: String?//系統
    var floor: String?//樓層
    var position: String?//位置
    var staircase: String?//梯間
    var quotation: String?//估價單號
    var fire: String?//消防項目
    var img: Data?//圖片
    var before_img: Data?//工程前圖片
    var middle_img: Data?//工程中圖片
    var after_img: Data?//工程後圖片
    var instruction1: String?//缺失說明1, 保養說明, 修繕說明
    var instruction2: String?//缺失說明2
    var instruction3: String?//缺失說明3
    var startDate: String?//開始日期
    var endDate: String?//結束日期
    var upload_status: Bool//上傳狀態
    var edit_status: Bool//編輯狀態
    var status: Bool//複檢狀態
    var time: String?//記錄時間

    internal init(type: String? = nil, project_type: String? = nil, name: String? = nil, group_id: String? = nil, maintain_id: String? = nil, project_id: String? = nil, item_id: String? = nil, building: String? = nil, system: String? = nil, floor: String? = nil, position: String? = nil, staircase: String? = nil, quotation: String? = nil, fire: String? = nil, img: Data? = nil, before_img: Data? = nil, middle_img: Data? = nil, after_img: Data? = nil, instruction1: String? = nil, instruction2: String? = nil, instruction3: String? = nil, startDate: String? = nil, endDate: String? = nil, upload_status: Bool, edit_status: Bool, status: Bool, time: String? = nil) {
        self.type = type
        self.project_type = project_type
        self.name = name
        self.group_id = group_id
        self.maintain_id = maintain_id
        self.project_id = project_id
        self.item_id = item_id
        self.building = building
        self.system = system
        self.floor = floor
        self.position = position
        self.staircase = staircase
        self.quotation = quotation
        self.fire = fire
        self.img = img
        self.before_img = before_img
        self.middle_img = middle_img
        self.after_img = after_img
        self.instruction1 = instruction1
        self.instruction2 = instruction2
        self.instruction3 = instruction3
        self.startDate = startDate
        self.endDate = endDate
        self.upload_status = upload_status
        self.edit_status = edit_status
        self.status = status
        self.time = time
    }
}

class FixedDataSource {
    var id: String?
    var content: String?
    var select_status: Bool
    
    internal init(id: String? = nil, content: String? = nil, select_status: Bool) {
        self.id = id
        self.content = content
        self.select_status = select_status
    }
}
class MaintainDataSource {
    var title: String
    var data: [DB_dataSource]
    var noUpload: [Int]
    var allCount: [Int]
    var is_Select: [Bool]

    internal init(title: String, data: [DB_dataSource], noUpload: [Int], allCount: [Int], is_Select: [Bool]) {
        self.title = title
        self.data = data
        self.noUpload = noUpload
        self.allCount = allCount
        self.is_Select = is_Select
    }
}
