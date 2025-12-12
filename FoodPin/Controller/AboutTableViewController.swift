//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by  He on 2025/12/12.
//

import UIKit

enum AboutSection {
    case feedback
    case followus
}

struct LinkItem: Hashable {
    var text: String
    var link: String
    var image: String
}

class AboutTableViewController: UITableViewController {
    
    var sectionContent = [
        [
            LinkItem(text: "Rate us on App Store", link: "https://www.apple.com/ios/app-store/", image: "store"),
            LinkItem(text: "Tell us your feedback", link: "http://www.appcoda.com/contact", image: "chat")
        ],
        [
            LinkItem(text: "Twitter", link: "https://twitter.com/appcodamobile", image: "twitter"),
            LinkItem(text: "Facebook", link: "https://facebook.com/appcodamobile", image: "facebook"),
            LinkItem(text: "Instagram", link: "https://www.instagram.com/appcodadotcom", image: "instagram")]
    ]
    
    lazy var dataSource = configureDataSource()
    
    func configureDataSource() -> UITableViewDiffableDataSource<AboutSection, LinkItem> {
        let cellIdentifier = "aboutcell"
        let datasource = UITableViewDiffableDataSource<AboutSection, LinkItem>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = item.text
            cell.imageView?.contentMode = .scaleAspectFit
            
            let originalImage = UIImage(named: item.image)
            let targetSize = CGSize(width: 20, height: 20)
            
            // 缩放并重新绘制图片到目标尺寸
            if let originalImage = originalImage {
                let resizedImage = UIGraphicsImageRenderer(size: targetSize).image { _ in
                    originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
                }
                cell.imageView?.image = resizedImage
            }
            
            return cell
        }
        return datasource
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<AboutSection, LinkItem>()
        
        snapshot.appendSections([.feedback, .followus])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .followus)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //开启大标题
        navigationController?.navigationBar.prefersLargeTitles = true
        //设置导航栏UI
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        tableView.dataSource = dataSource
        updateSnapshot()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
//        if let url = URL(string: linkItem.link) {
//            UIApplication.shared.open(url)//在Safari浏览器打开该链接
//        }
        
        performSegue(withIdentifier: "showWebView", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView",
           let destination = segue.destination as? WebViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           let linkItem = self.dataSource.itemIdentifier(for: indexPath){
            destination.targetURL = linkItem.link
        }
    }
}
