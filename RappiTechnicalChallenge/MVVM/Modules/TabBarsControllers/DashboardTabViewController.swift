//
//  HomeTabViewController.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation
import UIKit

/// Enum that list the TabBar options available.
///
/// - Home: General view
/// - Search: Product / Restaurant finder
/// - Profile: User profile
enum TabOptions: Int {
    case Home
    case Search
    case Profile
}

/// Class that contain all the UIViewControllers inside of the TabBarController.
final class DashboardTabViewController: UITabBarController {
    /// Allows to identify if the splashView is ready.
    private var isSplashViewLoaded = false
    
    override func viewDidLoad() {
        setViewControllersToTabViewController()
        setupSplashView()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
    }
    
    /// Show the SplashView or LaunchScreen animation
    private func setupSplashView() {
        let revealingSplashView = RappiSplashView(iconImage: UIImage(named: "rappiLogo")!,
                                                  iconInitialSize: CGSize(width: 120, height: 120),
                                                  backgroundColor: UIColor.mustard)
        view.addSubview(revealingSplashView)
        revealingSplashView.duration = 2.0
        revealingSplashView.iconColor = UIColor.mustard
        revealingSplashView.animationType = SplashAnimationType.rappi
        revealingSplashView.startAnimation() { [weak self] in
            guard let self = self else { return }
            self.isSplashViewLoaded = true
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// Configure the NavigationBar in TabBarViewController.
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    /// Setup the viewControllers to show in Rappi TabBarViewController.
    private func setViewControllersToTabViewController() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: nil,
                                                     image: UIImage(named: "homeTabItem"),
                                                     selectedImage: UIImage(named: "homeTabItem"))
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: nil,
                                                       image: UIImage(named: "searchTabItem"),
                                                       selectedImage: UIImage(named: "searchTabItem"))
        let tabBarList = [homeViewController,
                          searchViewController]
        viewControllers = tabBarList
    }
    
    /// Configure the TabBar in TabBarViewController.
    private func setupTabBar() {
        tabBar.tintColor = .mustard
    }
    
    /// Is called when the UIViewController does not has Memory leak/Retain cycle.
    deinit {
        #if DEBUG
        print("DashboardTabViewController NO Memory leak/Retain cycle")
        #endif
    }
}
