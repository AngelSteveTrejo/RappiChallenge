//
//  CategoryViewController.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

enum RestaurantTypeId {
    case isCategoryId
    case isCollectionId
    case none
}

final class RestaurantsTypeViewController: UIViewController {
    var typeToFetchId: RestaurantTypeId = .none
    /// Category Id to fetch the list of restaurants.
    var categoryId: Int?
    /// Collection Id to fetch the list of restaurants.
    var collectionId: Int?
    /// Configure UIView container establisments and restaurants.
    private var containerTableView: UIView = {
        let containerTableView = UIView()
        containerTableView.backgroundColor = .white
        containerTableView.layer.masksToBounds = true
        containerTableView.layer.cornerRadius = 15
        return containerTableView
    }()
    /// Indicates the estimatedRowHeight for every row.
    private var rowHeight: CGFloat = 205
    /// Settings for tableView.
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect.zero)
        activityIndicatorView.color = .mustard
        return activityIndicatorView
    }()
    /// Save the data to show in every row of the tableView.
    private lazy var restaurantsDataCells: [[Decodable]] = [[Decodable]]()
    /// String that saves the Category Restaurant Name.
    var titleCategoryName: String = ""
    /// String that saves the header Name.
    private var headerCountName: String = ""
    /// Enum that helps to order by section the data.
    ///
    /// - categoryCountName: categoryCountName example 8 restaurants - Category Night life
    enum CategorySections: Int, CaseIterable {
        case categoryCountName
    }
    
    override func viewDidLoad() {
        setupTableView()
        registerTableViewCells()
        setupDesignViews()
        fetchSearch(typeToFetchId: typeToFetchId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBar()
    }
    
    /// Configure the NavigationBar in TabBarViewController.
    private func setupNavBar() {
        title = titleCategoryName
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.mustard
    }
    
    private func setupTableView() {
        restaurantsDataCells = [[Decodable]](repeating: [Decodable](), count: CategorySections.categoryCountName.rawValue + 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
    }
    
    private func registerTableViewCells() {
        tableView.register(RestaurantGenericViewCell.self,
                           forCellReuseIdentifier: RestaurantGenericViewCell.reuseIdentifier)
    }
    
    /// Search restaurants by categoryId
    ///
    /// - Parameter categoryId: categoryId Int
    private func fetchSearch(typeToFetchId: RestaurantTypeId) {
        let idToFetch: Int?
        switch typeToFetchId {
        case .isCategoryId:
            idToFetch = categoryId
        case .isCollectionId:
            idToFetch = collectionId
        case .none:
            idToFetch = nil
        }
        activityIndicatorView.startAnimating()
        guard let fetchId = idToFetch else { return }
        ApiManager.fetchSearchWithId(fetchId: fetchId, typeId: typeToFetchId) {
            [weak self] (resultResponse)  in
            guard let self = self else { return }
            switch resultResponse {
            case .success(let response):
                DispatchQueue.main.async {
                self.restaurantsDataCells[CategorySections.categoryCountName.rawValue] = response.restaurants
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
                break
            case .failure(let error):
                #if DEBUG
                print("Error loading service: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    // Mark: Interface settings (View)
    /// Functions for the configuration of the HomeViewController Views.
    private func setupDesignViews() {
        addSubViews()
        setupContainerTableView()
        setupConstraintsTableView()
        setupActivityIndicator()
    }
    
    /// Add all the views to the main view.
    private func addSubViews() {
        view.backgroundColor = .white
        containerTableView.backgroundColor = .whiteGray
        view.addSubview(containerTableView)
        containerTableView.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        view.bringSubviewToFront(activityIndicatorView)
    }
    
    /// View constraints for tableView.
    private func setupContainerTableView() {
        containerTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerTableView.topAnchor.constraint(equalTo: view.topAnchor),
            containerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    /// View constraints for tableView.
    private func setupConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerTableView.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerTableView.bottomAnchor)])
    }
    private func setupActivityIndicator() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
}

// MARK: - UITableViewDataSource
extension RestaurantsTypeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CategorySections.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsDataCells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = restaurantsDataCells[indexPath.section][indexPath.row] as? RestaurantElement {
            let modelData = model.restaurant
            let restaurantCell: RestaurantGenericViewCell = tableView.dequeue(for: indexPath)
            restaurantCell.fillData(using: modelData)
            return restaurantCell
        }
        return UITableViewCell()
    }
}

extension RestaurantsTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailProduct = DetailProductViewController()
        if let model = restaurantsDataCells[indexPath.section][indexPath.row] as? RestaurantElement {
            detailProduct.productData = model.restaurant
            navigationController?.pushViewController(detailProduct, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        titleLabel.font = UIFont(name: Constants.Font.forTitleBold,
                                 size: 22.0)
        titleLabel.textColor = .blackCustom
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30.0))
        headerView.backgroundColor = .headerGray
        headerView.addSubview(titleLabel)
        switch section {
        case CategorySections.categoryCountName.rawValue:
            titleLabel.text = headerCountName + " " + RestaurantViewText.restaurantsTitle.localized
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
