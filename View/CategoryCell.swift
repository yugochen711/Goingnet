//
//  CategoryCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var upload_label: UILabel!
    @IBOutlet weak var detail_Btn: UIButton!
    @IBOutlet weak var start_label: UILabel!
    @IBOutlet weak var end_label: UILabel!
    @IBOutlet weak var total_label: UILabel!
    @IBOutlet weak var status_Btn: MainButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title_label.text = "福地臨門 - 地面整平 (消防)"
        upload_label.textColor = .red
        upload_label.text = "未上傳 : 2"
        start_label.textColor = TextGary_Color
        start_label.text = "工程開始 : 2021 / 08 / 03"
        end_label.textColor = TextGary_Color
        end_label.text = "工程結束 : 2021 / 09 / 30"
        total_label.textColor = Main_Color
        total_label.text = "總筆數 : 12"
        
        detail_Btn.titleLabel?.font = UIFont.systemFont(ofSize: 6.0)
        detail_Btn.setTitle("● ● ●", for: .normal)
        detail_Btn.setTitleColor(TextGary_Color, for: .normal)
        
        status_Btn.setTitle("複製連結", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
