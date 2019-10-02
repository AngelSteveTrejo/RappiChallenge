//
//  Localizable.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation

enum RestaurantCellText: String, LocalizableDelegate {
    case ratingDetailTitle
    case localityTitle
}

enum HomeViewText: String, LocalizableDelegate {
    case allPlacesTitle
    case topCategoriesTitle
    case mostPopularTitle
    case restaurantsTitle
}

enum SearchViewText: String, LocalizableDelegate {
    case placeHolderTitle
    case locationTitle
    case searchRestaurantsTitle
    case recentlyViewedTitle
}

enum RestaurantViewText: String, LocalizableDelegate {
    case restaurantsTitle
}

enum DetailViewText: String, LocalizableDelegate {
    case buttonDirectionsTitle
    case locationLabelTitle
    case addresslabelTitle
}


