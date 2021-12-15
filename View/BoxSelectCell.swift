//
//  BoxSelectCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit

class BoxSelectCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var photo_imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo_imgView.image = UIImage(named: "Ellipse78")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
