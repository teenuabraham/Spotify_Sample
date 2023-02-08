//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Teenu Abraham on 10/02/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeViewController()
        let search = SearchViewController()
        let library = LibraryViewController()
        
        home.title = "Browse"
        search.title = "Search"
        library.title = "Library"
        
        home.navigationItem.largeTitleDisplayMode = .always
        search.navigationItem.largeTitleDisplayMode = .always
        library.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: search)
        let nav3 = UINavigationController(rootViewController: library)
        
        nav1.navigationBar.tintColor = .secondaryLabel
        nav2.navigationBar.tintColor = .secondaryLabel
        nav3.navigationBar.tintColor = .secondaryLabel
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1,nav2,nav3], animated: false)
        
        

    }
    

}
