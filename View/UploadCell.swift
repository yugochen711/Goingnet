//
//  UploadCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/5.
//

import UIKit

class UploadCell: UITableViewCell {

    @IBOutlet weak var bottom_View: UIView!
    @IBOutlet weak var photo_imgView: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottom_View.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
