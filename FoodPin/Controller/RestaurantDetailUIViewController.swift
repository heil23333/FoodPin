//
//  RestaurantDetailUIViewController.swift
//  FoodPin
//
//  Created by  He on 2025/11/30.
//

import UIKit

class RestaurantDetailUIViewController: UIViewController {
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        if let restaurant = restaurant {
            restaurantImageView.image = UIImage(named: restaurant.image)
            restaurantNameLabel.text = restaurant.name
            typeLabel.text = restaurant.type
            locationLabel.text = restaurant.location
        }
        
    }
    
    

}
