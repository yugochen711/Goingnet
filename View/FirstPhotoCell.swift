//
//  FirstPhotoCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit

class FirstPhotoCell: UICollectionViewCell {

    @IBOutlet weak var bottom_View: UIView!
    @IBOutlet weak var photo_imgView: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottom_View.layer.cornerRadius = 2
        bottom_View.backgroundColor = Gary_Color
        title_label.textColor = TextGary_Color
    }

}
