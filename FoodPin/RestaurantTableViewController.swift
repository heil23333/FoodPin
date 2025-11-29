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
    
    var restaurantIsFavorites = Array(repeating: false, count: 21)
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = true//自动调节cell宽度

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurantNames)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView) { tableView, indexPath, resturantName in
            let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! RestaurantTableViewCell
            cell.nameLabel.text = resturantName
            cell.typeLabel.text = self.restaurantType[indexPath.row]
            cell.locationLabel.text = self.restaurantLocations[indexPath.row]
            cell.thumbnailImageView.image = UIImage(named: resturantName)
            if self.restaurantIsFavorites[indexPath.row] {
                cell.configureCustomAccessory()
            } else {
                cell.accessoryType = .none
                cell.accessoryView = nil
            }
            
            return cell
        }
        return dataSource
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        //针对iPad
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        
        //reserve选项
        let reserveActionHandler = { (action: UIAlertAction) -> Void in
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature is not yet available yet. Please retry later", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)
        
        //favorite选项
        let title = self.restaurantIsFavorites[indexPath.row] ? "Undo Checkin" : "Mark as favorite"
        let favoriteAction = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
            self.restaurantIsFavorites[indexPath.row] = !self.restaurantIsFavorites[indexPath.row]
            let cell = self.tableView.cellForRow(at: indexPath)! as! RestaurantTableViewCell
            if self.restaurantIsFavorites[indexPath.row] {
                cell.configureCustomAccessory()
            } else {
                cell.accessoryView = .none
                cell.accessoryView = nil
            }
        }
        optionMenu.addAction(favoriteAction)
        
        //cancel选项
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
        
        //取消选择
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

enum Section {
    case all
}
