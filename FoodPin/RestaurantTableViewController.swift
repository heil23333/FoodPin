//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by  He on 2025/11/28.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    var restaurantNames = ["Barrafina", "Bourke Street Bakery", "Cafe Deadend", "Cafe Loisl", "Cafe Lore", "CASK Pub and Kitchen", "Confessional", "Donostia", "Five Leaves", "For Kee Restaurant", "Graham Avenue Meats And Deli", "Haigh's Chocolate", "Homei", "Palomino Espresso", "Petite Oyster", "Po's Atelier", "Royal Oak", "Teakha", "Traif", "Upstate", "Waffle & Wolf"]
    
    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantType = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]

    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurantNames)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView) { tableView, indexPath, resturantName in
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoritecell", for: indexPath) as! RestaurantTableViewCell
            cell.nameLabel.text = resturantName
            cell.typeLabel.text = self.restaurantType[indexPath.row]
            cell.locationLabel.text = self.restaurantLocations[indexPath.row]
            cell.thumbnailImageView.image = UIImage(named: resturantName)
            
            return cell
        }
        return dataSource
    }
}

enum Section {
    case all
}
