//
//  DetailProductViewController.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/30/19.
//

import Foundation
import UIKit
import MapKit

final class DetailProductViewController: UIViewController {
    var nearbyProductData: NearbyRestaurant? = nil
    var productData: RestaurantData? = nil
    var coordinateRestaurant: CLLocationCoordinate2D?
    private let screensize: CGRect = UIScreen.main.bounds
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    private var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = true
        return containerView
    }()
    private let headerImageView: UIImageView = {
        let pictureImageView = UIImageView()
        pictureImageView.image = UIImage(named: Constants.PlaceHolder.generalForFood)
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        return pictureImageView
    }()
    private let cuisineTypeLabel: UILabel = {
        let cuisineTypeLabel = UILabel()
        cuisineTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        cuisineTypeLabel.textColor = .greenShine
        cuisineTypeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cuisineTypeLabel.numberOfLines = 0
        return cuisineTypeLabel
    }()
    private let restaurantTitleLabel: UILabel = {
        let recipeTitleLabel = UILabel()
        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeTitleLabel.textColor = .black
        recipeTitleLabel.numberOfLines = 0
        recipeTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        return recipeTitleLabel
    }()
    private let ratingTextLabel: UILabel = {
        let ratingTextLabel = UILabel()
        ratingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingTextLabel.textColor = .black
        ratingTextLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return ratingTextLabel
    }()
    private let priceRangeLabel: UILabel = {
        let priceRangeLabel = UILabel()
        priceRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceRangeLabel.textColor = UIColor.darkGray
        priceRangeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        return priceRangeLabel
    }()
    private let isDeliveringNowLabel: UILabel = {
        let isDeliveringNowLabel = UILabel()
        isDeliveringNowLabel.translatesAutoresizingMaskIntoConstraints = false
        isDeliveringNowLabel.textColor = .black
        isDeliveringNowLabel.text = "Is Delivering Now:"
        return isDeliveringNowLabel
    }()
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = UIColor.mustard
        locationLabel.font = UIFont.boldSystemFont(ofSize: 18)
        locationLabel.numberOfLines = 0
        return locationLabel
    }()
    private let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = UIColor.darkGray
        addressLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addressLabel.numberOfLines = 0
        return addressLabel
    }()
    private let howToArriveButton: UIButton = {
        let howToArriveButton = UIButton()
        howToArriveButton.translatesAutoresizingMaskIntoConstraints = false
        howToArriveButton.backgroundColor = .mustard
        howToArriveButton.setTitle(DetailViewText.buttonDirectionsTitle.localized, for: .normal)
        howToArriveButton.addTarget(self, action: #selector(howToArriveAction), for: .touchUpInside)
        howToArriveButton.layer.masksToBounds = true
        howToArriveButton.layer.cornerRadius = 10
        howToArriveButton.isUserInteractionEnabled = true
        return howToArriveButton
    }()
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.isUserInteractionEnabled = true
        shareButton.setImage(UIImage(named: "shareIcon"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        return shareButton
    }()
}

extension DetailProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationController()
        addSubViews()
        setupConstraintViews()
        loadDetailData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBar()
    }
    
    private func saveSoftData(restaurantId: Int) {
        guard !getPersistentData().contains(restaurantId) else { return }
        if getPersistentData().isEmpty {
            UserDefaults.standard.set([restaurantId], forKey: Constants.PersistentData.recentViewed)
        } else {
            var restaurantIds = getPersistentData()
            if restaurantIds.count <= 10 {
                restaurantIds.append(restaurantId)
            } else {
                restaurantIds[0] = restaurantId
            }
            UserDefaults.standard.set(restaurantIds, forKey: Constants.PersistentData.recentViewed)
        }
    }
    
    private func getPersistentData() -> [Int] {
        let defaultsReviewData = UserDefaults.standard
        return defaultsReviewData.object(forKey: Constants.PersistentData.recentViewed) as? [Int] ?? [Int]()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.mustard
    }
    
    private func addSubViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(headerImageView)
        containerView.addSubview(cuisineTypeLabel)
        containerView.addSubview(restaurantTitleLabel)
        containerView.addSubview(ratingTextLabel)
        containerView.addSubview(priceRangeLabel)
        containerView.addSubview(locationLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(howToArriveButton)
        containerView.addSubview(shareButton)
    }
    
    private func setupConstraintViews() {
        setupScrollview()
        setupContainerView()
        setupConstraintsPictureImage()
        setupConstraintsCuisineLabel()
        setupConstraintsrRestaurantTitleLabel()
        setupConstraintsRatingTextLabel()
        setupConstraintsPriceRangeLabel()
        setupConstraintsLocationLabel()
        setupConstraintsAddressLabel()
        setupConstraintsArriveButton()
        setupConstraintsShareButton()
    }

    private func setupScrollview() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),])
    }
    
    private func setupConstraintsPictureImage() {
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 250),
            headerImageView.widthAnchor.constraint(equalToConstant: screensize.width)])
    }
    
    private func setupConstraintsrRestaurantTitleLabel() {
        restaurantTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restaurantTitleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 15),
            restaurantTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            restaurantTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)])
    }
    
    private func setupConstraintsRatingTextLabel() {
        ratingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingTextLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 15),
            ratingTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            ratingTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)])
    }
    
    
    private func setupConstraintsCuisineLabel() {
        cuisineTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cuisineTypeLabel.topAnchor.constraint(equalTo: ratingTextLabel.bottomAnchor, constant: 15),
            cuisineTypeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            cuisineTypeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)])
    }
    
    private func setupConstraintsPriceRangeLabel() {
        priceRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceRangeLabel.topAnchor.constraint(equalTo: cuisineTypeLabel.bottomAnchor, constant: 15),
            priceRangeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            priceRangeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)])
    }
    
    private func setupConstraintsLocationLabel() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: priceRangeLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)])
    }
    
    private func setupConstraintsAddressLabel() {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)])
    }
    
    private func setupConstraintsArriveButton() {
        howToArriveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            howToArriveButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            howToArriveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            howToArriveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            howToArriveButton.heightAnchor.constraint(equalToConstant: 42)])
    }
    
    private func setupConstraintsShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 15),
            shareButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            shareButton.heightAnchor.constraint(equalToConstant: 32),
            shareButton.widthAnchor.constraint(equalToConstant: 32)])
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        title = nearbyProductData?.restaurant.name ?? productData?.name
    }
    
    @objc
    func shareAction() {
        if let urlRestaurant = nearbyProductData != nil ? nearbyProductData?.restaurant.url : productData?.url {
            let activityViewController = UIActivityViewController(activityItems: [urlRestaurant], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc
    func howToArriveAction() {
        guard let coordinateRestaurant = coordinateRestaurant else { return }
        let regionDistance: CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegion(center: coordinateRestaurant,
                                            latitudinalMeters: regionDistance,
                                            longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinateRestaurant)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurantTitleLabel.text
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func loadDetailData() {
        if let productData = productData {
            fillDataWith(productData: productData)
        } else if let nearbyProductData = nearbyProductData {
            fillDataWith(nearbyRestaurantData: nearbyProductData)
        }
    }
    
    private func fillDataWith(productData: RestaurantData) {
        restaurantTitleLabel.text = productData.name
        cuisineTypeLabel.text = productData.cuisines
        ratingTextLabel.text = "Excellent"
        let isDeliveringNow: String = productData.isDeliveringNow == 0 ? "Yes" : "No"
        isDeliveringNowLabel.text =  isDeliveringNowLabel.text ?? "" + isDeliveringNow
        locationLabel.text = DetailViewText.locationLabelTitle.localized + productData.location.localityVerbose
        addressLabel.text = DetailViewText.addresslabelTitle.localized + productData.location.address
        if let productDataId = Int(productData.id) {
            saveSoftData(restaurantId: productDataId)
        }
        if let url = URL(string: productData.featuredImage) {
            headerImageView.loadImage(url: url)
        }
        let latitude = Double(productData.location.latitude)
        let longitude = Double(productData.location.longitude)
        if let latitude = latitude, let longitude = longitude {
            coordinateRestaurant = CLLocationCoordinate2D(latitude: latitude,
                                                          longitude: longitude)
        }
    }
    
    private func fillDataWith(nearbyRestaurantData: NearbyRestaurant) {
        restaurantTitleLabel.text = nearbyRestaurantData.restaurant.name
        cuisineTypeLabel.text = nearbyRestaurantData.restaurant.cuisines
        ratingTextLabel.text = nearbyRestaurantData.restaurant.userRating.ratingText
        locationLabel.text = DetailViewText.locationLabelTitle.localized +  nearbyRestaurantData.restaurant.location.localityVerbose
        addressLabel.text = DetailViewText.addresslabelTitle.localized + nearbyRestaurantData.restaurant.location.address
        let isDeliveringNow: String = nearbyRestaurantData.restaurant.isDeliveringNow == 0 ? "Yes" : "No"
        isDeliveringNowLabel.text =  isDeliveringNowLabel.text ?? "" + isDeliveringNow
        if let productDataId = Int(nearbyRestaurantData.restaurant.id) {
            saveSoftData(restaurantId: productDataId)
        }
        if let url = URL(string: nearbyRestaurantData.restaurant.featuredImage) {
            headerImageView.loadImage(url: url)
        }
        let latitude = Double(nearbyRestaurantData.restaurant.location.latitude)
        let longitude = Double(nearbyRestaurantData.restaurant.location.longitude)
        if let latitude = latitude, let longitude = longitude {
            coordinateRestaurant = CLLocationCoordinate2D(latitude: latitude,
                                                          longitude: longitude)
        }
    }
}

