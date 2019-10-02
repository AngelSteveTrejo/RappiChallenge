//
//  CategoryDataViewCell.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit


/// View used to display each recipe.
final class CategoryDataViewCell: UICollectionViewCell {
    enum CategoryType: Int {
        case delivery = 1
        case dineOut = 2
        case nightLife = 3
        case catchingUp = 4
        case takeAway = 5
        case cafes = 6
        case dailyMenus = 7
        case breakfast = 8
        case lunch = 9
        case dinner = 10
        case pubsBars = 11
        case pocketFriendlyDelivery = 13
        case clubsLounges = 14
    }
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 22.0
        return imageView
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Font.subtitleBold, size: 16.0)
        label.textColor = .blackCustom
        label.numberOfLines = 2
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
        self.addSubview(categoryImageView)
        self.addSubview(categoryTitleLabel)
    }

    private func setupViews() {
        setupCategoryImageView()
        setupCategoryTitleLabel()
    }
   
    /// Category image constraints.
    private func setupCategoryImageView() {
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: self.topAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: 48),
            categoryImageView.widthAnchor.constraint(equalToConstant: 48),
            ])
    }
    
    /// Category title constraints.
    private func setupCategoryTitleLabel() {
        NSLayoutConstraint.activate([
            categoryTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -8),
            categoryTitleLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 8),
            categoryTitleLabel.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    /// Allows you to fill the visual elements of the view with information.
    ///
    /// - Parameter model: RecipePuppyModel
    func fillData(using model: CategoriesData) {
        categoryTitleLabel.text = model.name
        if let categoryType = CategoryType(rawValue: model.id) {
            setImageCategory(categoryType: categoryType)
        }
    }
    
    private func setImageCategory(categoryType: CategoryType) {
            switch categoryType {
            case .delivery:
                categoryImageView.image = UIImage(named: "delivery")
            case .dineOut:
                categoryImageView.image = UIImage(named: "dineOut")
            case .nightLife:
                categoryImageView.image = UIImage(named: "nightLife")
            case .catchingUp:
                categoryImageView.image = UIImage(named: "catchingUp")
            case .takeAway:
                categoryImageView.image = UIImage(named: "takeAway")
            case .cafes:
                categoryImageView.image = UIImage(named: "cafes")
            case .dailyMenus:
                categoryImageView.image = UIImage(named: "dailyMenus")
            case .breakfast:
                categoryImageView.image = UIImage(named: "breakfast")
            case .lunch:
                categoryImageView.image = UIImage(named: "lunch")
            case .dinner:
                categoryImageView.image = UIImage(named: "dinner")
            case .pubsBars:
                categoryImageView.image = UIImage(named: "pubsBars")
            case .pocketFriendlyDelivery:
                categoryImageView.image = UIImage(named: "pocketFriendlyDelivery")
            case .clubsLounges:
                categoryImageView.image = UIImage(named: "clubsLounges")
        }
    }
}


