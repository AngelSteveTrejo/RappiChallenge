//
//  MostPopularRestaurantModel.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation

// MARK: - MostPopularRestaurantModel
struct MostPopularRestaurantModel: Decodable {
    let collections: [RestaurantCollectionModel]
}

// MARK: - CollectionElement
struct RestaurantCollectionModel: Decodable {
    let collection: RestaurantModel
}

// MARK: - CollectionCollection
struct RestaurantModel: Decodable {
    let title, description, imageUrl: String
    let collectionId: Int
}
