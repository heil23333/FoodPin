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
    @IBOutlet var ratingImageView: UIImageView!
    
    var restaurant: Restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""
        
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = restaurant.image
        let heartImageName = restaurant.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.configuration = nil//ios15以上tintColor等属性会被configuration覆盖
        headerView.heartButton.setImage(UIImage(systemName: heartImageName), for: .normal)
        headerView.heartButton.tintColor = restaurant.isFavorite ? .systemRed : .white
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant.summary
            return cell
            case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoColumnCell.self), for: indexPath) as! RestaurantDetailTwoColumnCell
            
            cell.column1TitleLabel.text = "Adress"
            cell.column1TextLabel.text = restaurant.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant.phone
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            cell.configure(location: restaurant.location)
            cell.selectionStyle = .none
            return cell
        default:
            fatalError("Failed to create cell")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        case "showReview":
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
            break
        default :
            break
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        guard let identifer = segue.identifier else { return }
        
        if let rating = Restaurant.Rating(rawValue: identifer) {
            self.restaurant.rating = rating
            self.headerView.ratingImage.image = UIImage(named: rating.image)
        }
        
        let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.headerView.ratingImage.transform = scaleTransform
        self.headerView.ratingImage.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7) {
            self.headerView.ratingImage.transform = .identity
            self.headerView.ratingImage.alpha = 1
        }
    }
}
