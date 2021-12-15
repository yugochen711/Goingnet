//
//  CategorySecondCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/17.
//

import UIKit

class CategorySecondCell: UITableViewCell {
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var contnet_label: UILabel!
    @IBOutlet weak var subTitle_label: UILabel!
    @IBOutlet weak var photo_imgView: UIImageView!
    @IBOutlet weak var detail_Btn: UIButton!
    
    var upload_status: Bool = false {
        didSet {
            attr(upload: upload_status, edit: edit_status, photoCount: photoCount)
        }
    }
    var edit_status: Bool = false {
        didSet {
            attr(upload: upload_status, edit: edit_status, photoCount: photoCount)
        }
    }
    var photoCount: String = "" {
        didSet {
            attr(upload: upload_status, edit: edit_status, photoCount: photoCount)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        photo_imgView.image = UIImage(named: "Ellipse78")
        title_label.text = ""
        contnet_label.text = ""
        contnet_label.textColor = TextGary_Color
        subTitle_label.text = ""
        subTitle_label.numberOfLines = 0
        subTitle_label.lineBreakMode = .byWordWrapping
        subTitle_label.textColor = TextGary_Color
        
        detail_Btn.titleLabel?.font = UIFont.systemFont(ofSize: 6.0)
        detail_Btn.setTitle("● ● ●", for: .normal)
        detail_Btn.setTitleColor(TextGary_Color, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func attr(upload: Bool, edit: Bool, photoCount: String) {
        let attr = NSMutableAttributedString(string: "上傳狀態:\(upload ? "是": "否")\(SPACE)編輯狀態:\(edit ? "是": "否")\(SPACE)照片張數:\(photoCount)")
        attr.addAttributes([NSAttributedString.Key.foregroundColor : upload ? Main_Color: Red_Color],
                            range: NSRange(location: 5, length: 1))
        attr.addAttributes([NSAttributedString.Key.foregroundColor : edit ? Red_Color: Main_Color],
                            range: NSRange(location: 13, length: 1))
        attr.addAttributes([NSAttributedString.Key.foregroundColor : Red_Color],
                           range: NSRange(location: WIDTH <= 375 ? 20: 21, length: photoCount.count))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        attr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle],
                           range: NSRange(location: 0, length: attr.length))
        subTitle_label.attributedText = attr
    }
}
