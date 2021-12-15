//
//  DeleteAndUploadCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import UIKit

class DeleteAndUploadCell: UITableViewCell {
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var subTitle_label: UILabel!
    @IBOutlet weak var photo_imgView: UIImageView!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
