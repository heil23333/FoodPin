//
//  RestaurantDetailUIViewController.swift
//  FoodPin
//
//  Created by  He on 2025/11/30.
//

import UIKit

class RestaurantDetailUIViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RestaurantDetailHeaderView!
    
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        if let restaurant = restaurant {
            headerView.nameLabel.text = restaurant.name
            headerView.typeLabel.text = restaurant.type
            headerView.headerImageView.image = UIImage(named: restaurant.image)
            let heartImageName = restaurant.isFavorite ? "heart.fill" : "heart"
            headerView.heartButton.configuration = nil//ios15以上tintColor等属性会被configuration覆盖
            headerView.heartButton.setImage(UIImage(systemName: heartImageName), for: .normal)
            headerView.heartButton.tintColor = restaurant.isFavorite ? .systemRed : .white
        }
        
    }
    
    

}
