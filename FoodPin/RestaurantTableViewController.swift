//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by  He on 2025/11/28.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    var restaurants: [Restaurant] = [
        Restaurant(name: "Barrafina", type: "Coffee & Tea Shop", location: "Hong Kong", image: "Barrafina", isFavorite: false),
        Restaurant(name: "Bourke Street Bakery", type: "Cafe", location: "Hong Kong", image: "Bourke Street Bakery", isFavorite: false),
        Restaurant(name: "Cafe Deadend", type: "Tea House", location: "Hong Kong", image: "Cafe Deadend", isFavorite: false),
        Restaurant(name: "Cafe Loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "Cafe Loisl", isFavorite: false),
        Restaurant(name: "Cafe Lore", type: "French", location: "Hong Kong", image: "Cafe Lore", isFavorite: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Bakery", location: "Hong Kong", image: "CASK Pub and Kitchen", isFavorite: false),
        Restaurant(name: "Confessional", type: "Bakery", location: "Hong Kong", image: "Confessional", isFavorite: false),
        Restaurant(name: "Donostia", type: "Chocolate", location: "Sydney", image: "Donostia", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Cafe", location: "Sydney", image: "Five Leaves", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "American / Seafood", location: "Sydney", image: "For Kee Restaurant", isFavorite: false),
        Restaurant(name: "Graham Avenue Meats And Deli", type: "American", location: "New York", image: "Graham Avenue Meats And Deli", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "American", location: "New York", image: "Haigh's Chocolate", isFavorite: false),
        Restaurant(name: "Homei", type: "Breakfast & Brunch", location: "New York", image: "Homei", isFavorite: false),
        Restaurant(name: "Palomino Espresso", type: "Coffee & Tea", location: "New York", image: "Palomino Espresso", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "Coffee & Tea", location: "New York", image: "Petite Oyster", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Latin American", location: "New York", image: "Po's Atelier", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "Spanish", location: "New York", image: "Royal Oak", isFavorite: false),
        Restaurant(name: "Teakha", type: "Spanish", location: "London", image: "Teakha", isFavorite: false),
        Restaurant(name: "Traif", type: "Spanish", location: "London", image: "Traif", isFavorite: false),
        Restaurant(name: "Upstate", type: "British", location: "London", image: "Upstate", isFavorite: false),
        Restaurant(name: "Waffle & Wolf", type: "Thai", location: "London", image: "Waffle & Wolf", isFavorite: false)
    ]
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = true//自动调节cell宽度

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Restaurant> {
        let dataSource = UITableViewDiffableDataSource<Section, Restaurant>(tableView: tableView) { tableVmliew, indexPath, restaurant in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! RestaurantTableViewCell
            cell.nameLabel.text = restaurant.name
            cell.typeLabel.text = restaurant.type
            cell.locationLabel.text = restaurant.location
            cell.thumbnailImageView.image = UIImage(named: restaurant.image)
            if restaurant.isFavorite {
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
        let title = self.restaurants[indexPath.row].isFavorite ? "Undo Checkin" : "Mark as favorite"
        let favoriteAction = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
            // 1. 更新本地数据源 (这一步是必须的)
            self.restaurants[indexPath.row].isFavorite.toggle()
            
            // 2. 创建一个新的 Snapshot
            // 既然数据变了（Struct hash 变了），我们直接告诉系统：“这是现在的全新数据状态”
            var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
            snapshot.appendSections([.all])
            snapshot.appendItems(self.restaurants)
            
            // 3. 应用 Snapshot
            // animatingDifferences 设为 false，这样更新会很干脆，不会出现奇怪的删除/插入动画
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
        optionMenu.addAction(favoriteAction)
        
        //cancel选项
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
        
        //取消选择
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum Section {
    case all
}
