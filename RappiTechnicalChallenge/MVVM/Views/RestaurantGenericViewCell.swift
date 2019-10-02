//
//  NearbyViewCell.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//

import Foundation
import UIKit

protocol NearbyViewCellDelegate {
    func didSelectNearbyRestaurant()
}

/// Shows the restaurant data for a cell.
final class RestaurantGenericViewCell: UITableViewCell {
    var delegate: NearbyViewCellDelegate?
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.PlaceHolder.generalForFood)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    private let restaurantTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.forTitleBold, size: 18.0)
        label.textColor = .blackCustom
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.subtitleBold, size: 14.0)
        label.textColor = .blackCustom
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    private let localityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.subtitleBold, size: 14.0)
        label.textColor = .blackCustom
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    private let ratingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.subtitleBold, size: 14.0)
        label.textColor = .orangeMexican
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        selectionStyle = .none
        addSubviews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupContentView()
        setupRestaurantImageView()
        setupRestaurantTitleLabel()
        setupCategoryLabel()
        setupPriceRangeLabel()
        setupRatingTextLabel()
    }
    
    private func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(restaurantImageView)
        containerView.addSubview(restaurantTitleLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(localityLabel)
        containerView.addSubview(ratingTextLabel)
    }
    
    private func setupContentView() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            containerView.heightAnchor.constraint(equalToConstant: 140),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
    }
    
    private func setupRestaurantImageView() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            restaurantImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 128),
            restaurantImageView.widthAnchor.constraint(equalToConstant: 128)
            ])
    }
    
    private func setupRestaurantTitleLabel() {
        NSLayoutConstraint.activate([
            restaurantTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            restaurantTitleLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
            restaurantTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
            ])
    }
    
    private func setupCategoryLabel() {
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
            ])
    }
    
    private func setupPriceRangeLabel() {
        NSLayoutConstraint.activate([
            localityLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            localityLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
            localityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
            ])
    }
    
    private func setupRatingTextLabel() {
        NSLayoutConstraint.activate([
            ratingTextLabel.topAnchor.constraint(equalTo: localityLabel.bottomAnchor, constant: 10),
            ratingTextLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
            ratingTextLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
            ])
    }
    
    func fillData(using nearbyRestaurantModel: NearbyRestaurantModel) {
        if let urlFeaturedImage = URL(string: nearbyRestaurantModel.featuredImage) {
            restaurantImageView.loadImage(url: urlFeaturedImage)
        }
        restaurantTitleLabel.text = nearbyRestaurantModel.name
        ratingTextLabel.text = RestaurantCellText.ratingDetailTitle.localized + nearbyRestaurantModel.userRating.ratingText
        localityLabel.text = RestaurantCellText.localityTitle.localized + String(nearbyRestaurantModel.location.localityVerbose)
        categoryLabel.text = nearbyRestaurantModel.cuisines
    }
    
    func fillData(using restaurantModel: RestaurantData) {
        if let urlFeaturedImage = URL(string: restaurantModel.featuredImage) {
            restaurantImageView.loadImage(url: urlFeaturedImage)
        }
        restaurantTitleLabel.text = restaurantModel.name
        localityLabel.text = RestaurantCellText.localityTitle.localized + String(restaurantModel.location.localityVerbose)
        categoryLabel.text = restaurantModel.cuisines
    }
}
