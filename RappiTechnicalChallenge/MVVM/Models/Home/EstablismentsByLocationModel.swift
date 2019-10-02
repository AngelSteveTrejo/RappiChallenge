//
//  EstablismentsByLocationModel.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//

import Foundation

// MARK: - EstablismentsByLocationModel
struct EstablismentsByLocationModel: Decodable {
    let nearbyRestaurants: [NearbyRestaurant]
}

// MARK: - NearbyRestaurant
struct NearbyRestaurant: Decodable {
    let restaurant: NearbyRestaurantModel
}

// MARK: - Restaurant
struct NearbyRestaurantModel: Decodable {
    let id, name: String
    let url: String
    let location: RestaurantLocation
    let cuisines: String
    let priceRange: Int
    let userRating: UserRating
    let featuredImage: String
    let isDeliveringNow: Int
}

// MARK: - RestaurantLocation
struct RestaurantLocation: Decodable {
    let address, locality, city: String
    let cityId: Int
    let latitude, longitude, zipcode: String
    let countryId: Int
    let localityVerbose: String
}

// MARK: - HasMenuStatus
struct HasMenuStatus: Decodable {
    let delivery, takeaway: Int
}

// MARK: - UserRating
struct UserRating: Decodable {
    let aggregateRating, ratingText, ratingColor: String
    let ratingObj: RatingObj
    let votes: String
}

// MARK: - RatingObj
struct RatingObj: Decodable {
    let title: Title
    let bgColor: BgColor
}

// MARK: - BgColor
struct BgColor: Decodable {
    let type, tint: String
}

// MARK: - Title
struct Title: Decodable {
    let text: String
}
