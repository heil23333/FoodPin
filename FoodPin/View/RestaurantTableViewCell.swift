//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by  He on 2025/11/28.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel! {
        didSet {
            locationLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = 10
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tintColor = .systemYellow//更改对勾颜色
        thumbnailImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCustomAccessory() {
        // 移除系统 accessory
        self.accessoryType = .none
        
        // 1. 创建自定义视图（例如 UIImageView 或 UIButton）
        let customImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        // 2. 配置自定义视图的外观
        if let customImage = UIImage(systemName: "heart.fill") {
            customImageView.image = customImage
            customImageView.tintColor = .systemRed // 设置颜色
            customImageView.contentMode = .scaleAspectFit
        }
        
        // 3. 将自定义视图赋值给 accessoryView
        self.accessoryView = customImageView
    }
    
}
