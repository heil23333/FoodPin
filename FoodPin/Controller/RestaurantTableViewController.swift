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
        navigationController?.navigationBar.prefersLargeTitles = true//大标题
        tableView.cellLayoutMarginsFollowReadableWidth = true//自动调节cell宽度

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        let dataSource = RestaurantDiffableDataSource(tableView: tableView) { tableVmliew, indexPath, restaurant in
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
    
    //MARK: - cell被选择
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//        
//        //针对iPad
//        if let popoverController = optionMenu.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }
//        
//        //reserve选项
//        let reserveActionHandler = { (action: UIAlertAction) -> Void in
//            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature is not yet available yet. Please retry later", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//            
//        }
//        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
//        optionMenu.addAction(reserveAction)
//        
//        //favorite选项
//        let title = self.restaurants[indexPath.row].isFavorite ? "Undo Checkin" : "Mark as favorite"
//        let favoriteAction = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
//            // 1. 更新本地数据源 (这一步是必须的)
//            self.restaurants[indexPath.row].isFavorite.toggle()
//            
//            // 2. 创建一个新的 Snapshot
//            // 既然数据变了（Struct hash 变了），我们直接告诉系统：“这是现在的全新数据状态”
//            var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
//            snapshot.appendSections([.all])
//            snapshot.appendItems(self.restaurants)
//            
//            // 3. 应用 Snapshot
//            // animatingDifferences 设为 false，这样更新会很干脆，不会出现奇怪的删除/插入动画
//            self.dataSource.apply(snapshot, animatingDifferences: false)
//        }
//        optionMenu.addAction(favoriteAction)
//        
//        //cancel选项
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//        
//        present(optionMenu, animated: true, completion: nil)
//        
//        //取消选择
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        let favoriteTitle = restaurant.isFavorite ? "Unfavorite" : "Favorite"
        let favoriteAction = UIContextualAction(style: .normal, title: favoriteTitle) { (action, sourceView, completeionHandle) in
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
            completeionHandle(true)
        }
        if restaurant.isFavorite {
            favoriteAction.image = UIImage(systemName: "heart.slash.fill")
        } else {
            favoriteAction.image = UIImage(systemName: "heart.fill")
        }
        favoriteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    //MARK: - 从尾部滑动的操作
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //删除动作
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completeionHandle) in
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completeionHandle(true)//true表示动作已完成
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        //分享动作
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completeionHandle) in
            let defaultText = "Just checking in at \(restaurant.name)"
            
            var activityController: UIActivityViewController
            if let image = UIImage(named: restaurant.image) {
                activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            //针对大屏设备优化
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completeionHandle(true)
        }
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.backgroundColor = .systemYellow
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailUIViewController
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
}
