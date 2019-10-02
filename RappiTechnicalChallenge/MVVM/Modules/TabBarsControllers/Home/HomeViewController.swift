//
//  HomeViewController.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation
import UIKit
import CoreLocation

/// Class that show the general view for the user.
final class HomeViewController: UIViewController {
    /// Configure UIView container Location deliver.
    private var containerLocationView: UIView = {
        let containerDeliverView = UIView()
        containerDeliverView.backgroundColor = .blackCustom
        containerDeliverView.layer.masksToBounds = true
        containerDeliverView.layer.cornerRadius = 25
        containerDeliverView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return containerDeliverView
    }()
    /// Configure UIView container establisments and restaurants.
    private var containerTableView: UIView = {
        let containerTableView = UIView()
        containerTableView.backgroundColor = .whiteGray
        containerTableView.layer.masksToBounds = true
        containerTableView.layer.cornerRadius = 15
        return containerTableView
    }()
    /// Configure deliver Label "Entregar en".
    private var locationLabel: UILabel = {
        let deliverLabel = UILabel()
        deliverLabel.text = HomeViewText.allPlacesTitle.localized
        deliverLabel.font = UIFont(name: Constants.Font.subtitleBold,
                                   size: 15.0)
        deliverLabel.textColor = .grayPosh
        return deliverLabel
    }()
    /// Configure deliver Label Value "Address sample".
    private var locationLabelValue: UILabel = {
        let deliverLabel = UILabel()
        deliverLabel.font = UIFont(name: Constants.Font.forTitleBold,
                                   size: 18.0)
        deliverLabel.textColor = .white
        deliverLabel.numberOfLines = 0
        deliverLabel.text = "20 W 34th St, New York, NY 10001, United States"
        return deliverLabel
    }()
    /// Indicates the estimatedRowHeight for every row.
    private var rowHeight: CGFloat = 205
    /// Settings for tableView.
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    let indexZero: Int = 0
    /// Save the data to show in every row of the tableView.
    private lazy var cells: [[Decodable]] = [[Decodable]]()
    /// Enum that helps to order by section the data.
    ///
    /// - topCategories: topCategories
    /// - mostPopular: mostPopular
    /// - restaurants: restaurants
    enum HomeSections: Int, CaseIterable {
        case topCategories
        case mostPopular
        case restaurants
    }
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect.zero)
        activityIndicatorView.color = .mustard
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerTableViewCells()
        setupDesignViews()
        setupLoadData(completion: {
            [weak self] (homeData) in
            guard let self = self else { return }
            self.cells = homeData
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    private func setupTableView() {
        cells = [[Decodable]](repeating: [Decodable](), count: HomeSections.restaurants.rawValue + 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
    }
    
    // Mark: Fetch HomeData
    private func setupLoadData(completion: @escaping ([[Decodable]]) -> () ) {
        var homeData = [[Decodable]](repeating: [Decodable](), count: HomeSections.restaurants.rawValue + 1)
        let dipatchGroup = DispatchGroup()
        activityIndicatorView.startAnimating()
        dipatchGroup.enter()
        ApiManager.fetchCategories {
            (resultResponse) in
            switch resultResponse {
            case .success(let modelCategories):
                DispatchQueue.main.async {
                    homeData[HomeSections.topCategories.rawValue].append(modelCategories.categories)
                    dipatchGroup.leave()
                }
                break
            case .failure(let error):
                #if DEBUG
                print("Error loading service: \(error.localizedDescription)")
                #endif
            }
        }
        dipatchGroup.enter()
        ApiManager.fetchMostPopular {
            (resultResponse) in
            switch resultResponse {
            case .success(let mostPopularModel):
                DispatchQueue.main.async {
                    homeData[HomeSections.mostPopular.rawValue].append(mostPopularModel.collections)
                    dipatchGroup.leave()
                }
                break
            case .failure(let error):
                #if DEBUG
                print("Error loading service: \(error.localizedDescription)")
                #endif
            }
        }
        dipatchGroup.enter()
        let coordinatesNYC = CLLocationCoordinate2D(latitude: Constants.Location.latitude,
                                                    longitude: Constants.Location.longitude)
        ApiManager.fetchEstablishmentsWithLocation(coordinates: coordinatesNYC) {
            (resultResponse) in
            switch resultResponse {
            case .success(let restaurantsNearby):
                DispatchQueue.main.async {
                    homeData[HomeSections.restaurants.rawValue].append(restaurantsNearby.nearbyRestaurants)
                    dipatchGroup.leave()
                }
                break
            case .failure(let error):
                #if DEBUG
                print("Error loading service: \(error.localizedDescription)")
                #endif
            }
        }
        dipatchGroup.notify(queue: DispatchQueue.main) {
            completion(homeData)
        }
    }
    
    // Mark: Interface settings (View)
    /// Functions for the configuration of the HomeViewController Views.
    private func setupDesignViews() {
        addSubViews()
        setupContainerDeliverView()
        setupContainerTableView()
        setupTableViewConstraints()
        setupLocationLabel()
        setupLocationLabelValue()
        setupActivityIndicator()
    }
    
    /// Add all the views to the main view.
    private func addSubViews() {
        view.backgroundColor = .white
        containerTableView.backgroundColor = .whiteGray
        view.addSubview(containerLocationView)
        view.addSubview(containerTableView)
        containerTableView.addSubview(tableView)
        containerLocationView.addSubview(locationLabel)
        containerLocationView.addSubview(locationLabelValue)
        view.addSubview(activityIndicatorView)
        view.bringSubviewToFront(activityIndicatorView)
    }
    
    private func setupContainerDeliverView() {
        containerLocationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerLocationView.topAnchor.constraint(equalTo: view.topAnchor),
            containerLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerLocationView.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    private func setupContainerTableView() {
        containerTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerTableView.topAnchor.constraint(equalTo: containerLocationView.bottomAnchor, constant: -45),
            containerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            containerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            containerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)])
    }
    
    private func setupLocationLabel() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: containerLocationView.topAnchor, constant: 35),
            locationLabel.leadingAnchor.constraint(equalTo: containerLocationView.leadingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: containerLocationView.trailingAnchor, constant: -50)])
    }
    
    private func setupLocationLabelValue() {
        locationLabelValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabelValue.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            locationLabelValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            locationLabelValue.trailingAnchor.constraint(equalTo: containerLocationView.trailingAnchor, constant: -50)])
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerTableView.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerTableView.bottomAnchor, constant: -10)])
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

    private func registerTableViewCells() {
        tableView.register(CategoryViewCell.self,
                           forCellReuseIdentifier: CategoryViewCell.reuseIdentifier)
        tableView.register(MostPopularCell.self,
                           forCellReuseIdentifier: MostPopularCell.reuseIdentifier)
        tableView.register(RestaurantGenericViewCell.self,
                           forCellReuseIdentifier: RestaurantGenericViewCell.reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSections.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == HomeSections.restaurants.rawValue,
            !cells[section].isEmpty,
            let countRows = cells[section][indexZero] as? [Decodable] {
            return countRows.count
        }
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == HomeSections.topCategories.rawValue {
            let model = cells[indexPath.section][indexPath.row]
            let categoryCell: CategoryViewCell = tableView.dequeue(for: indexPath)
            categoryCell.delegate = self
            categoryCell.fillData(using: model)
            return categoryCell
        } else if indexPath.section == HomeSections.mostPopular.rawValue {
            let model = cells[indexPath.section][indexPath.row]
            let mostPopularCell: MostPopularCell = tableView.dequeue(for: indexPath)
            mostPopularCell.delegate = self
            mostPopularCell.fillData(using: model)
            return mostPopularCell
        } else {
            if var model = cells[indexPath.section][indexZero] as? [NearbyRestaurant] {
                let modelR = model[indexPath.row].restaurant
                let nearbyCell: RestaurantGenericViewCell = tableView.dequeue(for: indexPath)
                nearbyCell.fillData(using: modelR)
                return nearbyCell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailProductViewController()
        if var model = cells[indexPath.section][indexZero] as? [NearbyRestaurant] {
            let modelR = model[indexPath.row]
            detailVC.nearbyProductData = modelR
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        titleLabel.font = UIFont(name: Constants.Font.forTitleBold,
                                 size: 22.0)
        titleLabel.textColor = .blackCustom
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30.0))
        headerView.backgroundColor = UIColor.headerGray
        headerView.addSubview(titleLabel)
        switch section {
        case HomeSections.topCategories.rawValue:
            titleLabel.text = HomeViewText.topCategoriesTitle.localized
            return headerView
        case HomeSections.mostPopular.rawValue:
            titleLabel.text = HomeViewText.mostPopularTitle.localized
            return headerView
        case HomeSections.restaurants.rawValue:
            titleLabel.text = HomeViewText.restaurantsTitle.localized
            return headerView
        default:
            titleLabel.text = ""
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.Header.height
    }
}

// MARK: - CategoryViewCellDelegate
extension HomeViewController: CategoryViewCellDelegate {
    func didSelectCategory(idCategory: Int, categoryName: String) {
        let categoryViewController = RestaurantsTypeViewController()
        categoryViewController.typeToFetchId = .isCategoryId
        categoryViewController.categoryId = idCategory
        categoryViewController.titleCategoryName = categoryName
        navigationController?.pushViewController(categoryViewController,
                                                 animated: true)
    }
}

// MARK: - MostPopularCellDelegate
extension HomeViewController: MostPopularCellDelegate {
    func didSelectMostPopular(model: RestaurantModel) {
        let categoryViewController = RestaurantsTypeViewController()
        categoryViewController.titleCategoryName = model.title
        categoryViewController.typeToFetchId = .isCollectionId
        categoryViewController.collectionId = model.collectionId
        navigationController?.pushViewController(categoryViewController,
                                                 animated: true)
    }
}
