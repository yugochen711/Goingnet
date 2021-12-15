//
//  AllExamineCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/2.
//

import UIKit

class AllExamineCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var subTitle_label: UILabel!
    @IBOutlet var otherTitle_label: [UILabel]!
    @IBOutlet weak var floor_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var info_label: UILabel!
    
    var subArr = ["樓層：", "位置：", "缺失說明："]
    var upload_status: Bool = false {
        didSet {
            attr(upload: upload_status, edit: edit_status, status: status)
        }
    }
    var edit_status: Bool = false {
        didSet {
            attr(upload: upload_status, edit: edit_status, status: status)
        }
    }
    var status: Bool = false {
        didSet {
            attr(upload: upload_status, edit: edit_status, status: status)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title_label.text = ""
        
        subTitle_label.numberOfLines = 0
        subTitle_label.lineBreakMode = .byWordWrapping
        subTitle_label.textColor = TextGary_Color
        
        for index in 0..<otherTitle_label.count {
            otherTitle_label[index].text = subArr[index]
            if index != 2 {
                otherTitle_label[index].textColor = TextGary_Color
            }
        }
        
        floor_label.textColor = Main_Color
        floor_label.text = ""
        
        location_label.textColor = Main_Color
        location_label.text = ""
        
        info_label.textColor = Main_Color
        info_label.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func attr(upload: Bool, edit: Bool, status: Bool) {
        let attr = NSMutableAttributedString(string: "上傳狀態:\(upload ? "是": "否")\(SPACE)編輯狀態:\(edit ? "是": "否")\(SPACE)複檢狀態:\(status ? "是": "否")")
        attr.addAttributes([NSAttributedString.Key.foregroundColor : upload ? Main_Color: Red_Color],
                            range: NSRange(location: 5, length: 1))
        attr.addAttributes([NSAttributedString.Key.foregroundColor : edit ? Red_Color: Main_Color],
                            range: NSRange(location: 13, length: 1))
        attr.addAttributes([NSAttributedString.Key.foregroundColor : status ? Red_Color: Main_Color],
                           range: NSRange(location: WIDTH <= 375 ? 20: 21, length: 1))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        attr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle],
                           range: NSRange(location: 0, length: attr.length))
        subTitle_label.attributedText = attr
    }
}
