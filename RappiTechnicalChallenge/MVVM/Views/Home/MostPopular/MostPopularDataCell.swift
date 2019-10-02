//
//  MostPopularDataCell.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

final class MostPopularDataCell: UICollectionViewCell {
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        return containerView
    }()
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.PlaceHolder.generalForFood)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        return imageView
    }()
    
    private let restaurantTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.subtitleBold, size: 16.0)
        label.textColor = .blackCustom
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.subtitleBold, size: 14.0)
        label.textColor = .blackCustom
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(restaurantImageView)
        containerView.addSubview(restaurantTitleLabel)
        containerView.addSubview(categoryLabel)
    }
    
    private func setupViews() {
        setupContainerView()
        setupRestaurantImageView()
        setupRestaurantTitleLabel()
        setupCategoryLabel()
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            containerView.widthAnchor.constraint(equalToConstant: 256)
            ])
    }
    
    private func setupRestaurantImageView() {
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            restaurantImageView.widthAnchor.constraint(equalToConstant: 256),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 140)
            ])
    }
    
    private func setupRestaurantTitleLabel() {
        restaurantTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restaurantTitleLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 10),
            restaurantTitleLabel.centerXAnchor.constraint(equalTo: restaurantImageView.centerXAnchor)
            ])
    }

    private func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            ])
    }
    
    /// Fill the visual elements of the view with information.
    ///
    /// - Parameter model: restaurantPuppyModel
    func fillData(using model: RestaurantModel) {
        restaurantTitleLabel.text = model.title
        categoryLabel.text = model.description
        if let urlImage = URL(string: model.imageUrl) {
            restaurantImageView.loadImage(url: urlImage)
        }
    }
}
