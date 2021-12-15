//
//  ImagePreViewVC.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/3.
//

import UIKit
import SwiftyDraw

class ImagePreViewVC: UIViewController {

    @IBOutlet weak var bottom_View: UIView!
    @IBOutlet weak var check_Btn: MainButton!
    @IBOutlet weak var clear_Btn: MainButton!
    @IBOutlet weak var close_Btn: UIButton!
    @IBOutlet weak var drawView: SwiftyDrawView!
    @IBOutlet weak var photo_imgView: UIImageView!
    
    var image: UIImage?
    var completionHandler: (((UIImage))->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    private func layout() {
        view.backgroundColor = .black
        bottom_View.backgroundColor = .black
        if let img = self.image {
            photo_imgView.image = img
        }
        check_Btn.setTitle("確定", for: .normal)
        check_Btn.backgroundColor = Cell_Color
        check_Btn.setTitleColor(TextGary_Color, for: .normal)
        clear_Btn.setTitle("清除", for: .normal)
        clear_Btn.backgroundColor = Cell_Color
        clear_Btn.setTitleColor(TextGary_Color, for: .normal)
        close_Btn.setTitle("", for: .normal)
        close_Btn.setImage(UIImage(named: "Group267"), for: .normal)
        close_Btn.tintColor = .white
        
        drawView.backgroundColor = .clear
        drawView.delegate = self
        drawView.brush.width = 7
        drawView.brush.color = Color(.red)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        completionHandler?(bottom_View.asImage())
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clearButton(_ sender: UIButton) {
        drawView.clear()
    }
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension ImagePreViewVC: SwiftyDrawViewDelegate {
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool { return true }
    func swiftyDraw(didBeginDrawingIn    drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(isDrawingIn          drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didFinishDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didCancelDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
}
