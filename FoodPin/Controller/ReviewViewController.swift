//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by  He on 2025/12/3.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = UIImage(named: restaurant.image)
        
        //设置背景模糊
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
//        for rateButton in rateButtons {
//            rateButton.alpha = 0//隐藏
//        }
        
        //移至屏幕右侧并隐藏
//        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
//        for rateButton in rateButtons {
//            rateButton.transform = moveRightTransform
//            rateButton.alpha = 0
//        }
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.1, y: 5.1)//xy方向分别拉伸
        let moveAndScaleTransform = moveRightTransform.concatenating(scaleUpTransform)//合并两个形变
        for rateButton in rateButtons {
            rateButton.transform = moveAndScaleTransform
            rateButton.alpha = 0
        }
        
        let moveTopTransform = CGAffineTransform.init(translationX: 0, y: -500)
        closeButton.transform = moveTopTransform
        closeButton.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //批量出现
//        UIView.animate(withDuration: 2.0) {
//            for rateButton in self.rateButtons {
//                rateButton.alpha = 1
//            }
//        }
        
        //依次延迟出现
//        for index in 0..<rateButtons.count {
//            let delayTime = Double(index) * 0.05 + 0.1
//            UIView.animate(withDuration: 0.4, delay: delayTime) {
//                self.rateButtons[index].alpha = 1
//            }
//        }
        
//        for index in 0..<rateButtons.count {
//            let delayTime = Double(index) * 0.05 + 0.1
//            UIView.animate(withDuration: 0.4, delay: delayTime) {
//                self.rateButtons[index].alpha = 1
//                self.rateButtons[index].transform = .identity
//            }
//        }
        
        //弹性动画
        for index in 0..<rateButtons.count {
            let delayTime = Double(index) * 0.05 + 0.1
            UIView.animate(
                withDuration: 1,
                delay: delayTime,
                usingSpringWithDamping: 0.8,//阻尼系数, 0无限反弹, 1无反弹
                initialSpringVelocity: 0//初始速度, 0表示初始速度为0
            ) {
                self.rateButtons[index].alpha = 1
                self.rateButtons[index].transform = .identity
            }
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7) {
            self.closeButton.alpha = 1
            self.closeButton.transform = .identity
        }
    }
}
