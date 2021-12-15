//
//  SecondPhotoCell.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit

class SecondPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var bottom_View: UIView!
    @IBOutlet weak var photo_imgView: UIImageView!
    @IBOutlet weak var close_Btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottom_View.layer.cornerRadius = 2
        bottom_View.layer.masksToBounds = true
        photo_imgView.contentMode = .scaleAspectFill
        close_Btn.setTitle("", for: .normal)
        close_Btn.setImage(UIImage(named: "Frame7"), for: .normal)
        close_Btn.tintColor = .white
    }

}
