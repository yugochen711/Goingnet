//
//  DetailCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/4.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var firstContent_label: UILabel!
    @IBOutlet weak var secondContent_label: EdgeInsetLabel!
    @IBOutlet weak var thirdContent_label: EdgeInsetLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstContent_label.font = UIFont.systemFont(ofSize: 18.0)
        
        secondContent_label.font = UIFont.systemFont(ofSize: 18.0)
        secondContent_label.backgroundColor = Red_Color
        secondContent_label.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        secondContent_label.layer.masksToBounds = true
        secondContent_label.layer.cornerRadius = 5
        
        thirdContent_label.font = UIFont.systemFont(ofSize: 18.0)
        thirdContent_label.backgroundColor = Gary_Color
        thirdContent_label.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        thirdContent_label.numberOfLines = 0
        thirdContent_label.layer.masksToBounds = true
        thirdContent_label.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
