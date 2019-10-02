//
//  ListSearchViewController.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/30/19.
//

import Foundation
import UIKit

/// Allow search restaurants by name.
final class ListSearchViewController: UIViewController {
    var nearbyRestaurantsCells = [RestaurantElement]()
    var filteredNearbyRestaurants = [RestaurantElement]()
    /// Flag that lets you know if the user is searching through searchBar.
    private var isSearching = false
    /// Settings for tableView.
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.placeholder = SearchViewText.placeHolderTitle.localized
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.contentMode = .center
        searchBar.delegate = self
        return searchBar
    }()
    private var iconLocation: UIImageView = {
        let iconLocation = UIImageView()
        iconLocation.image = UIImage(named: "nearMeIcon")
        return iconLocation
    }()
    
    private var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = UIFont(name: Constants.Font.forTitleBold,
                                    size: 18.0)
        locationLabel.textColor = .black
        locationLabel.backgroundColor = .red
        locationLabel.numberOfLines = 0
        locationLabel.text = "20 W 34th St, New York, NY 10001, United States"
        return locationLabel
    }()
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect.zero)
        activityIndicatorView.color = .mustard
        return activityIndicatorView
    }()
    let floatZero: CGFloat = 0
    /// Indicates the estimatedRowHeight for every row.
    private var rowHeight: CGFloat = 205
    // Enum that helps to order by section the data.
    ///
    /// - topCategories: topCategories
    /// - mostPopular: mostPopular
    /// - restaurants: restaurants
    enum ListSearchSections: Int, CaseIterable {
        case recentlyViewed
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerTableViewCells()
        setupDesignViews()
        getRecentViewedData(completion: {
            [weak self] (isReady) in
            guard let self = self else { return }
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBar()
    }
    
    /// Get the RecentViewedData from persistence data.
    ///
    /// - Returns: [Int]
    private func getPersistentData() -> [Int] {
        let defaultsReviewData = UserDefaults.standard
        return defaultsReviewData.object(forKey: Constants.PersistentData.recentViewed) as? [Int] ?? [Int]()
    }
    
    /// Call the web service to return the restaurant Data with the Id´is obtained with the persistence data.
    ///
    /// - Parameter completion: Bool
    private func getRecentViewedData(completion: @escaping (Bool) -> Void) {
        let parameterIds = getPersistentData()
        let dipatchGroup = DispatchGroup()
        activityIndicatorView.startAnimating()
        for restaurantId in parameterIds {
            dipatchGroup.enter()
            ApiManager.fetchRestaurantWith(resId: restaurantId) {
                [weak self] (resultResponse)  in
                guard let self = self else { return }
                switch resultResponse {
                case .success(let response):
                    let restaurantSaved: RestaurantElement = RestaurantElement(restaurant: response)
                    self.filteredNearbyRestaurants.append(restaurantSaved)
                    dipatchGroup.leave()
                case .failure(let error):
                    #if DEBUG
                    print("Error loading service: \(error.localizedDescription)")
                    #endif
                }
            }
        }
        dipatchGroup.notify(queue: DispatchQueue.main) {
            completion(true)
        }
    }
    
    /// Configure the NavigationBar in TabBarViewController.
    private func setupNavBar() {
        title = SearchViewText.searchRestaurantsTitle.localized
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.mustard
        view.backgroundColor = .white
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
    }
    
    private func registerTableViewCells() {
        tableView.register(RestaurantGenericViewCell.self,
                           forCellReuseIdentifier: RestaurantGenericViewCell.reuseIdentifier)
    }
    
    /// Functions for the configuration of the HomeViewController Views.
    private func setupDesignViews() {
        addSubViews()
        setupSearchBarConstraints()
        setupIconLocationImage()
        setupLocationLabel()
        setupTableViewConstraints()
        setupActivityIndicator()
    }
    
    /// Add all the views to the main view.
    private func addSubViews() {
        view.addSubview(searchBar)
        view.addSubview(iconLocation)
        view.addSubview(tableView)
        view.addSubview(locationLabel)
        view.addSubview(activityIndicatorView)
        view.bringSubviewToFront(activityIndicatorView)
    }
    
    private func setupSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    private func setupIconLocationImage() {
        iconLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLocation.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            iconLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            iconLocation.widthAnchor.constraint(equalToConstant: 20),
            iconLocation.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    private func setupLocationLabel() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 10),
            locationLabel.widthAnchor.constraint(equalToConstant: 200),
            locationLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: iconLocation.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)])
    }
    private func setupActivityIndicator() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
}

extension ListSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : ListSearchSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? nearbyRestaurantsCells.count : filteredNearbyRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = isSearching ? nearbyRestaurantsCells[indexPath.row].restaurant : filteredNearbyRestaurants[indexPath.row].restaurant
        let nearbyCell: RestaurantGenericViewCell = tableView.dequeue(for: indexPath)
        nearbyCell.fillData(using: model)
        return nearbyCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let searchBarText = searchBar.text,
            searchBarText.isEmpty {
            let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
            titleLabel.font = UIFont(name: Constants.Font.forTitleBold,
                                     size: 20.0)
            titleLabel.textColor = .blackCustom
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30.0))
            headerView.backgroundColor = .headerGray
            headerView.addSubview(titleLabel)
            switch section {
            case ListSearchSections.recentlyViewed.rawValue:
                titleLabel.text = SearchViewText.recentlyViewedTitle.localized
                return headerView
            default:
                titleLabel.text = ""
                return headerView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let searchBarText = searchBar.text,
            searchBarText.isEmpty {
            return Constants.Header.height
        } else {
            return floatZero
        }
    }
}

extension ListSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailProductViewController()
        let model = isSearching ? nearbyRestaurantsCells[indexPath.row].restaurant : filteredNearbyRestaurants[indexPath.row].restaurant
        detailVC.productData = model
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListSearchViewController: UISearchBarDelegate {
    private func searchMealOrRestaurant(keyWordSearch: String) {
        ApiManager.fetchSearchWithKeyWord(keyWord: keyWordSearch) {
            [weak self]
            (restaurants) in
            guard let self = self else { return }
            switch restaurants {
            case .success(let restaurantsSearch):
                self.nearbyRestaurantsCells = restaurantsSearch.restaurants
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        isSearching = true
        searchMealOrRestaurant(keyWordSearch: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let textTyped = searchBar.text, !textTyped.isEmpty {
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textTyped = searchBar.text, !textTyped.isEmpty {
            filterContentForSearchText(textTyped)
        } else {
            isSearching = false
            tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        eraseFilterSearchData()
    }
    
    private func eraseFilterSearchData() {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        nearbyRestaurantsCells.removeAll()
        tableView.reloadData()
    }
}

extension ListSearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchBarText = searchBar.text {
            filterContentForSearchText(searchBarText)
        }
    }
}

