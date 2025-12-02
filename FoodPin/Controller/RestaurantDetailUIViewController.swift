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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        //控制滚动视图的页面边距如何调整, never即不自动控制, 需手动处理安全区域
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension RestaurantDetailUIViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant?.description
            return cell
            case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoColumnCell.self), for: indexPath) as! RestaurantDetailTwoColumnCell
            cell.column1TitleLabel.text = "Adress"
            cell.column1TextLabel.text = restaurant?.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant?.phone
            return cell
        default:
            fatalError("Failed to create cell")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
