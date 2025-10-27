import UIKit
import Foundation
import SnapKit

class TabBarController: UITabBarController {
    
    let searchVC = SearchViewController()
    let shelfVC = BookShelfController()
    let appearance = UITabBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTab()
        addCenterDivider()
    }

    
    private func customTab() {
        
        searchVC.tabBarItem = UITabBarItem(
            title: "책 찾기",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        searchVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        searchVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        
        
        shelfVC.tabBarItem = UITabBarItem(
            title: "내 책장",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "books.vertical.fill")
        )
        shelfVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        shelfVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        
        let searchNav = UINavigationController(rootViewController: searchVC)
        let shelfNav = UINavigationController(rootViewController: shelfVC)
        
        
        viewControllers = [searchNav, shelfNav]

  
   
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(named: "TabBarColor")
        
        
      
        let normal = appearance.stackedLayoutAppearance.normal
        normal.iconColor = .black
        normal.titleTextAttributes = [ .foregroundColor: UIColor.black ]
       
        
        let selected = appearance.stackedLayoutAppearance.selected
        selected.iconColor = UIColor(named: "MainColor")
        selected.titleTextAttributes = [.foregroundColor: UIColor(named: "MainColor") ?? .main]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
       
    }
    
    private func addCenterDivider() {
        let divider = UIView()
        divider.backgroundColor = .systemGray3
        divider.isUserInteractionEnabled = false
        tabBar.addSubview(divider)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
              divider.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
              divider.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -12), // 살짝 위로
              divider.widthAnchor.constraint(equalToConstant: 1),   // 두께
              divider.heightAnchor.constraint(equalToConstant: 40)  // 길이 (원하는 높이로)
          ])

          divider.layer.cornerRadius = 0.5
          divider.layer.masksToBounds = true
    }
}
