//
//  MapSearchViewController.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/30/19.
//

import Foundation
import GoogleMaps

/// Shows a map with all the restaurants near of you.
final class SearchViewController: UIViewController {
    /// Configure UIView container Location..
    private var googleMapView: GMSMapView = {
        let googleMapView = GMSMapView()
        return googleMapView
    }()
    /// Configure UIView for searchung
    private var containerSearchView: UIView = {
        let containerCategoryView = UIView()
        containerCategoryView.backgroundColor = .blackCustom
        containerCategoryView.layer.masksToBounds = true
        containerCategoryView.layer.cornerRadius = 15
        containerCategoryView.layer.opacity = 1.0
        return containerCategoryView
    }()
    /// Configure UIView container establisments and restaurants.
    private var containerMenuView: UIView = {
        let containerMenuView = UIView()
        containerMenuView.backgroundColor = .white
        containerMenuView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        return containerMenuView
    }()
    /// Settings for tableView.
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    private var menuButton: UIButton = {
        let menuButton = UIButton()
        menuButton.titleLabel?.font = UIFont(name: Constants.Font.normal, size: 12.0)
        menuButton.backgroundColor = .mustard
        menuButton.layer.masksToBounds = true
        menuButton.layer.cornerRadius = 10
        menuButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return menuButton
    }()
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect.zero)
        activityIndicatorView.color = .mustard
        return activityIndicatorView
    }()
    /// Indicates the estimatedRowHeight for every row.
    private var rowHeight: CGFloat = 205
    private let isOpenMenu = false
    private let heightMenuContainerOpen: CGFloat = 230
    private let heightMenuContainerClose: CGFloat = 60
    private lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect.zero)
    private var isSearching = false
    private lazy var nearbyRestaurants = [NearbyRestaurant]()
    private lazy var googlePlacesFetched = [GooglePlace]()
    private var isSelectedPin = false
    var heightAnchorMenu: NSLayoutConstraint!
    
    override func viewDidLoad() {
        setupDesignViews()
        setupTableView()
        setupMapView()
        setupSettingsSearchBar()
        fetchNearbyPlaces(coordinates: CLLocationCoordinate2D(latitude: Constants.Location.latitude,
                                                             longitude: Constants.Location.longitude))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
        registerTableViewCells()
    }
    
    // Mark: Interface settings (View)
    /// Functions for the configuration of the HomeViewController Views.
    private func setupDesignViews() {
        addSubViews()
        setupContainerMapView()
        setupContainerCategoryView()
        setupConstraintsSearchBar()
        setupMenuView()
        setupTableViewConstraints()
        setupMenuButton()
        setupActivityIndicator()
    }
    
    private func addSubViews() {
        view.backgroundColor = .white
        view.addSubview(googleMapView)
        view.addSubview(containerSearchView)
        view.addSubview(menuButton)
        view.addSubview(containerMenuView)
        containerMenuView.addSubview(tableView)
        containerSearchView.addSubview(searchBar)
        view.addSubview(activityIndicatorView)
    }
    
    private func setupSettingsSearchBar() {
        searchBar.placeholder = SearchViewText.placeHolderTitle.localized
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.contentMode = .center
    }
    
    private func setupContainerMapView() {
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: view.topAnchor),
            googleMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupContainerCategoryView(topView: CGFloat = 15,
                                            leadingView: CGFloat = 15,
                                            trailingView: CGFloat = -15,
                                            heightView: CGFloat = 50) {
        containerSearchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerSearchView.topAnchor.constraint(equalTo: view.topAnchor, constant: topView),
            containerSearchView.heightAnchor.constraint(equalToConstant: heightView),
            containerSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            containerSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
    }
    
    private func setupConstraintsSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: containerSearchView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: containerSearchView.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: containerSearchView.trailingAnchor, constant: -5)])
    }
    
    private func setupMenuView() {
        containerMenuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        heightAnchorMenu = containerMenuView.heightAnchor.constraint(equalToConstant: heightMenuContainerOpen)
        heightAnchorMenu?.isActive = true
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerMenuView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerMenuView.bottomAnchor, constant: -10)])
    }
    
    private func setupMenuButton() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            menuButton.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            menuButton.bottomAnchor.constraint(equalTo: containerMenuView.topAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 42)])
        setupGestureToMenuView()
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    private func registerTableViewCells() {
        tableView.register(RestaurantGenericViewCell.self,
                           forCellReuseIdentifier: RestaurantGenericViewCell.reuseIdentifier)
    }
    
    private func setupGestureToMenuView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickMenuButton))
        menuButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func onClickMenuButton() {
        let heightAnchorContainer: CGFloat
        heightAnchorContainer = containerMenuView.bounds.height <= heightMenuContainerClose ? heightMenuContainerOpen : heightMenuContainerClose
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.heightAnchorMenu.constant = heightAnchorContainer
        }, completion: nil)
    }
    
    /// Configure MapView
    private func setupMapView() {
        googleMapView.delegate = self
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        googleMapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: Constants.Location.latitude,
                                                                                longitude: Constants.Location.longitude),
                                                 zoom: 15,
                                                 bearing: 0,
                                                 viewingAngle: 0)
    }
    
    private func fetchNearbyPlaces(coordinates: CLLocationCoordinate2D) {
        activityIndicatorView.startAnimating()
        googleMapView.clear()
        ApiManager.fetchEstablishmentsWithLocation(coordinates: coordinates) {
            (locationsResponse) in
            switch locationsResponse {
            case .success(let restaurantsNearby):
                DispatchQueue.main.async {
                    self.nearbyRestaurants = restaurantsNearby.nearbyRestaurants
                    var places: [GooglePlace] = [GooglePlace]()
                    restaurantsNearby.nearbyRestaurants.forEach {
                        [weak self]
                        place in
                        guard let self = self else { return }
                        let placeToSave = GooglePlace(locationModel: place.restaurant)
                        places.append(placeToSave)
                        let marker = PlaceMarker(place: placeToSave)
                        marker.map = self.googleMapView
                        self.tableView.reloadData()
                        self.activityIndicatorView.stopAnimating()
                        self.containerMenuView.layoutIfNeeded()
                    }
                }
                break
            case .failure(let error):
                #if DEBUG
                print("Error loading service: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) {
            [weak self]
            response, error in
            guard let self = self else { return }
            guard let address = response?.firstResult(),
                let lines = address.lines else {
                    return
            }
            let placeTitle = SearchViewText.locationTitle.localized + lines.joined(separator: "\n")
            self.menuButton.setTitle(placeTitle, for: .normal)
            if !self.isSelectedPin {
                self.fetchNearbyPlaces(coordinates: coordinate)
            }
        }
    }
    
    private func animateMapView(coordinates: CLLocationCoordinate2D) {
        googleMapView.camera = GMSCameraPosition(target: coordinates,
                                                 zoom: 20,
                                                 bearing: 0,
                                                 viewingAngle: 0)
    }
}

// MARK: - GMSMapViewDelegate
extension SearchViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            isSelectedPin = false
            googleMapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        isSelectedPin = true
        guard let placeMarker = marker as? PlaceMarker else {
            return false
        }
        if let pinIdRestaurant = placeMarker.place.idRestaurant {
            for (idx, restaurant) in nearbyRestaurants.enumerated() {
                if Int(restaurant.restaurant.id) == pinIdRestaurant {
                    tableView.scrollToRow(at: IndexPath(row: idx, section: 0), at: .top, animated: true)
                    break
                }
            }
        }
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        isSelectedPin = false
        googleMapView.selectedMarker = nil
        return false
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        let searchListViewController = ListSearchViewController()
        navigationController?.pushViewController(searchListViewController, animated: true)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = nearbyRestaurants[indexPath.row]
        let nearbyCell: RestaurantGenericViewCell = tableView.dequeue(for: indexPath)
        nearbyCell.fillData(using: model.restaurant)
        return nearbyCell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailProductViewController()
        let modelR = nearbyRestaurants[indexPath.row]
        detailVC.nearbyProductData = modelR
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

