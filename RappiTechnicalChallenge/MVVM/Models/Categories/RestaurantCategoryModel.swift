//
//  RestaurantCategoryModel.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/30/19.
//

import Foundation
import UIKit

// MARK: - RestaurantCategoryModel
struct RestaurantCategoryModel: Decodable {
    let restaurants: [RestaurantElement]
}

// MARK: - RestaurantElement
struct RestaurantElement: Decodable {
    let restaurant: RestaurantData
}

// MARK: - RestaurantRestaurant
struct RestaurantData: Decodable {
    let id, name: String
    let url: String
    let featuredImage: String
    let location: Location
    let cuisines: String
    let priceRange: Int
    let isDeliveringNow: Int
    let timings: String
}

// MARK: - Location
struct Location: Decodable {
    let address, locality, city: String
    let cityId: Int
    let latitude, longitude: String
    let localityVerbose: String
}

// MARK: - UserRating
struct UserRatingRestaurant: Decodable {
    let aggregateRating, ratingText: String
    let votes: String
}

// MARK: - Title
struct CategoryTitle: Decodable {
    let text: String
}
