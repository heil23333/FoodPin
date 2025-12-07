//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by  He on 2025/11/28.
//

import UIKit
import SwiftData

class RestaurantTableViewController: UITableViewController, RestaurantDataStore {
    var restaurants:[Restaurant] = []
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    var container: ModelContainer?
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground()//透明背景, 无阴影
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45), let customColor = UIColor(named: "NavigationBarTitle") {
                appearance.titleTextAttributes = [.foregroundColor: customColor]
                appearance.largeTitleTextAttributes = [.foregroundColor: customColor, .font: customFont]
            }
            //标准尺寸的导航栏
            navigationController?.navigationBar.standardAppearance = appearance
            //小尺寸导航栏
            navigationController?.navigationBar.compactAppearance = appearance
            //滚动到边缘时的导航栏
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true//大标题
        
        navigationItem.backButtonTitle = ""//得在要返回的页面设置
        
        tableView.cellLayoutMarginsFollowReadableWidth = true//自动调节cell宽度
        
        container = try? ModelContainer(for: Restaurant.self)
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140 // 给一个估算值，提高性能
        
        fetchRestaurantData()
        
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
    func fetchRestaurantData() {
        let descriptor = FetchDescriptor<Restaurant>()
        restaurants = (try? container?.mainContext.fetch(descriptor)) ?? []
        updateSnapshot()
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        let dataSource = RestaurantDiffableDataSource(tableView: tableView) { tableVmliew, indexPath, restaurant in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! RestaurantTableViewCell
            cell.nameLabel.text = restaurant.name
            cell.typeLabel.text = restaurant.type
            cell.locationLabel.text = restaurant.location
            cell.thumbnailImageView.image = restaurant.image
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
    //            self.present(alertMessage, animated: true)
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
    //        present(optionMenu, animated: true)
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
            self.restaurants.remove(at: indexPath.row)
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completeionHandle(true)//true表示动作已完成
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        //分享动作
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completeionHandle) in
            let defaultText = "Just checking in at \(restaurant.name)"
            
            var activityController: UIActivityViewController
            activityController = UIActivityViewController(activityItems: [defaultText, restaurant.image], applicationActivities: nil)
            
            //针对大屏设备优化
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true)
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
        } else if segue.identifier == "addResaurant" {
            if let navController = segue.destination as? UINavigationController, let destinationController = navController.topViewController as? NewRestaurantController {
                destinationController.dataStore = self
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
}

protocol RestaurantDataStore {
    func fetchRestaurantData()
}
